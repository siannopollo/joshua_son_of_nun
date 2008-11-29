module JoshuaSonOfNun
  module Strategy
    def self.strategies
      [['Random']*4, 'Diagonal', ['Knight']*2].flatten
    end
    
    def self.select(board)
      const_get(strategies[rand(strategies.size)]).new(board)
    end
    
    class Base
      attr_reader :current_target, :expended_targets, :immediate_targets,
                  :possible_targets, :successful_targets, :targets
      
      def initialize(board)
        @possible_targets = board.valid_spaces.dup
        @targets = assign_targets
        @expended_targets, @successful_targets, @immediate_targets = [], [], []
      end
      
      def next_target
        new_target = immediate_targets.shift || targets.first
        targets.delete(new_target)
        
        @current_target = new_target
        expended_targets << @current_target
        @current_target
      end
      
      def register_result!(ship_hit, ship_sunk)
        if ship_hit
          successful_targets << current_target
          @immediate_targets = TargetingReaction.new(self, ship_sunk).react!
        end
      end
      
      private
        def choose_target(index = rand(possible_targets.size))
          possible_targets.delete(possible_targets[index])
        end
        
        def random_direction
          Space.directions[rand(Space.directions.size)]
        end
    end
  end
end