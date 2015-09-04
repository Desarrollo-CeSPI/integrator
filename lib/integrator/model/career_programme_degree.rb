module Integrator
  class CareerProgrammeDegree < Nested
    attr_reader :id, :career_programme_id, :degree_id
    
    def to_s
      "#{career_programme} - #{degree}"
    end

    def career_programme
      @_career_programme ||= CareerProgramme.find(career_programme_id)
    end
    
    def degree
      @_degree ||= Degree.find(degree_id)
    end
  end
end
