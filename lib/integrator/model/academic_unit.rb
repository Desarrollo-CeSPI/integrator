module Integrator
  class AcademicUnit < Base
    attr_reader :id, :code, :name, :address_id, :email, :university, :ministry_reports_code, :type
    
    def careers
      response = Client.get(subject: [self, Career])
      
      response.collect do |item|
        Career.new(item)
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
  end
end
