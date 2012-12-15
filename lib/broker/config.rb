Broker.configure do |config|
	config[:port] = 8081
	config[:url_map] = {
		:reddit => "http://reddit.com",
		:youtube => "http://youtube.com",
		:google => "http://google.com"
	}	
end