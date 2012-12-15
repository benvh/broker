module Broker
	class Proxy
		def call(env)
			handler = RequestHandler.new
			handler.handle(Request.new(env)) {|response| [response.code, response, [response.body]] }			
		end
	end


	@config = {
		:port => 8080
	}
	
	class << self
		attr_accessor :config
	end

	def self.configure		
		yield(self.config) if block_given?
	end
end