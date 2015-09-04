module Integrator
  class City < Nested
    attr_reader :id, :name, :department_id
    
    def to_s
      name
    end

    def department
      @_department ||= Department.find(department_id)
    end
  end
end
