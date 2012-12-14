Gem::Specification.new do |s|
	s.name			= 'broker'
	s.version		= '0.0.1'
	s.date			= '2012-12-12'
	s.summary		= "Ima transfer yo requests!"
	s.description	= "A Daemon that forwards all http requests it receives"
	s.authors		= ["Ben Van Houtven"]
	s.email			= 'ben@vanhoutven.org'	
	s.homepage		= 'htpt://rubygems.org/gems/broker'

	s.add_dependency "rack"
	s.add_dependency "mongrel"

	s.files			= ["bin/broker", "lib/broker.rb", "lib/broker/proxy.rb", "lib/broker/request.rb", "lib/broker/request_handler.rb"]
	s.executables	= ["broker"]
end
