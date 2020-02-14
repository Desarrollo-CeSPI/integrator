module Integrator
  class InvalidUrl < StandardError
  end
  
  class InvalidToken < StandardError
  end
  
  class InvalidVersion < StandardError
  end

  class InvalidVersionDataLocation < StandardError
  end

  class ServerError < StandardError
  end

  class MissingPerson < StandardError
  end
end
