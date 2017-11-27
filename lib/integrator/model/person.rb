module Integrator
  class Person < Base
    attr_reader :id, :first_name, :last_name, :document_type_id, :document_number, :gender_id, :cuil, :birth_date, :updated_at, :created_at, :document_emitting_entity_id, :document_type, :gender, :document_emitting_entity
    
    def to_s
      "#{first_name.strip} #{last_name.strip} (CUIL/CUIT: #{cuil || '-'})"
    end

    def self.search(query, params = {})
      params.merge! subject: self, trailing: ['search', query]
      get_and_hydrate_collection self, params
    end

    def male?
      gender_id.to_i == 2
    end
    
    def female?
      gender_id.to_i == 1
    end

    def academic_datas
      get_and_hydrate_collection AcademicData, subject: [self, AcademicData]
    end

    def emails
      get_and_hydrate_collection PersonEmail, subject: [self, PersonEmail]
    end

    def person_roles
      get_and_hydrate_collection PersonRole, subject: [self, PersonRole]
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
      get_and_hydrate_collection PersonalCharge, subject: [self, PersonalCharge]
    end
  end
end
