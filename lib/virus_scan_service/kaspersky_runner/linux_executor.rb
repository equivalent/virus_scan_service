module VirusScanService
  class KasperskyRunner
    class LinuxExecutor
      def scan(file_path, log_path)
        system ['sudo',
          '/opt/kaspersky/kes4lwks/bin/kes4lwks-control',
          '--scan-file',
          file_path.to_s,
          ">>",
          log_path.to_s]
      end
    end
  end
end
