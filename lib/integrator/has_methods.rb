module Integrator
  module HasMethods
    def has_integrator_attribute(class_as_sym, attributes = {})
      attributes = { attributes => nil } unless attributes.is_a? Hash

      attributes.each do |k, v|
        method_name = v.nil? ? class_as_sym : v

        define_method method_name do
          @_integrator_cache ||= {}
          @_integrator_cache[method_name] ||= eval("Integrator::#{class_as_sym.to_s.camelize}").find(send(k).to_s)
        end
      end
    end
  end
end
