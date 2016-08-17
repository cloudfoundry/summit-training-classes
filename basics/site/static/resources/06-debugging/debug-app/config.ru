require "sinatra/base"
require "json"

require "newrelic_rpm"
NewRelic::Agent.manual_start

class Web < Sinatra::Base
  helpers do
    def stop
      ->() {
        pid = Process.pid
        signal = "INT"
        puts "Killing process #{pid} with signal #{signal}"
        Process.kill(signal, pid)
      }
    end
  end

  get "/" do
    raise "I am a bug, fix me" unless ENV.has_key?("FIXED")

    instance = ENV.fetch("CF_INSTANCE_INDEX", 0)
    addr = ENV.fetch("CF_INSTANCE_ADDR", "127.0.0.1")

    %{
      <h1>Hi, I'm app instance #{instance}</h1>
      <h2>I am running at #{addr}</h2>
      <h3>
        <a href="/crash">Crash me</a>
      </h3>
    }
  end

  get "/env.json" do
    content_type "application/json"
    JSON.pretty_generate(ENV.to_h)
  end

  get "/crash" do
    stop.()
    %{
      <h2>Oh no! I've crashed!</h2>
      <h3><a href="/">Check if an app instance is available</a></h3>
    }
  end
end

run Web.new
