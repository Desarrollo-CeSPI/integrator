module Integrator
  module HasMethods
    def has_integrator_attribute(class_as_sym, attributes = {})
      if !attributes.is_a? Hash
        attributes = { attributes => nil }
      end
      
      attributes.each do |k, v|
        method_name = v.nil? ? class_as_sym : v

        define_method method_name do
          eval("Integrator::#{class_as_sym.to_s.camelize}").find(send(k).to_s)
        end
      end
    end
  end
end

