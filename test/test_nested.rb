require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'turn/autorun'
require 'active_support/deprecation'
require 'active_support/test_case'
require 'active_support/core_ext/module'

require 'integrator'

class TestNested < Test::Unit::TestCase
  def setup
    Integrator.setup do |config|
      #config.url = 'http://163.10.20.70/integrador_apiv2'
      #config.token = 'b6351f2db94e4126055566036e7b384524a61d6f'
      config.url = 'http://localhost/integrador_apiv2'
      config.token = 'eef71ad13258632b0bdb4acda6bc0f1f7d77d297'
    end
  end
  
  def test_all
    [
      Integrator::Career,
      Integrator::CareerProgramme,
      Integrator::CareerSubject,
      Integrator::City,
      Integrator::Degree,
      Integrator::Department,
      Integrator::Paycheck,
      Integrator::State,
      Integrator::CareerProgrammeDegree
    ].each do |klass|
      assert_raise Exception do
        klass.all
      end
    end
  end
  
  def test_count
    [
      Integrator::Career,
      Integrator::CareerProgramme,
      Integrator::CareerSubject,
      Integrator::City,
      Integrator::Degree,
      Integrator::Department,
      Integrator::Paycheck,
      Integrator::State,
      Integrator::CareerProgrammeDegree
    ].each do |klass|
      assert_raise Exception do
        klass.count
      end
    end
  end
end
