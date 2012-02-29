module Integrator
  class Client
    class << self
      def build_uri(params = {})
        raise Exception.new('You must specify the subject') if !params.include?(:subject)
        
        if !params[:subject].is_a? Array
          params[:subject] = [params[:subject]]
        end
        
        slices = []
        params[:subject].each do |item|
          if item.is_a? Class
            slices << item.name.split('::').last.underscore
          else
            slices << item.class.name.split('::').last.underscore
            slices << item.id
          end
        end
        
        Integrator.url + '/api/' + slices.join('/') + '.json' + build_params(params)
      end
      
      def get(params = {})
        uri = URI(build_uri(params))
        #result = Net::HTTP.start uri.host, uri.port do |http|
        #  http.get "#{uri.path}?#{uri.query}"
        #end
        
        begin
          response = Net::HTTP.get_response(uri)
        rescue Exception => error
          raise ServerError.new("Could not establish connection: #{error.message}")
        end
        
        raise ServerError.new("Could not establish connection. Message: #{response.message}") if !response.is_a?(Net::HTTPSuccess)
        
        ActiveSupport::JSON.decode(response.body)
      end
      
      def build_params(params = {})
        ret = if params.include?(:trailing)
          if params[:trailing].is_a? Array
            '/' + params[:trailing].join('/').gsub(' ', '%20')
          else
            '/' + params[:trailing].to_s
          end
        else
          ''
        end
        
        actual_params = { token: Integrator.token }
      
        if params.include?(:extra_params)
          actual_params.merge! params[:extra_params]
        end
        
        ret + "?#{actual_params.to_query}"
      end
    end
  end
end
