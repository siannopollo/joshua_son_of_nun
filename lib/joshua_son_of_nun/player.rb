module JoshuaSonOfNun
  # Battleship Player
  #
  # Battleship is board game between two players.  See http://en.wikipedia.org/wiki/Battleship for more information and
  # game rules.
  #
  # A player represents the computer AI to play a game of Battleship.  It should know how to place ships and target
  # the opponents ships.
  #
  # This version of Battleship is played on a 10 x 10 grid where rows are labled by the letters A - J and
  # columns are labled by the numbers 1 - 10.  At the start of the game, each player will be asked for ship placements.
  # Once the ships are placed, play proceeeds by each player targeting one square on their opponents map.  A player
  # may only target one square, reguardless of whether it resulted in a hit or not, before changing turns with her opponent.
  #
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
    
    # Returns the coordinates of the players next target.  This method will be called once per turn.  The player
    # should return target coordinates as a string in the form of:
    #
    #   "#{ROW}#{COL}"
    #
    # eg
    #
    #   A1 # the square in Row A and Column 1
    #   F5 # the square in Row F and Column 5
    #
    # Since the map contains only 10 rows and 10 columns, the ROW should be A, B, C, D, E, F, G H, I, or J. And the
    # COL should be 1, 2, 3, 4, 5, 6, 7, 8, 9, or 10
    #
    # Returning coordinates outside the range or in an invalid format will result in the players disqualification.
    #
    # It is illegal to illegal to target a sector more than once.  Doing so will also result in disqualification.
    #
    def next_target
      strategy.next_target.to_s
    end
    
    # target_result will be called by the system after a call to next_target.  The paramters supplied inform the player
    # of the results of the target.
    #
    #   coordinates : string. The coordinates targeted.  It will be the same value returned by the previous call to next_target
    #   was_hit     : boolean.  true if the target was occupied by a ship.  false otherwise.
    #   ship_sunk   : symbol.  nil if the target did not result in the sinking of a ship.  If the target did result in
    #     in the sinking of a ship, the ship type is supplied (:carrier, :battleship, :destroyer, :submarine, :patrolship).
    #
    # An intelligent player will use the information to better play the game.  For example, if the result indicates a
    # hit, a player my choose to target neighboring squares to hit and sink the remainder of the ship.
    #
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