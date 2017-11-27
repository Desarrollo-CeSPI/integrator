module Integrator
  class Department < Nested
    attr_reader :id, :name, :state_id
    
    def to_s
      name
    end
    
    def state
      @_state ||= State.find(state_id)
    end
    
    def cities
      get_and_hydrate_collection City, subject: [state.country, state, self, City]
    end
  end
end
