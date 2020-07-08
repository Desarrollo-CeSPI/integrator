require 'active_support/core_ext/object/to_query'
begin
  require 'active_support/core_ext/object/to_json'
rescue LoadError
end
require 'active_support/json'
require 'active_model'

require 'integrator/version'

module Integrator
  mattr_accessor :url, :token, :version, :version_data_location, :expires_in

  # Misc
  autoload :AcademicUnitMapper, 'integrator/academic_unit_mapper'
  autoload :HasMethods,         'integrator/has_methods'
  # Errors
  autoload :InvalidToken,               'integrator/exceptions/invalid_token'
  autoload :InvalidUrl,                 'integrator/exceptions/invalid_url'
  autoload :InvalidVersion,             'integrator/exceptions/invalid_version'
  autoload :InvalidVersionDataLocation, 'integrator/exceptions/invalid_version_data_location'
  autoload :MissingPerson,              'integrator/exceptions/missing_person'
  autoload :ServerError,                'integrator/exceptions/server_error'
  # Client
  autoload :Client, 'integrator/client'
  # Models
  autoload :Base,                  'integrator/base'
  autoload :Nested,                'integrator/nested'
  autoload :AcademicData,          'integrator/model/academic_data'
  autoload :AcademicDegreeType,    'integrator/model/academic_degree_type'
  autoload :AcademicUnit,          'integrator/model/academic_unit'
  autoload :Career,                'integrator/model/career'
  autoload :PersonEmail,           'integrator/model/person_email'
  autoload :PersonalCharge,        'integrator/model/personal_charge'
  autoload :CareerProgramme,       'integrator/model/career_programme'
  autoload :CareerProgrammeDegree, 'integrator/model/career_programme_degree'
  autoload :CareerSubject,         'integrator/model/career_subject'
  autoload :Country,               'integrator/model/country'
  autoload :Degree,                'integrator/model/degree'
  autoload :State,                 'integrator/model/state'
  autoload :Department,            'integrator/model/department'
  autoload :City,                  'integrator/model/city'
  autoload :DocumentType,          'integrator/model/document_type'
  autoload :Paycheck,              'integrator/model/paycheck'
  autoload :PersonRole,            'integrator/model/person_role'
  autoload :Person,                'integrator/model/person'
  autoload :Gender,                'integrator/model/gender'
  autoload :MaritalStatus,         'integrator/model/marital_status'

  # Setup Integrator
  def self.setup
    yield self

    # Validate that all required options have been set
    raise(InvalidUrl, 'You must set Integrator URL') if url.blank?
    raise(InvalidToken, 'You must set Integrator token') if token.blank?
    raise(InvalidVersion, 'You must set Integrator version') if version.blank?
    raise(InvalidVersionDataLocation, 'You must set Integrator version data location') if version_data_location.blank?

    # Default expires_in value: 1 hour
    self.expires_in ||= 1.hour

    # Remove trailing slash on URL
    @@url.chomp!('/')
  end
end

ActiveRecord::Base.extend Integrator::HasMethods if defined? ActiveRecord
