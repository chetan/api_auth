module ApiAuth

  module Helpers # :nodoc:

    # Remove the ending new line character added by default
    def b64_encode(string)
      Base64.encode64(string).strip
    end

    # Capitalizes the keys of a hash
    def capitalize_keys(hsh)
      capitalized_hash = {}
      hsh.each_pair {|k,v| capitalized_hash[k.to_s.upcase] = v }
      capitalized_hash
    end

    def time_as_httpdate
      Helpers.time_as_httpdate
    end

    def self.time_as_httpdate
      Time.now.utc.strftime("%a, %d %b %Y %T GMT")
    end

  end

end
