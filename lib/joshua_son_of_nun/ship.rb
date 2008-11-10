module JoshuaSonOfNun
  class Ship
    class << self
      attr_accessor :length
    end
    
    attr_reader :initial_placement
    
    def initialize(board)
      @board = board
      @initial_placement = @board.placement(length)
    end
    
    def length
      self.class.length
    end
  end
  
  class Battleship < Ship
    self.length = 4
  end
  
  class Carrier < Ship
    self.length = 5
  end
  
  class Destroyer < Ship
    self.length = 3
  end
  
  class Patrolship < Ship
    self.length = 3
  end
  
  class Submarine < Ship
    self.length = 2
  end
end