module Integrator
  class AcademicUnit < Base
    attr_reader :id, :code, :name, :address_id, :email, :university, :ministry_reports_code, :type
    
    def to_s
      name
    end

    def name
      if @name.respond_to?(:html_safe)
        @name.html_safe
      else
        @name
      end
    end
    
    def careers
      get_and_hydrate_collection Career, subject: [self, Career]
    end

    def degrees
      get_and_hydrate_collection Degree, subject: [self, Degree]
    end
    
    def paychecks
      get_and_hydrate_collection Paycheck, subject: [self, Paycheck]
    end
    
    def people
      get_and_hydrate_collection Person, subject: [self, Person]
    end
    
    def search_people(q, type = 'student,authority,teacher')
      search_and_hydrate_collection Person, subject: [self, Person], trailing: URI.encode(q), extra_params: { type: type }
    end

    def mapped_code
      AcademicUnitMapper.from_integrator_to_liquidaciones(code)
    end
  end
end
