module Integrator
  class DocumentType < Base
    attr_reader :id, :name, :abbreviation, :registration_enabled, :data_type
    
    def to_s
      name
    end
  end
end
