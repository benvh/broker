require 'net/http'
require 'ostruct'

module Broker
	class Request
		attr_reader :method, :host, :path, :headers, :query_params
		attr_writer :host, :headers, :query_params, :data

		@@proxy = nil

		def initialize(env)
			if @@proxy == nil
				proxy_uri = ENV['http_proxy'] ? URI.parse(ENV['http_proxy']) : OpenStruct.new
				@@proxy = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port)
			end

			@uri = URI(BASE_URI + env["REQUEST_URI"])
			@method = env["REQUEST_METHOD"]
			@host = @uri.host
			@path = @uri.path
			@headers = extract_headers(env)
			@query_params = extract_query_params(env)
		end

		def full_path
			@path + (!@query_params.empty? ? "?"+@query_params.collect {|k,v| "#{k}=#{v}"}.join("&") : "")
		end

		def proxy
			@@proxy
		end

		private
		def extract_headers(env)
			headers = {}
			env.each do |k,v|
				k.gsub(/^(HTTP_.+)$/) {|match| headers[k] = v}				
			end			
			headers
		end

		def extract_query_params(env)
			Hash[ *env["QUERY_STRING"].split("&").collect {|v| v.split("=")}.flatten! ]
		end

	end
end