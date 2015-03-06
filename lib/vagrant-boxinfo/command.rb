module Vagrant
  module Boxinfo
    class Command < Vagrant.plugin('2', :command)
      def self.synopsis
        'The `boxinfo` command provides information about boxes based on metadata.json.'
      end

      def execute
        options = {}

        opts = OptionParser.new do |o|
          o.banner = 'Usage: vagrant boxinfo <name or url>'
          o.separator ''
        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv

        if argv.empty? || argv.length > 1
          raise Vagrant::Errors::CLIInvalidUsage,
                help: opts.help.chomp
        end

        arg = argv[0]
        url = if arg.start_with?('http://', 'https://')
                arg
              else
                get_metadata_url(arg)
              end

        @env.ui.info("Reading url #{url}...")

        print_info(download(url))

        0
      end

      private
      def get_metadata_url(box_name)
        fail BoxinfoError, "Box '#{box_name}' not found" unless local_box_exists?(box_name)
        filename = @env.boxes.directory.join(box_name).join('metadata_url')

        fail BoxinfoError, "Local metadata file '#{filename}' does not exist. " +
                               "Maybe this box was not downloaded via metadata " +
                               "json ...?" unless File.exists?(filename)

        File.read(filename).strip
      end

      def print_info(remote_boxes_metadata)
        box_name = remote_boxes_metadata[:name]

        @env.ui.info("Box name: #{box_name}")
        @env.ui.info("Description: #{remote_boxes_metadata[:description]}")
        @env.ui.info("\n")

        remote_boxes_metadata[:versions].sort_by { |b| b[:version] }.reverse_each do |box|
          @env.ui.info("#{box[:version]}")
          box.each do |k, v|
            next if %i(providers version).include?(k)

            @env.ui.info("\t #{k}: #{v}")
          end

          @env.ui.info("\t downloaded: #{local_box_version_exists?(box_name, box[:version])}")
        end
      end

      def local_box_exists?(name)
        @env.boxes.all.map(&:first).include?(name)
      end

      def local_box_version_exists?(name, version)
        @env.boxes.all.map { |b| [b[0], b[1]]}.include?([name, version])
      end

      def download(url)
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)

        fail BoxinfoError, "Error downloading #{url}" if response.code != '200'

        JSON.parse(response.body, symbolize_names: true)
      rescue JSON::ParserError
        raise BoxinfoError, "Error parsing downloaded JSON from #{url}"
      end
    end
  end
end