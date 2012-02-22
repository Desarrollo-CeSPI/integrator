module Integrator
  class Base
    class << self
      def find(id)
        response = Client.get subject: self, trailing: id
        
        new(response)
      end
      
      def all
        response = Client.get subject: self
        
        response.collect do |item|
          new(item)
        end
      end
      
      def count
        response = Client.get subject: self, trailing: 'count'
        
        response['count'].to_i
      end
    end
    
    def initialize(hash)
      hash.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key.to_sym)
      end
    end
  end
end
