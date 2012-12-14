require 'rack'
require 'net/http'
require 'broker/request'
require 'broker/request_handler'

module Broker
	class Proxy
		def call(env)
			handler = RequestHandler.new
			handler.handle(Request.new(env)) {|response| [response.code, response, [response.body]] }			
		end
	end
end