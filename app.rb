require_relative 'config/environment'

$channel = EM::Channel.new

EventMachine.run do
  class Chat < Sinatra::Base
    puts Sinatra::Application
    set :views, File.join(Sinatra::Application.root, "app", "views")

    get '/' do
      erb :index
    end
  end

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    ws.onopen {
      sid = $channel.subscribe { |msg| ws.send msg }
      $channel.push "#{sid} connected!"

      ws.onmessage { |msg|
        puts msg
        $channel.push "<#{sid}>: #{msg}"
      }

      ws.onclose {
        $channel.unsubscribe(sid)
      }
    }

  end

  Chat.run!({:port => 3000})
end
