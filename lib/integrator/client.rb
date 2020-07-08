require 'net/http'

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
        base_url = params.delete(:base_url) || Integrator.url
        slices = slices_from_subject(params[:subject])
        parameters = build_params(params)

        send(uri_builder, base_url, slices, parameters)
      end

      def build_search_uri(params = {})
        ensure_subject(params)
        send(uri_builder, Integrator.url, slices_from_subject(params[:subject]) + '.json/search/', build_params(params))
      end

      def get(params = {})
        perform_request build_uri(params), params
      end

      def search(params = {})
        perform_request build_search_uri(params), params, default: []
      end

      protected

      def uri_builder
        @uri_builder ||= "build_uri_with_version_as_#{Integrator.version_data_location.downcase}"
      end

      def build_uri_with_version_as_first_url_parameter(base_url, slices, params)
        "#{base_url}/#{Integrator.version}/#{slices}#{params}"
      end

      def build_uri_with_version_as_header(base_url, slices, params)
        "#{base_url}/#{slices}#{params}"
      end

      def build_params(params = {})
        tail = '/' + Array(params[:trailing]).map { |x| CGI.escape(x.to_s) }.join('/') if params[:trailing]
        tail.to_s + params[:extra_params].to_h.to_query
      end

      def perform_request(uri, params = {}, default = nil)
        response = with_mini_profiler("Performing request #{uri}") do
          fetch_from_cache uri, &request_handler(uri, params[:token])
        end

        handle_response(uri, response, params.merge(:default => default))
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
        raise ServerError, "Could not establish connection: #{error.message}"
      end

      def delete_from_cache(uri)
        Rails.cache.delete(cache_key(uri)) rescue nil
      end

      def cache_key(uri)
        Digest::SHA2.hexdigest(uri)
      end

      def request_handler(uri, token = nil)
        Proc.new do
          url              = URI.parse uri
          http             = Net::HTTP.new(url.host, url.port)
          http.use_ssl     = url.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request          = Net::HTTP::Get.new("#{url.path}#{url.query}")

          request['Authorization'] = token || Integrator.token
          request['X-Api-Version'] = Integrator.version if Integrator.version_data_location == 'HEADER'

          http.request(request)
        end
      end

      def handle_response(uri, response, options = {})
        if options[:response_handler]
          options[:response_handler].handle_response(uri, response, options)
        else
          case response
            when Net::HTTPClientError
              delete_from_cache uri # Force delete the empty response from the cache
              options[:default]
            when Net::HTTPSuccess
              handle_response_success(uri, response)
            else
              delete_from_cache uri # Force delete the error response from the cache
              raise ServerError, "Could not establish connection. Message: #{response.message}"
          end
        end
      end

      def handle_response_success(uri, response)
        ActiveSupport::JSON.decode(response.body).tap do |result|
          # Force delete an empty response from the cache
          delete_from_cache(uri) if result.nil? || result.respond_to?(:empty?) && result.empty?
        end
      end

      def ensure_subject(params)
        raise ArgumentError, 'You must specify the subject' unless params.include?(:subject)
      end
    end
  end
end
