module Integrator
  class State < Nested
    attr_reader :id, :name, :country_id
    
    def country
      Country.find(country_id)
    end
    
    def departments
      response = Client.get(subject: [country, self, Department])
      
      response.collect do |item|
        Department.new(item)
      end
    end
  end
end
