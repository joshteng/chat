require_relative 'config/environment'

$channel = EM::Channel.new

EventMachine.run do
  helpers
  class Chat < Sinatra::Base
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
      @user = User.find_by_id(params[:user_id])
      login(@user)
      erb :chat
    end
  end

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    ws.onopen {
      sid = $channel.subscribe { |msg| ws.send msg }
      $channel.push "#{current_user.username} connected!"

      ws.onmessage { |msg|
        current_user.messages.create(body: msg)
        $channel.push "#{current_user.username}: #{msg}"
      }

      ws.onclose {
        $channel.unsubscribe(sid)
      }
    }

  end

  Chat.run!({:port => 3000}) 
end

