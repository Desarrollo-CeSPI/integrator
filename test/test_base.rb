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
      #config.token = '2bd4fa09ddf878e819ae959be8ba726efc78dd3a'
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
      Integrator::State,
      Integrator::CareerProgrammeDegree
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
  
end
