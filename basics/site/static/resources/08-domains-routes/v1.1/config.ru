require "sinatra/base"
require "json"

class Web < Sinatra::Base
  get "/" do
    %{
      <h1>Hi, I'm v1.1</h1>
    }
  end
end

run Web.new
