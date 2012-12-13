require 'rack'
require 'net/http'
require 'ostruct'

module Broker
	class Server

		def call(env)
			response = get_response(env)
			[response.code, response, [response.body]]
		end

		def get_headers(env)
			headers = {}
			env.each do |k,v|
				k.gsub(/^(HTTP_.+)$/) {|match| headers[k] = v}				
			end			
			headers
		end

		def get_query_params(env)
			Hash[ *env["QUERY_STRING"].split("&").collect {|v| v.split("=")}.flatten! ]
		end

		def get_response(env)			
			uri = URI("http://reddit.com" + env["REQUEST_URI"])			
			headers = get_headers(env)
			params = get_query_params(env)

			response = get_request_response(uri, headers, params)
			while response.code.to_i == 301 or response.code.to_i == 302 do #MOVED LOL
				new_location_uri = URI(response["location"])				
				new_uri_string = "http://" + new_location_uri.host + env["REQUEST_URI"]
				response = get_request_response( URI(new_uri_string), headers, params )
			end	
			response			
		end

		def get_request_response(uri, headers, query_params)
			proxy_uri = ENV['http_proxy'] ? URI.parse(ENV['http_proxy']) : OpenStruct.new
			http = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port).new(uri.host, uri.port)

			uri_path = uri.path + (!query_params.empty? ? "?" + query_params.collect {|k,v| "#{k}=#{v}"}.join("&") : "")
			puts uri_path
			
			response = http.get(uri_path, headers)			

			#remove these headers... does mongrel fix this?
			response["transfer-encoding"] = nil
			response["content-length"] = response.body.length
			response	
		end

	end
end