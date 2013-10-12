
module ApiAuth
  module RequestDrivers

    class BixbyRequest

      include ApiAuth::Helpers

      def initialize(request)
        @request = request
        @headers = request.headers
        true
      end

      def set_auth_header(header)
        @headers["Authorization"] = header
        @request
      end

      def calculated_md5
        Digest::MD5.base64digest(@request.body || '')
      end

      def populate_content_md5
        # Should *always* be a POST!
        @headers["Content-MD5"] = calculated_md5
      end

      def md5_mismatch?
        calculated_md5 != content_md5
      end

      def content_type
        value = @headers["Content-Type"]
        value.nil? ? "" : value
      end

      def content_md5
        value = @headers["Content-MD5"]
        value.nil? ? "" : value
      end

      def request_uri
        @request.path
      end

      def set_date
        @request.headers["Date"] = time_as_httpdate
      end

      def timestamp
        value = @headers["Date"]
        value.nil? ? "" : value
      end

      def authorization_header
        @headers["Authorization"]
      end

    end

  end
end
