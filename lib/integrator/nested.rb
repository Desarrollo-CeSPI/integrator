module Integrator
  class Nested < Base
    class << self
      def all
        raise Exception, "You can't get all #{name.split('::').last.underscore.humanize.pluralize} directly."
      end

      def count
        raise Exception, "You can't count #{name.split('::').last.underscore.humanize.pluralize} directly."
      end
    end
  end
end
