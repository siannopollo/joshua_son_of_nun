module JoshuaSonOfNun
  class Player
    attr_reader :personal_board, :opponent_board, :strategy
    attr_reader :carrier, :battleship, :destroyer, :submarine, :patrolship
    
    def battleship_placement
      battleship.initial_placement
    end
    
    def carrier_placement
      carrier.initial_placement
    end
    
    def destroyer_placement
      destroyer.initial_placement
    end
    
    def patrolship_placement
      patrolship.initial_placement
    end
    
    def submarine_placement
      submarine.initial_placement
    end
    
    def next_target
      strategy.next_target.to_s
    end
    
    def target_result(coordinates, was_hit, ship_sunk)
      strategy.register_result! was_hit, ship_sunk
    end
    
    def enemy_targeting(coordinates); end
    def game_over(result, disqualification_reason=nil); end
    
    private
      def reset(*args)
        srand
        
        @personal_board = Board.new
        @opponent_board = Board.new
        
        @battleship = Battleship.new(@personal_board)
        @carrier = Carrier.new(@personal_board)
        @destroyer = Destroyer.new(@personal_board)
        @patrolship = Patrolship.new(@personal_board)
        @submarine = Submarine.new(@personal_board)
        
        @strategy = Strategy.select(@opponent_board)
      end
    
    alias_method :initialize, :reset
    alias_method :new_game, :reset
    public :initialize, :new_game
  end
end