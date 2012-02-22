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
      config.url = 'http://163.10.20.70/integrador_apiv2'
      config.token = 'f436fd451214fc5b2e9dc06269877e2bdfe957dc'
    end
  end
  
  def test_all
    [
      Integrator::Career,
      Integrator::CareerProgramme,
      Integrator::CareerSubject,
      Integrator::City,
      Integrator::Department,
      Integrator::Paycheck,
      Integrator::State
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
      Integrator::Department,
      Integrator::Paycheck,
      Integrator::State
    ].each do |klass|
      assert_raise Exception do
        klass.count
      end
    end
  end
end
