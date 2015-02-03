module VirusScanService
  class KasperskyRunner
    class WindowsExecutor
      def scan(file_path, log_path)
        system(*%W{avp.com SCAN #{file_path} /i4 /fa /RA:#{log_path}})
      end
    end
  end
end
