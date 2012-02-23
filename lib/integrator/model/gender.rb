module Integrator
  class Gender < Base
    attr_reader :id, :name
    
    def to_s
      name
    end
  end
end
