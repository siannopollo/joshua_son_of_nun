module JoshuaSonOfNun
  module Strategy
    def self.strategies
      ['Random', 'Diagonal', 'Knight']
    end
    
    def self.select(board)
      const_get(strategies[rand(strategies.size)]).new(board)
    end
    
    class Base
      attr_accessor :successful_targets
      attr_reader :board, :current_target, :expended_targets, :immediate_targets, :targets
      
      def initialize(board)
        @board = board
        @targets = assign_targets
        @expended_targets, @successful_targets, @immediate_targets = [], [], []
      end
      
      def next_target
        new_target = @immediate_targets.shift
        unless new_target.nil?
          @targets.delete(new_target)
        else
          new_target = @targets.shift
        end
        
        @current_target = new_target
        @expended_targets << @current_target
        @current_target
      end
      
      def register_result!(ship_hit, ship_sunk)
        if ship_hit
          @successful_targets << @current_target
          @immediate_targets = TargetingReaction.new(self, ship_sunk).react!
        end
      end
      
      private
        def choose_target(index = rand(possible_targets.size))
          possible_targets.delete(possible_targets[index])
        end
        
        def possible_targets
          @possible_targets ||= @board.valid_spaces.dup
        end
        
        def random_direction
          Space.directions[rand(Space.directions.size)]
        end
    end
    
    class TargetingReaction
      attr_reader :strategy, :ship_sunk
      
      alias_method :ship_sunk?, :ship_sunk
      
      def initialize(strategy, ship_sunk)
        @strategy, @ship_sunk = strategy, ship_sunk
      end
      
      def react!
        return [] if ship_sunk?
        
        if targets_lined_up?
          reject_expended(strategy.successful_targets[-2].linear_spaces(strategy.successful_targets.last, strategy.expended_targets))
        else
          reject_expended(strategy.current_target.crosswise_spaces)
        end
      end
      
      protected
        def reject_expended(spaces)
          spaces.reject do |space|
            strategy.expended_targets.include?(space)
          end
        end
        
        def targets_lined_up?
          targets = strategy.successful_targets
          targets.size > 1 && targets[-2].linear_to?(targets.last)
        end
    end
  end
end