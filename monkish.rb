# monkish

require 'json'
require './secrets.rb'


def get_auth_token
  auth_token = `curl -XPOST -H "Accept: application/json" -d "username=#{@username}&password=#{@pw}" 'https://api.robinhood.com/api-token-auth/'`
  JSON.parse(auth_token)["token"]
end

@auth_token = get_auth_token
puts "The auth token is #{@auth_token}"

# `curl -v "Accept: application/json" 'https://api.robinhood.com/quotes/?symbols=MSFT,FB,TSLA'`