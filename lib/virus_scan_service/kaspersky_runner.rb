module VirusScanService
  class KasperskyRunner
    ScanLogPathNotSet = Class.new(StandardError)
    ScanLogParseError = Class.new(StandardError)

    include BuildHttp

    attr_reader :url, :result
    attr_accessor :scan_log_path

    def initialize(url)
      @url = url
    end

    def call
      pull_file
      scan_file
      set_result
      nil
    end

    def scan_file_path
      Pathname.new('.').join('tmp').join(filename)
    end

    private

    def set_result
      result = File.read(scan_log_path || raise(ScanLogPathNotSet))
      result.scan(/Total detected:\s*(\d+)/) do |threat_count, *other|
        if threat_count == ''
          raise ScanLogParseError
        elsif threat_count == '0'
          @result = 'Clean'
        else
          @result = 'VirusInfected'
        end
      end

      raise ScanLogParseError if @result.nil?
    end

    def scan_file
      system("avp.com SCAN #{scan_file_path} /i4 /fa /RA:#{scan_log_path}")
    end

    def pull_file
      http = build_http

      request = Net::HTTP::Get.new(uri.to_s)
      response = http.request(request)
      open(scan_file_path, 'wb') do |file|
        file.write(response.body)
        file.close
      end
    end

    def uri
      @uri ||= URI.parse(url)
    end

    def filename
      File.basename(uri.path)
    end
  end
end
