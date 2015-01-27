module VirusScanService
  class KasperskyRunner
    attr_reader :url, :result

    def initialize(url)
      @url = url
    end

    def call
      pull_file

      # @todo run_scan
      
      @result = 'Clean'
      return result
    end

    def pull_file
      open("/tmp/#{filename}", 'wb') do |file|
        file << open(url).read
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
