# frozen_string_literal: true

require 'yaml'

module Prawn
  class LabelSheet
    # config options
    class Configuration
      # Default layout key
      # @return [String] the default key
      attr_accessor :default_layout
      attr_writer :layouts

      def initialize
        @default_layout = 'Avery7160'
      end

      # Layout definitions
      #
      # @return [{String => Hash}]
      def layouts
        @layouts ||= YAML.load_file(File.expand_path('layouts.yml', __dir__))
      end
    end

    class << self
      attr_writer :config

      # Current configuration
      #
      # @return [Prawn::LabelSheet::Configuration]
      def config
        @config ||= Configuration.new
      end

      # Modify configuration
      #
      # @yieldparam config [Prawn::LabelSheet::Configuration]
      def configure
        yield config
      end
    end
  end
end
