module ApiAuth

  # :nodoc:
  class ApiAuthError < StandardError; end

  # Raised when the request date is too far in the past (more than 15 minutes old)
  class RequestTooOld < ApiAuthError; end

  # Raised when the HTTP request object passed is not supported
  class UnknownHTTPRequest < ApiAuthError; end

end
