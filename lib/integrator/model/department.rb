module Integrator
  class Department < Nested
    attr_reader :id, :name, :state_id
    
    def state
      State.find(state_id)
    end
    
    def cities
      response = Client.get(subject: [state.country, state, self, City])
      
      response.collect do |item|
        City.new(item)
      end
    end
  end
end
