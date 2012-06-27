module Integrator
  class PersonEmail < Nested
    attr_accessor :id, :person_id, :email

    def to_s
      "#{person.first_name} #{person.last_name} <#{email}>"
    end

    def person
      Person.find(person_id)
    end
  end
end
