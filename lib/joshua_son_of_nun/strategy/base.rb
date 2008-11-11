module JoshuaSonOfNun
  module Strategy
    def self.strategies
      ['Random']
    end
    
    def self.select(board)
      const_get(strategies[rand(strategies.size)]).new(board)
    end
    
    class Base
      attr_reader :board, :current_target, :targets
      
      def initialize(board)
        @board = board
        @targets = assign_targets
      end
      
      def next_target
        @current_target = @targets.shift
      end
      
      def register_result!(ship_hit, ship_sunk)
        @old_targets = TargetingReaction.new(self, ship_sunk).react! if ship_hit
      end
    end
    
    class TargetingReaction
      attr_reader :strategy, :ship_sunk
      
      alias_method :ship_sunk?, :ship_sunk
      
      def initialize(strategy, ship_sunk)
        @strategy, @ship_sunk = strategy, ship_sunk
      end
      
      def react!
        return nil if ship_sunk?
        
        old_targets = strategy.targets
        new_immediate_targets = strategy.current_target.crosswise_spaces
        new_immediate_targets.each do |target|
          
        end
        
        old_targets
      end
    end
  end
end