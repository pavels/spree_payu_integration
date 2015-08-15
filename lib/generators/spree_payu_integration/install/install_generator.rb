module SpreePayuIntegration
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def add_initializer
        copy_file "spree_payu.rb", "config/initializers/spree_payu.rb"
      end
    end
  end
end
