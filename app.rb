require_relative 'config/environment'

$channel = EM::Channel.new

EventMachine.run do

  class Chat < Sinatra::Base
    helpers Sinatra::SessionHelper

    enable :sessions
    set :views, Proc.new { File.join(root, "app", "views") }

    get '/' do
      erb :index
    end

    post '/chat' do
      user = User.find_or_create_by_username(params[:username].downcase)
      login(user)
      redirect "/chat/#{user.id}"
    end

    get '/chat/:user_id' do
      puts current_user
      @user = User.find_by_id(params[:user_id])
      login(@user)
      erb :chat
    end
  end

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    def current_user(id) #this is a hack. I should refine
      User.find_by_id(id)
    end


    ws.onopen {
      sid = $channel.subscribe { |msg| ws.send msg }
      $channel.push "#{sid} connected!"

      ws.onmessage { |msg|
        user_id = msg.match(/<\d+>/).to_s[1..-2] #this is a hack. I should refine this.
        user = current_user(user_id)
        msg.gsub!(/<\d+>/, "")
        user.messages.create(body: msg)
        $channel.push "#{user.username}: #{msg}"
      }

      ws.onclose {
        $channel.unsubscribe(sid)
      }
    }

  end

  Chat.run!({:port => 80}) 
end

