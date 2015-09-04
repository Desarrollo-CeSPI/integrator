module Integrator
  class Country < Base
    attr_reader :id, :name, :iso_code
    
    def to_s
      name
    end
    
    def states
      get_and_hydrate_collection State, subject: [self, State]
    end
  end
end
