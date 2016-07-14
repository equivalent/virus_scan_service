require 'open3'
module VirusScanService
  class KasperskyRunner
    class LinuxExecutor
      def scan(file_path, log_path)
	stdout, stderr, status = Open3.capture3(
         "sudo /opt/kaspersky/kes4lwks/bin/kes4lwks-control --scan-file #{file_path.to_s}"
        )
        File.open(log_path.to_s, 'w') { |file| file.write(stdout) }
      end
    end
  end
end
