module Integrator
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copy integrator initializer into your rails application'
      source_root File.expand_path '../templates', __FILE__
      
      def copy_initializer
        copy_file 'integrator.rb', 'config/initializers/integrator.rb'
      end
    end
  end
end
