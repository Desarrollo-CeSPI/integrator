module Integrator
  class Country < Base
    attr_reader :id, :name, :iso_code
    
    def to_s
      name
    end
    
    def states
      response = Client.get(subject: [self, State])
      
      response.collect do |item|
        State.new(item)
      end
    end
  end
end
