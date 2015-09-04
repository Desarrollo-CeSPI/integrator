module Integrator
  class AcademicUnitMapper
    LIQUIDACIONES_IDS = %w(30 28 31  35) # 30: Trabajo social, 28: Obras y planeamiento, 31: Rectorado (Función 5.20), 35: Hospital de medicina
    INTEGRATOR_IDS    = %w(28 30 99 100) # 28: Trabajo social, 30: Obras y planeamiento, 99: Rectorado (Función 5.20), 100: Hospital de medicina

    class << self
      def from_integrator_to_liquidaciones(id)
        map(INTEGRATOR_IDS, LIQUIDACIONES_IDS, id)
      end

      def from_liquidaciones_to_integrator(id)
        map(LIQUIDACIONES_IDS, INTEGRATOR_IDS, id)
      end

      def map(from, to, lookup_id)
        if from.include?(lookup_id.to_s)
          conversion_hash(from, to)[lookup_id.to_s]
        else
          lookup_id.to_i
        end
      end

      def conversion_hash(from, to)
        Hash[from.zip(to.map(&:to_i))]
      end
    end

    private_class_method :map
    private_class_method :conversion_hash
  end
end