require 'httparty'
require 'nokogiri'

valid = false
while valid == false
system('clear')
puts "\nWelcome to Mike's stock price lookup!"
puts "Please provide a stock ticker:\n\n"
print ">> "
ticker = gets.chomp.downcase
puts "\n L O A D I N G\n\n"

url = "http://finance.yahoo.com/q?s=#{ticker}"

response = HTTParty.get url

dom = Nokogiri::HTML(response.body)
  dom.xpath("//h2").each do |x|
    if x.text == "There are no results for the given search term."
      puts "That ticker isn't listed on Yahoo! Finance."
      sleep 1
      valid = false
      break
    else
      valid = true
    end
  end
  if valid == true
    dom.xpath("//h1").each do |x|
      # p x.text[0...22]
      # p "Get Quotes Results for"
      # p x.text == "Get Quotes Results for #{ticker[0...22]}"
      if x.text[0...22] == "Get Quotes Results for"
        puts "That ticker isn't listed on Yahoo! Finance."
        sleep 1
        valid = false
        break
      else
        valid = true
      end
    end
  end
end
if valid
  name = dom.xpath("//h2")[2].content
  price = dom.xpath("//span[@id='yfs_l84_#{ticker}']").first.content.to_f
  prev_close_price = dom.xpath("//td[@class='yfnc_tabledata1']").first.content.to_f
  puts "The current stock price for #{name} is $#{price}."
  puts "It closed at $#{prev_close_price} yesterday.\n\n"
end
