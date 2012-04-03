module Integrator
  class Person < Base
    attr_reader :id, :first_name, :last_name, :document_type_id, :document_number, :gender_id, :cuil, :birth_date, :updated_at, :created_at, :document_emitting_entity_id, :document_type, :gender, :document_emitting_entity
    
    def to_s
      "#{first_name} #{last_name}"
    end

    def self.search(query, params = {})
      
      params.merge! subject: self, trailing: ['search', query]
      
      response = Client.get params
      
      response.collect do |item|
        new(item)
      end
    end

    def academic_datas
      response = Client.get(subject: [self, AcademicData])
      
      response.collect do |item|
        AcademicData.new(item)
      end
    end
  end
end
