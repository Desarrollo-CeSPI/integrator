module Integrator
  class Nested < Base
    class << self
      def all
        raise Exception.new "You can't get all #{name.split('::').last.underscore.humanize.pluralize} directly."
      end
      
      def count
        raise Exception.new "You can't count #{name.split('::').last.underscore.humanize.pluralize} directly."
      end
    end
  end
end
