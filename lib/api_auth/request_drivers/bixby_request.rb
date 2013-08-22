
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
        @headers["authorization"] = header
        @request
      end

      def calculated_md5
        Digest::MD5.base64digest(@request.body || '')
      end

      def populate_content_md5
        @headers["content-md5"] = calculated_md5
      end

      def md5_mismatch?
        calculated_md5 != content_md5
      end

      def content_type
        value = @headers["content-type"]
        value.nil? ? "" : value
      end

      def content_md5
        value = @headers["content-md5"]
        value.nil? ? "" : value
      end

      def request_uri
        @request.id
      end

      def set_date
        @request.headers["date"] = time_as_httpdate
      end

      def timestamp
        value = @headers["date"]
        value.nil? ? "" : value
      end

      def authorization_header
        @headers["authorization"]
      end

    end

  end
end
