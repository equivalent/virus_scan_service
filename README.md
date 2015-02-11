[![Build Status](https://travis-ci.org/equivalent/virus_scan_service.svg)](https://travis-ci.org/equivalent/virus_scan_service)
[![Code Climate](https://codeclimate.com/github/equivalent/virus_scan_service/badges/gpa.svg)](https://codeclimate.com/github/equivalent/virus_scan_service)
[![Test Coverage](https://codeclimate.com/github/equivalent/virus_scan_service/badges/coverage.svg)](https://codeclimate.com/github/equivalent/virus_scan_service)

# VirusScanService

Service gem that provide virus scan runner that will pull down list of
files to be scanned from your application server, lunch antivirus check (currently only
Kasperky Endponit Security runner Windows or Linux) and send scan result
back to server.

You don't need to have this script running on the same server
as application server VM. (Article comming soon)

Originaly built to work along [witch_doctor engine gem](https://github.com/equivalent/witch_doctor)
however that is not required. All your server has to do
is provide API that this secvice can comunicate with:

#### GET `/wd/virus_scans` `ContentType: application/json`

response

```json
[{"id":"123","scan_result":"","file_url":"http://thisis.test/download/file.png"}]
```

#### PUT `/wd/virus_scans/123` `ContentType: application/json`

request body

```json
{"virus_scan":{"scan_result":"Clean"}}
```

response

```json
{"id":"123","scan_result":"Clean","file_url":"http://thisis.test/download/file.png"}
```

For more examples check `spec/courier_spec.rb`, `spec/support/request_response_mocks.rb


## Statuses

* `Clean`
* `VirusInfected`
* `FileDownloadError` - couldn't download asset

## Installation

Add this line to your external script Gemfile:

    gem 'virus_scan_service'

And then execute:

    $ bundle

## Usage

check https://github.com/equivalent/virus_scan_daemon

## Contributing

1. Fork it ( https://github.com/[my-github-username]/virus_scan_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
