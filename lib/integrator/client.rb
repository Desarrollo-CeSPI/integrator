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
        url = URI.parse uri

        proc = Proc.new do
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = (url.scheme == 'https')
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
          http.request(request)
        end

        response = begin
          if defined? Rails
            if defined? Rack::MiniProfiler
              Rack::MiniProfiler.step("Fetching #{uri}") do
                Rails.cache.fetch(uri, :expires_in => Integrator.expires_in) do
                  proc.call
                end
              end
            else
              Rails.cache.fetch(uri, :expires_in => Integrator.expires_in) do
                proc.call
              end
            end
          else
            proc.call
          end
        rescue Exception => error
          raise ServerError.new("Could not establish connection: #{error.message}")
        end

        case response
          when Net::HTTPClientError
            nil
          when Net::HTTPSuccess
            ActiveSupport::JSON.decode(response.body)
          else
            raise ServerError.new("Could not establish connection. Message: #{response.message}")
        end
      end

      def search(params = {})
        uri = build_search_uri(params)
        url = URI.parse uri

        proc = Proc.new do
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = (url.scheme == 'https')
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
          response = http.request(request)
        end

        response = begin
          if defined? Rails
            if defined? Rack::MiniProfiler
              Rack::MiniProfiler.step("Searching #{uri}") do
                Rails.cache.fetch(uri, :expires_in => Integrator.expires_in) do
                  proc.call
                end
              end
            else
              Rails.cache.fetch(uri, :expires_in => Integrator.expires_in) do
                proc.call
              end
            end
          else
            proc.call
          end
        rescue Exception => error
          raise ServerError.new("Could not establish connection: #{error.message}")
        end

        case response
          when Net::HTTPClientError
            []
          when Net::HTTPSuccess
            ActiveSupport::JSON.decode(response.body)
          else
            raise ServerError.new("Could not establish connection. Message: #{response.message}")
        end
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
