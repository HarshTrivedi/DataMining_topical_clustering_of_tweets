require 'twitter'
require 'awesome_print'
require 'csv'
require 'nokogiri'

$rest_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["CONSUMER_KEY"]
        config.consumer_secret     = ENV["CONSUMER_SECRET"]
        config.access_token        = ENV["ACCESS_TOKEN"]
        config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
end


collected_tweets = []
hash_tags = ["#money", "#jostforfun", "#news", "#sports", "#science", "#entertainment"]

 def tweets_xml(tweets)
	builder = Nokogiri::XML::Builder.new do |xml|
	  xml.tweets {
	  	for tweet in tweets
	  		xml.tweet{
	  			xml.text  = tweet[0] # text
	  			xml.time  = tweet[1] # time
	  			xml.class = tweet[2] # class
	  		}
	  	end
	  }
	end 	
 end

for hash_tag in hash_tags
    collected_tweets += $rest_client.search( hash_tag, lang: "en" , result_type: "recent").take(5000).map{|x| [x.text , x.created_at, hash_tag] }
	File.open("./collected_tweets.xml" , "w+") do |file|
		file.puts tweets_xml(collected_tweets).to_xml
	end
	ap "Done #{hash_tag}"
end

