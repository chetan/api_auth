module ApiAuth

  # Builds the canonical string given a request object.
  class Headers

    include RequestDrivers

    def initialize(request)
      @original_request = request

      case request.class.to_s
      when /Net::HTTP/
        @request = NetHttpRequest.new(request)
      when /RestClient/
        @request = RestClientRequest.new(request)
      when /Curl::Easy/
        @request = CurbRequest.new(request)
      when /ActionController::Request/
        @request = ActionControllerRequest.new(request)
      when /ActionDispatch::TestRequest/
        if defined?(ActionDispatch)
          @request = ActionDispatchRequest.new(request)
        else
          @request = ActionControllerRequest.new(request)
        end
      when /ActionDispatch::Request/
        @request = ActionDispatchRequest.new(request)
      when /HTTPI::Request/
        @request = HttpiRequest.new(request)
      when /Rack::Request/
        @request = RackRequest.new(request)
      else
        raise UnknownHTTPRequest, "#{request.class.to_s} is not yet supported."
      end
      true
    end

    # Returns the request timestamp
    def timestamp
       @request.timestamp
    end

    # Returns the canonical string computed from the request's headers
    def canonical_string
      [ @request.content_type,
        @request.content_md5,
        @request.request_uri.gsub(/http:\/\/[^(,|\?|\/)]*/,''), # remove host
        @request.timestamp
      ].join(",")
    end

    # Returns the authorization header from the request's headers
    def authorization_header
      @request.authorization_header
    end

    def set_date
      @request.set_date if blank? @request.timestamp
    end

    def calculate_md5
      @request.populate_content_md5 if blank? @request.content_md5
    end

    def md5_mismatch?
      if blank? @request.content_md5
        false
      else
        @request.md5_mismatch?
      end
    end

    # Sets the request's authorization header with the passed in value.
    # The header should be the ApiAuth HMAC signature.
    #
    # This will return the original request object with the signed Authorization
    # header already in place.
    def sign_header(header)
      @request.set_auth_header header
    end


    private

    # Test if the given string is nil or empty
    # Rails compat fix
    def blank?(str)
      str.nil? or str.empty?
    end

  end

end
