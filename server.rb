require "slack"
require "sinatra"
require "sinatra/reloader" if development?
require "dotenv"

Dotenv.load

CITIES = {
  "sf" => "San Francisco",
  "la" => "Los Angeles",
  "nyc" => "New York City",
  "chicago" => "Chicago",
}

get "/" do
  erb :index
end

get "/channels" do
  client = Slack::Client.new token: ENV["SLACK_TOKEN"]

  channels = client.channels_list["channels"]
  groups = client.groups_list["groups"]

  @product_channels = []
  @snoozed_product_channels = []
  @skill_channels = []
  @city_channels = []

  channels.each do |channel|
    next if channel["is_archived"] || channel["is_general"]

    if channel["name"] =~ /^dp_/
      @skill_channels << channel
    else
      if CITIES.include? channel["name"]
        @city_channels << channel
      else
        if channel["name"] =~ /^zzz_/
          @snoozed_product_channels << channel
        else
          @product_channels << channel
        end
      end
    end
  end

  @groups = []
  @city_groups = []

  groups.each do |group|
    next if group["is_archived"] || group["name"] =~ /^mpdm/

    if CITIES.keys.any? { |c| group["name"] == "#{c}_organizers" }
      @city_groups << group
    else
      @groups << group
    end
  end

  erb :channels
end
