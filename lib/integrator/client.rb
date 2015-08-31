module Integrator
  class Client
    class << self
      def slices_from_subject(subject)
        if !subject.is_a? Array
          subject = [subject]
        end

        slices = []
        subject.each do |item|
          if item.is_a? Class
            slices << item.name.split('::').last.underscore
          else
            slices << item.class.name.split('::').last.underscore
            slices << item.id
          end
        end

        slices.join('/')
      end

      def build_uri(params = {})
        raise Exception.new('You must specify the subject') if !params.include?(:subject)

        Integrator.url + '/api/' + slices_from_subject(params[:subject]) + '.json' + build_params(params)
      end

      def build_search_uri(params = {})
        raise Exception.new('You must specify the subject') if !params.include?(:subject)

        Integrator.url + '/api/' + slices_from_subject(params[:subject]) + '.json/search/' + build_params(params)
      end

      def get(params = {})
        uri = build_uri(params)

        response = with_mini_profiler("Fetching #{uri}") do
          fetch_from_cache uri, &request_handler(uri)
        end

        handle_response(uri, response)
      end

      def search(params = {})
        uri = build_search_uri(params)

        response = with_mini_profiler("Searching #{uri}") do
          fetch_from_cache uri, &request_handler(uri)
        end

        handle_response(uri, response, default: [])
      end

      def build_params(params = {})
        ret = if params.include?(:trailing)
          if params[:trailing].is_a? Array
            '/' + params[:trailing].map { |x| URI.encode(x.to_s) }.join('/')
          else
            '/' + URI.encode(params[:trailing].to_s)
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

      def with_mini_profiler(tag, &block)
        if defined? Rack::MiniProfiler
          Rack::MiniProfiler.step(tag, &block)
        else
          yield
        end
      end

      def fetch_from_cache(uri, &block)
        Rails.cache.fetch(uri, :expires_in => Integrator.expires_in, &block)
      rescue NameError
        # Not in a rails app
        yield
      rescue Exception => error
        raise ServerError.new("Could not establish connection: #{error.message}")
      end

      def request_handler(uri)
        Proc.new do
          p "Querying #{uri}"
          url = URI.parse uri
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = url.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
          http.request(request)
        end
      end

      def handle_response(uri, response, default: nil)
        case response
        when Net::HTTPClientError
          Rails.cache.delete(uri) # Force delete the empty response from the cache
          default
        when Net::HTTPSuccess
          ActiveSupport::JSON.decode(response.body).tap do |result|
            # Force delete an empty response from the cache
            Rails.cache.delete(uri) if result.nil? || result.respond_to?(:empty?) && result.empty?
          end
        else
          raise ServerError.new("Could not establish connection. Message: #{response.message}")
        end
      end
    end
  end
end
