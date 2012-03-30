module Integrator
  class AcademicUnit < Base
    attr_reader :id, :code, :name, :address_id, :email, :university, :ministry_reports_code, :type
    
    def to_s
      name
    end
    
    def careers
      response = Client.get(subject: [self, Career])
      
      response.collect do |item|
        Career.new(item)
      end
    end

    def degrees
      response = Client.get(subject: [self, Degree])
      
      response.collect do |item|
        Degree.new(item)
      end
    end
    
    def paychecks
      response = Client.get(subject: [self, Paycheck])
      
      response.collect do |item|
        Paycheck.new(item)
      end
    end
    
    def people
      response = Client.get(subject: [self, Person])
      
      response.collect do |item|
        Person.new(item)
      end
    end
    
    def search_people(q, type = 'student,authority,teacher')
      response = Client.search subject: [self, Person], trailing: q.gsub(' ', '%20'), extra_params: { type: type }
      
      response.collect do |item|
        Person.new(item)
      end
    end
  end
end
