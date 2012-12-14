require 'broker/request'
require 'net/http'

class RequestHandler
	def handle(request)				
		head = get_head(request)
		while (301..302) === head.code.to_i #Page moved...
			request = rewrite_moved_request(request, head)
			head = get_head(request)
		end

		response = get_response(request)
		return yield(response) if block_given?
		response
	end

	private
	def get_head(request)
		http = request.proxy.new( request.host ) #TODO: Add port
		http.head(request.full_path, request.headers)
	end

	def get_response(request)
		http = request.proxy.new( request.host )
		resp = http.get(request.full_path, request.headers)

		resp.delete "transfer-encoding"
		resp["content-length"] = resp.body.length
		resp
	end

	def rewrite_moved_request(request, headers)
		request.host = URI(headers["location"]).host
		request
	end
end