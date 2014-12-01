module Integrator
  class PersonRole < Nested
    STATUS_ACTIVE = 1

    attr_reader :id, :person_id, :academic_unit_id, :is_student, :is_teacher, :is_personal, :is_authority,
                :student_is_active, :personal_status, :teacher_status, :authority_status, :is_grant, :grant_status

    def to_s
      person
    end

    def person
      @person ||= Person.find(person_id)
    end
    
    def academic_unit
      @academic_unit ||= AcademicUnit.find(academic_unit_id)
    end

    # Defines methods to normalize the API for objects of this class:
    # +authority_is_active+, +personal_is_active+ and +teacher_is_active+.
    #
    # For example:
    #   person_role.personal_is_active
    #     # => true
    %w(authority personal teacher).each do |role|
      define_method "#{role}_is_active" do
        public_send("#{role}_status").to_i == STATUS_ACTIVE
      end
    end
  end
end
