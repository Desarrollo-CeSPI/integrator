module Integrator
  class Person < Base
    attr_reader :id, :first_name, :last_name, :document_type_id, :document_number, :gender_id, :cuil, :birth_date, :updated_at, :created_at, :document_emitting_entity_id, :document_type, :gender, :document_emitting_entity
    
    def to_s
      "#{first_name} #{last_name} [CUIL/CUIT: #{cuil ? cuil : 'N/A'}]"
    end

    def self.search(query, params = {})
      
      params.merge! subject: self, trailing: ['search', query]
      
      response = Client.get params
      
      response.collect do |item|
        new(item)
      end
    end

    def male?
      gender_id.to_i == 2
    end
    
    def female?
      gender_id.to_i == 1
    end

    def academic_datas
      response = Client.get(subject: [self, AcademicData])
      
      response.collect do |item|
        AcademicData.new(item)
      end
    end

    def emails
      response = Client.get(subject: [self, PersonEmail])
      
      response.collect do |item|
        PersonEmail.new(item)
      end
    end

    def person_roles
      Client.get(subject: [self, PersonRole]).map do |item|
        PersonRole.new(item)
      end
    end

    def is_graduated(academic_unit, career, degree)
      url = Integrator.url + "/api/person/#{id}/is_graduated.json/#{academic_unit.id}/#{career.id}/#{degree.id}?token=#{Integrator.token}"
      url = URI.parse url

      begin
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == 'https')
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
        response = http.request(request)
      rescue Exception => error
        raise ServerError.new("Could not establish connection: #{error.message}")
      end
      
      raise ServerError.new("Could not establish connection. Message: #{response.message}") if !response.is_a?(Net::HTTPSuccess)
      
      ActiveSupport::JSON.decode(response.body)
    end

    def personal_charges
      url = Integrator.url + "/api/person/#{id}/personal_charge.json?token=#{Integrator.token}"
      url = URI.parse url

      begin
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == 'https')
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new("#{url.path}?#{url.query}")
        response = http.request(request)
      rescue Exception => error
        raise ServerError.new("Could not establish connection: #{error.message}")
      end
      
      raise ServerError.new("Could not establish connection. Message: #{response.message}") if !response.is_a?(Net::HTTPSuccess)
      
      ActiveSupport::JSON.decode(response.body)
    end
  end
end
