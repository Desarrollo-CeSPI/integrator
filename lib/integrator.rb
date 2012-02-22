require "net/http"
require "active_support/core_ext/object/to_query"
require "active_support/core_ext/object/to_json"
require "active_support/json"

require "integrator/version"
require "integrator/client"
require "integrator/base"
require "integrator/nested"
require "integrator/model/academic_unit"
require "integrator/model/career"
require "integrator/model/career_programme"
require "integrator/model/career_subject"
require "integrator/model/country"
require "integrator/model/state"
require "integrator/model/department"
require "integrator/model/city"
require "integrator/model/document_type"
require "integrator/model/paycheck"
require "integrator/model/person"
require "integrator/model/gender"
require "integrator/model/marital_status"

module Integrator
  mattr_accessor :url, :token
  
  # setup Integrator
  def self.setup
    yield self
    
    raise Exception.new('You must set the UNLP Integrator APIv2 url!') if @@url.nil?
    raise Exception.new('You must set the UNLP Integrator APIv2 token!') if @@token.nil?
    
    # remove trailing slash
    if @@url.end_with?('/')
      @@url.chomp!('/')
    end
  end
end
