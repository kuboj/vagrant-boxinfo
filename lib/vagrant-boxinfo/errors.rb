module Vagrant
  module Boxinfo
    class  BoxinfoError < Vagrant::Errors::VagrantError
      def initialize(msg)
        @msg = msg
        super
      end

      def error_message
        @msg
      end
    end
  end
end