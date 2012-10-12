module Integrator
  class Base
    class << self
      def find(id)
        response = Client.get subject: self, trailing: id

        process_response(response) do |response|
          new(response) if !response.empty?
        end

      end

      
      def all
        response = Client.get subject: self

        process_response(response) do |response|
          response.collect do |item|
            new(item)
          end
        end

      end
      
      def count
        response = Client.get subject: self, trailing: 'count'
        process_response(response) do |response|
          response['count'].to_i
        end
      end
      
      def process_response(response, &block)
        if !response.include?('error')
          yield response
        else
          if /Token/i =~ response['error']
            raise InvalidToken.new response['error']
          end
        end
      end
    
    end
    
    def initialize(hash)
      hash.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key.to_sym)
      end
    end
  end
end
