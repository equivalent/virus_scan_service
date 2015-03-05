module VirusScanService
  class Courier
    RequestNotSuccessful = Class.new(StandardError)

    include BuildHttp

    attr_reader :token
    attr_accessor :num_of_scans, :logger

    def initialize(options)
      @token      = options.fetch(:token)
      @host  = options.fetch(:host)
      @num_of_scans = 1
      @logger = DefaultLogger.new
    end

    def call
      scheduled_scans
        .first(num_of_scans)
        .each do |scheduled_scan|
          result = yield(scheduled_scan.fetch('file_url'))
          update_scan_result(scheduled_scan.fetch('id'), result)
        end
    end

    private

    def uri
      @uri ||= URI.parse(@host)
    end

    def scheduled_scans
      uri.path = '/wd/virus_scans'
      logger.info "GET #{uri.to_s}"

      http = build_http
      scans_req = Net::HTTP::Get.new(uri.to_s)
      scans_req.add_field("Authorization", "Token #{token}")
      scans_req['Accept'] ='application/json'

      response = http.request(scans_req)

      check_status(response) {
        response.body  # array of virus_scans
      }
    end

    def update_scan_result(scan_id, result)
      uri.path = "/wd/virus_scans/#{scan_id}"
      logger.info "PUT #{uri.to_s}"

      http = build_http

      scan_push_req = Net::HTTP::Put.new(uri.to_s)
      scan_push_req.add_field("Authorization", "Token #{token}")
      scan_push_req['Accept'] = 'application/json'
      scan_push_req.add_field('Content-Type', 'application/json')
      scan_push_req
        .body = {"virus_scan" => {'scan_result' => result}}
        .to_json

      response = http.request(scan_push_req)

      check_status(response) {
        response.body  # result JSON
      }
    end

    def json(body)
      logger.debug "Response body #{body}"
      JSON.parse(body)
    end

    def check_status(response)
      if response.class == Net::HTTPOK
        logger.info "Response status OK 200"
        json(yield)
      else
        logger.info "Response status #{response.class}"
        logger.info yield
        raise RequestNotSuccessful
      end
    end
  end
end
