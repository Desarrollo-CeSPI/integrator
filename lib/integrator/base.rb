module Integrator
  class Base
    class << self
      def find(id)
        response = Client.get subject: self, trailing: id

        process_response(response) do |r|
          new(r) unless r.empty?
        end
      end

      def all
        response = Client.get subject: self

        process_response(response) do |r|
          r.collect do |item|
            new(item)
          end
        end
      end

      def count
        response = Client.get subject: self, trailing: 'count'
        process_response(response) do |r|
          r['count'].to_i
        end
      end
      
      def process_response(response, &block)
        if response
          if !response.include?('error')
            yield response
          elsif /Token/i =~ response['error']
            raise InvalidToken.new response['error']
          end
        end
      end

      def get_and_hydrate_collection(target_class, client_params = {})
        hydrate_collection Client.get(client_params), target_class
      end

      def search_and_hydrate_collection(target_class, client_params = {})
        hydrate_collection Client.search(client_params), target_class
      end

      def hydrate_collection(collection, target_class)
        collection.map { |item_data| target_class.new(item_data) }
      end
    end

    def initialize(hash)
      hash.each do |key, value|
        instance_variable_set("@#{key}", value) if respond_to?(key.to_sym)
      end
    end

    def get_and_hydrate_collection(target_class, client_params = {})
      self.class.get_and_hydrate_collection(target_class, client_params)
    end

    def search_and_hydrate_collection(target_class, client_params = {})
      self.class.search_and_hydrate_collection(target_class, client_params)
    end

    def hydrate_collection(collection, target_class)
      self.class.hydrate_collection(collection, target_class)
    end
  end
end
