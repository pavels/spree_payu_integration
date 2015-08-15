# -*- encoding : utf-8 -*-
require 'singleton'

module SpreePayuIntegration

  class Configuration

    include Singleton

    class << self
      attr_accessor :merchant_pos_id, :signature_key , :pos_auth_key, :language

      def configure(file_path = nil)
        set_defaults
        if block_given?
          yield self
        else
          file = File.open(file_path) if file_path && File.exists?(file_path)
          env = defined?(Rails) ? Rails.env : ENV['RACK_ENV']
          config = YAML.load(file)[env]
          if config.present?
            config.each_pair do |key, value|
              send("#{key}=", value)
            end
          end
        end
        valid?
      end

      def set_defaults
        @language = 'cs'
      end

      def required_parameters
        [:merchant_pos_id, :signature_key, :pos_auth_key]
      end

      def valid?
        required_parameters.each do |parameter|
          if send(parameter).nil? || send(parameter).blank?
            raise WrongConfigurationError, "Parameter #{parameter} is invalid."
          end
        end
        true
      end

    end
  end

end