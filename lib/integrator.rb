require "net/http"
require "active_support/core_ext/object/to_query"
begin
  require "active_support/core_ext/object/to_json"
rescue LoadError
end
require "active_support/json"
require "active_model"
require "active_record"

require "integrator/version"
require "integrator/client"
require "integrator/base"
require "integrator/nested"
require "integrator/exceptions"
require "integrator/has_methods"
require "integrator/academic_unit_mapper"
require "integrator/model/academic_data"
require "integrator/model/academic_degree_type"
require "integrator/model/academic_unit"
require "integrator/model/career"
require "integrator/model/person_email"
require "integrator/model/personal_charge"
require "integrator/model/career_programme"
require "integrator/model/career_programme_degree"
require "integrator/model/career_subject"
require "integrator/model/country"
require "integrator/model/degree"
require "integrator/model/state"
require "integrator/model/department"
require "integrator/model/city"
require "integrator/model/document_type"
require "integrator/model/paycheck"
require "integrator/model/person_role"
require "integrator/model/person"
require "integrator/model/gender"
require "integrator/model/marital_status"

module Integrator
  mattr_accessor :url, :token, :version, :version_data_location, :expires_in
  
  # setup Integrator
  def self.setup
    yield self
    
    self.expires_in ||= 1.hour
    raise InvalidUrl.new('You must set the UNLP Integrator APIv2 url!') if @@url.nil?
    raise InvalidToken.new('You must set the UNLP Integrator APIv2 token!') if @@token.nil?
    raise InvalidToken.new('You must set the UNLP Integrator APIv2 version!') if @@version.nil?
    raise InvalidToken.new('You must set the UNLP Integrator APIv2 version data location!') if @@version_data_location.nil?
    
    # remove trailing slash
    @@url.chomp!('/') if @@url.end_with?('/')
  end
end

ActiveRecord::Base.extend Integrator::HasMethods
