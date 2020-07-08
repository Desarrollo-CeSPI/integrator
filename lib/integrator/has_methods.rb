module Integrator
  module HasMethods
    def has_integrator_attribute(class_as_symbol, attributes = {})
      attributes = { attributes => nil } unless attributes.is_a? Hash

      attributes.each do |k, v|
        method_name = v || class_as_symbol

        define_method method_name do
          @_integrator_cache ||= {}
          @_integrator_cache[method_name] ||= Integrator.const_get(class_as_symbol.to_s.camelize).find(send(k).to_s)
        end
      end
    end
  end
end
