require "slack"
require "sinatra"
require "sinatra/reloader" if development?
require "dotenv"

Dotenv.load

get "/" do
  erb :index
end
