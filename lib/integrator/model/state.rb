module Integrator
  class State < Nested
    attr_reader :id, :name, :country_id

    def to_s
      name
    end
    
    def country
      @_country ||= Country.find(country_id)
    end
    
    def departments
      get_and_hydrate_collection Department, subject: [country, self, Department]
    end
  end
end
