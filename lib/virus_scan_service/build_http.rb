module VirusScanService
  module BuildHttp
    def build_http
      if uri.scheme == 'https'
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      else
        Net::HTTP.new(uri.host, uri.port)
      end
    end
  end
end
