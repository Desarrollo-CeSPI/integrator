module Integrator
  class Client
    class << self
      def slices_from_subject(subject)
        subject = [subject] unless subject.is_a? Array
        slices = []
        subject.each do |item|
          if item.is_a? Class
            slices << item.uri_path
          else
            slices << item.class.uri_path
            slices << item.id
          end
        end
        slices.join('/')
      end

      def build_uri(params = {})
        ensure_subject(params)
        base = params.delete(:base_url) || Integrator.url
        if Integrator.version_data_location.eql?('FIRST_URL_PARAMETER')
        # FIRST_URL_PARAMETER versioning
          base + '/' + Integrator.version + '/' + slices_from_subject(params[:subject]) + build_params(params)
        else
        # HEADER versioning
          base + '/' + slices_from_subject(params[:subject]) + build_params(params)
        end
      end

      def build_search_uri(params = {})
        ensure_subject(params)
        Integrator.url + slices_from_subject(params[:subject]) + '.json/search/' + build_params(params)
      end

      def get(params = {})
        uri = build_uri(params)

        response = with_mini_profiler("Fetching #{uri}") do
          fetch_from_cache uri, &request_handler(uri, params[:token])
        end

        handle_response(uri, response, params)
      end

      def search(params = {})
        uri = build_search_uri(params)

        response = with_mini_profiler("Searching #{uri}") do
          fetch_from_cache uri, &request_handler(uri, params[:token])
        end

        handle_response(uri, response, params.merge(:default => []))
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

#TODO first url element mechanism
        #actual_params = { token: Integrator.token }
        actual_params = { }

        if params.include?(:extra_params)
          actual_params.merge! params[:extra_params]
        end

        if actual_params.empty?
          ret
        else 
          ret + "#{actual_params.to_query}"
        end 
      end

      def with_mini_profiler(tag, &block)
        if defined? Rack::MiniProfiler
          Rack::MiniProfiler.step(tag, &block)
        else
          yield
        end
      end

      def fetch_from_cache(uri, &block)
        Rails.cache.fetch(cache_key(uri), :expires_in => Integrator.expires_in, &block)
      rescue NameError
        # Not in a rails app
        yield
      rescue Exception => error
        raise ServerError.new("Could not establish connection: #{error.message}")
      end

      def cache_key(uri)
        Digest::SHA1.hexdigest(uri)
      end

      def request_handler(uri, token = nil)
        Proc.new do
          url                         = URI.parse uri
          http                        = Net::HTTP.new(url.host, url.port)
          http.use_ssl                = url.scheme == 'https'
          http.verify_mode            = OpenSSL::SSL::VERIFY_NONE
          request                     = Net::HTTP::Get.new("#{url.path}#{url.query}")

          if Integrator.version_data_location.eql?('HEADER')
            # HEADER versioning
            request['x-api-version']  = Integrator.version
          end

          # always 
          request['Authorization']    = token || Integrator.token
          http.request(request)
        end
      end

      def handle_response(uri, response, options = {})
        default = options[:default] || nil
        case response
        when Net::HTTPClientError
          Rails.cache.delete(cache_key(uri)) # Force delete the empty response from the cache
          default
        when Net::HTTPSuccess
          handle_response_success(uri, response, options)
        else
          raise ServerError.new("Could not establish connection. Message: #{response.message}")
        end
      end

      def handle_response_success(uri, response, options = {})

        body = if options[:response_handler]
          options[:response_handler].handle_response(response)
        else
          ActiveSupport::JSON.decode(response.body)
        end

        body.tap do |result|
          # Force delete an empty response from the cache
          Rails.cache.delete(cache_key(uri)) if result.nil? || result.respond_to?(:empty?) && result.empty?
        end
      end

      def ensure_subject(params)
        raise Exception.new('You must specify the subject') unless params.include?(:subject)
      end
    end
  end
end
