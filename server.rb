require "slack"
require "sinatra"
require "sinatra/reloader" if development?
require "dotenv"

Dotenv.load

get "/" do
  erb :index
end

get "/channels" do
  client = Slack::Client.new token: ENV["SLACK_TOKEN"]

  @channels = client.channels_list["channels"]

  erb :channels
end
