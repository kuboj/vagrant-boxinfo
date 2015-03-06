require 'vagrant'

module Vagrant
  module Boxinfo
    class Plugin < Vagrant.plugin('2')
      name 'boxinfo command'
      description 'The `boxinfo` command provides information about boxes based on metadata.json.'

      command 'boxinfo' do
        require_relative 'command'
        Command
      end
    end
  end
end