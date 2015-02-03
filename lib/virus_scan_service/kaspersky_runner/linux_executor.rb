module VirusScanService
  class KasperskyRunner
    class LinuxExecutor
      # not tested on real production as I'm using windows VM for virus scans
      def scan(file_path, log_path)
        system 'sudo',
          '/opt/kaspersky/kes4lwks/bin/kes4lwks-control',
          '--scan-file',
          file_path.to_s,
          ">>",
          log_path.to_s
      end
    end
  end
end
