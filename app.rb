require "sinatra"
require "sinatra/reloader"
require "http"

api_url = "http://api.exchangerate.host/live?access_key=#{ENV["EXCHANGE_KEY"]}"


get("/") do
  raw_data = HTTP.get(api_url)
  
  parsed_data = JSON.parse(raw_data)
  
  @currency_quotes = parsed_data.fetch("quotes")
  erb(:home)
end

get("/:from_currency") do
  raw_data = HTTP.get(api_url)
  
  parsed_data = JSON.parse(raw_data)

  @currency_quotes = parsed_data.fetch("quotes")

  @original_currency = params.fetch("from_currency")
  
  erb(:currency_landing)
end

get("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")

  @destination_currency = params.fetch("to_currency")

  conversion_api_url = "http://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"

  raw_conversion_data = HTTP.get(conversion_api_url)
  
  parsed_conversion_data = JSON.parse(raw_conversion_data)

  conversion_info = parsed_conversion_data.fetch("info")

  @quote = conversion_info.fetch("quote")

  erb(:conversion)
end
