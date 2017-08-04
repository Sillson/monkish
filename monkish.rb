# monkish

require 'csv'
require 'json'
require './secrets.rb'
require './watchlist.rb'


def get_auth_token
  auth_token = `curl -XPOST -H "Accept: application/json" -d "username=#{@username}&password=#{@pw}" #{@auth_url}`
  JSON.parse(auth_token)["token"]
end

def get_yearly_ticker_data(sym)
  raw = `curl -v "Accept: application/json" "#{@historical_url}?symbols=#{sym}&interval=day"`
  result = JSON.parse(raw)["results"][0]
end

def yearly_ticker_headers
  ["SYMBOL", "BEGINS_AT", "OPEN_PRICE", "CLOSE_PRICE", "HIGH_PRICE", "LOW_PRICE"]
end

def write_yearly_data_to_csv(res)
  sym = res["symbol"]
  his = res["historicals"]

  CSV.open("./historical_csvs/#{sym}_#{Time.now.strftime('%Y-%m-%d')}.csv", "wb", write_headers: true, headers: yearly_ticker_headers) do |csv|
    his.each do |row|
      csv << ["#{sym}", row["begins_at"], row["open_price"], row["close_price"], row["high_price"], row["low_price"]]
    end
  end
end

def build_historical_csv(sym)
  res = get_yearly_ticker_data(sym)
  
  unless res["symbol"].empty?
    write_yearly_data_to_csv(res)
  else
    puts "stock does not exist"
  end
end

def capture_watchlist
  WATCHLIST.each do |sym|
    puts "Capturing #{sym} and parsing to csv..."
    build_historical_csv(sym)
  end
end

puts 'Capturing watchlist...'
capture_watchlist

# @auth_token = get_auth_token
# puts "The auth token is #{@auth_token}"


