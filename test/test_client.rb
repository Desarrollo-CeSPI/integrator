require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'turn/autorun'
require 'active_support/deprecation'
require 'active_support/test_case'
require 'active_support/core_ext/module'

require 'integrator'

class TestClient < Test::Unit::TestCase
  def setup
    Integrator.setup do |config|
      #config.url = 'http://163.10.20.70/integrador_apiv2'
      #config.token = 'b6351f2db94e4126055566036e7b384524a61d6f'
      config.url = 'http://localhost/integrador_apiv2'
      config.token = 'eef71ad13258632b0bdb4acda6bc0f1f7d77d297'
    end
  end
  
  def test_build_uri_with_one_parameter
    uri = Integrator::Client.build_uri subject: Integrator::Country
    
    assert_equal "#{Integrator.url}/api/country.json?token=#{Integrator.token}", uri
  end
  
  def test_build_uri_with_two_parameters
    country = Integrator::Country.find(10)
    
    uri = Integrator::Client.build_uri subject: [country, Integrator::State]
    
    assert_equal "#{Integrator.url}/api/country/#{country.id}/state.json?token=#{Integrator.token}", uri
  end
  
  def test_build_uri_with_three_parameters
    state = Integrator::State.find(1)
    
    uri = Integrator::Client.build_uri subject: [state.country, state, Integrator::Department]
    
    assert_equal "#{Integrator.url}/api/country/#{state.country_id}/state/#{state.id}/department.json?token=#{Integrator.token}", uri
  end
  
  def test_build_uri_with_four_parameters
    department = Integrator::Department.find(9)
    
    uri = Integrator::Client.build_uri subject: [department.state.country, department.state, department, Integrator::City]
    
    assert_equal "#{Integrator.url}/api/country/#{department.state.country_id}/state/#{department.state_id}/department/#{department.id}/city.json?token=#{Integrator.token}", uri
  end
  
  def test_build_params_with_trailing_count_and_no_extra_params
    params = Integrator::Client.build_params trailing: 'count'
    
    assert_equal "/count?token=#{Integrator.token}", params
  end
  
  def test_build_params_with_trailing_id_and_no_extra_params
    params = Integrator::Client.build_params trailing: 1
    
    assert_equal "/#{1}?token=#{Integrator.token}", params
  end
  
  def test_build_params_with_trailing_search_and_no_extra_params
    params = Integrator::Client.build_params trailing: ['search', 'Mac Adden']
    
    assert_equal "/search/Mac%20Adden?token=#{Integrator.token}", params
  end
  
  def test_build_params_with_trailing_search_and_extra_params
    params = Integrator::Client.build_params trailing: ['search', 'Mac Adden'], extra_params: { type: 'teacher' }
    
    assert_equal "/search/Mac%20Adden?token=#{Integrator.token}&type=teacher", params
    
    params = Integrator::Client.build_params trailing: ['search', 'Mac Adden'], extra_params: { type: 'teacher,authority' }
    
    assert_equal "/search/Mac%20Adden?token=#{Integrator.token}&type=teacher%2Cauthority", params
  end

  def test_invalid_token
    Integrator.setup do |config|
      config.token = '1'
    end
    
    assert_raise Integrator::InvalidToken do
      Integrator::AcademicUnit.find(1)
    end
  end
  
  def test_without_url
    assert_raise Integrator::InvalidUrl do
      Integrator.setup do |config|
        config.url = nil
      end
    end
  end
  
  def test_without_token
    assert_raise Integrator::InvalidToken do
      Integrator.setup do |config|
        config.token = nil
      end
    end
  end
  
  def test_id_must_be_greater_than_zero
    assert_raise Integrator::InvalidUrl do
      Integrator::AcademicUnit.find(0)
    end
  end
  
  def test_http_error
    Integrator.setup do |config|
      config.url = 'http://163.10.20.70/integrador_aaaapiv2'
    end
    
    assert_raise Integrator::ServerError do
      Integrator::AcademicUnit.find(1)
    end
  end
  
  def test_connection_refused
    Integrator.setup do |config|
      config.url = 'http://127.0.0.1:1/integrador_apiv2'
    end
    
    assert_raise Integrator::ServerError do
      Integrator::AcademicUnit.find(1)
    end
  end

  def test_unexisting_server
    Integrator.setup do |config|
      config.url = 'http://1.1.1.1/integrador_apiv2'
    end
    
    assert_raise Integrator::ServerError do
      Integrator::AcademicUnit.find(1)
    end
  end
end
