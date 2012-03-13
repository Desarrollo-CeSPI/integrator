require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'turn/autorun'
require 'active_support/deprecation'
require 'active_support/test_case'
require 'active_support/core_ext/module'

require 'integrator'

class TestBase < Test::Unit::TestCase
  def setup
    Integrator.setup do |config|
      #config.url = 'http://163.10.20.70/integrador_apiv2'
      #config.token = 'b6351f2db94e4126055566036e7b384524a61d6f'
      config.url = 'http://localhost/integrador_apiv2'
      config.token = 'eef71ad13258632b0bdb4acda6bc0f1f7d77d297'
    end
  end
  
  def test_find
    [
      Integrator::AcademicDegreeType,
      Integrator::AcademicUnit,
      Integrator::Career,
      Integrator::CareerProgramme,
      Integrator::CareerSubject,
      Integrator::City,
      Integrator::Country,
      Integrator::Degree,
      Integrator::Department,
      Integrator::DocumentType,
      Integrator::Gender,
      Integrator::MaritalStatus,
      Integrator::Paycheck,
      Integrator::State
    ].each do |klass|
      object = klass.find(1)
      
      assert_equal 1, object.id.to_i if !object.nil?
    end
    
    object = Integrator::Person.find('000000000000000000000000031940555')
    assert_equal '000000000000000000000000031940555', object.id if !object.nil?
  end
  
  def test_all
    [
      Integrator::AcademicDegreeType,
      Integrator::AcademicUnit,
      Integrator::Country,
      Integrator::DocumentType,
      Integrator::Gender,
      Integrator::MaritalStatus,
      Integrator::Person
    ].each do |klass|
      all = klass.all
      count = klass.count
      
      assert all.is_a? Array
      assert all.length <= 500 && all.length <= count
    end
  end
  
  def test_count
    [
      Integrator::AcademicDegreeType,
      Integrator::AcademicUnit,
      Integrator::Country,
      Integrator::DocumentType,
      Integrator::Gender,
      Integrator::MaritalStatus,
      Integrator::Person
    ].each do |klass|
      count = klass.count
      
      assert count.is_a? Fixnum
    end
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
