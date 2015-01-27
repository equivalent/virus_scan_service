# Usage example :
#
#  VirusScansService
#   .new(token: 'abcdefg', host: 'https://212.95.239.252')
#   .scan(1)
#
module VirusScanService
  class Courier
    RequestNotSuccessful = Class.new(StandardError)

    attr_reader :token
    attr_accessor :num_of_scans

    def initialize(options)
      @token      = options.fetch(:token)
      @host  = options.fetch(:host)
      @num_of_scans = 1
    end

    def call
      scheduled_scans
        .first(num_of_scans)
        .each do |scheduled_scan|
          resoult = yield(scheduled_scan.fetch('file_url'))
          update_scan_result(scheduled_scan.fetch('id'), resoult)
        end
    end

    private

    def uri
      @uri ||= URI.parse(@host)
    end

    def scheduled_scans
      uri.path = '/virus_scans'

      scans_req = Net::HTTP::Get.new(uri.to_s)
      scans_req.add_field("Authorization", "Token #{token}")
      scans_req['Accept'] ='application/json'

      response = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(scans_req)
      }

      check_status(response) {
        response.body  # array of virus_scans
      }
    end

    def update_scan_result(scan_id, result)
      uri.path = "/virus_scans/#{scan_id}"

      scan_push_req = Net::HTTP::Put.new(uri.to_s)
      scan_push_req.add_field("Authorization", "Token #{token}")
      scan_push_req['Accept'] = 'application/json'
      scan_push_req.add_field('Content-Type', 'application/json')
      scan_push_req
        .body = {"virus_scan" => {'scan_result' => result}}
        .to_json

      response = Net::HTTP.start(uri.host, uri.port) { |http|
        http.request(scan_push_req)
      }

      check_status(response) {
        response.body  # result JSON
      }
    end

    def json(body)
      JSON.parse(body)
    end

    def check_status(response)
      if response.class == Net::HTTPOK
        json(yield)
      else
        puts "Response status is #{response.class}"
        puts yield
        raise RequestNotSuccessful
      end
    end
  end
end
