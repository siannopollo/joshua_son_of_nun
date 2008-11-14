module JoshuaSonOfNun
  class Player
    attr_reader :personal_board, :opponent_board, :opponent, :strategy
    attr_reader :carrier, :battleship, :destroyer, :submarine, :patrolship
    
    def initialize
      reset
    end
    
    # This method is called at the beginning of each game.  A player may only be instantiated once and used to play many games.
    # So new_game should reset any internal state acquired in previous games so that it is prepared for a new game.
    #
    # The name of the opponent player is passed in.  This allows for the possibility to learn opponent strategy and
    # play the game differently based on the opponent.
    #
    def new_game(opponent_name)
      @opponent = opponent_name
      reset
    end
    
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
    
    # enemy_targeting is called by the system to inform a player of their apponents move.  When the opponent targets
    # a square, this method is called with the coordinates.
    #
    # Players may use this information to understand an opponents targeting strategy and place ships differently
    # in subsequent games.
    #
    def enemy_targeting(coordinates)
    end
    
    # Called by the system at the end of a game to inform the player of the results.
    #
    #   result  : 1 of 3 possible values (:victory, :defeate, :disqualified)
    #   disqualification_reason : nil unless the game ended as the result of a disqualification.  In the event of a
    #     disqualification, this paramter will hold a string description of the reason for disqualification.  Both
    #     players will be informed of the reason.
    #
    #   :victory # indicates the player won the game
    #   :defeat # indicates the player lost the game
    #   :disqualified # indicates the player was disqualified
    #
    def game_over(result, disqualification_reason=nil)
    end
    
    private
      def reset
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
  end
end