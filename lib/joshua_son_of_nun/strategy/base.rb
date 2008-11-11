module JoshuaSonOfNun
  module Strategy
    def self.strategies
      ['Random']
    end
    
    def self.select(board)
      const_get(strategies[rand(strategies.size)]).new(board)
    end
    
    class Base
      attr_reader :board, :current_target, :expended_targets, :old_targets, :targets
      
      def initialize(board)
        @board = board
        @targets = assign_targets
        @expended_targets = []
      end
      
      def next_target
        @current_target = @targets.shift
        expended_targets << @current_target
        @current_target
      end
      
      def register_result!(ship_hit, ship_sunk)
        @targets, @old_targets = TargetingReaction.new(self, ship_sunk).react! if ship_hit
      end
    end
    
    class TargetingReaction
      attr_reader :strategy, :ship_sunk
      
      alias_method :ship_sunk?, :ship_sunk
      
      def initialize(strategy, ship_sunk)
        @strategy, @ship_sunk = strategy, ship_sunk
      end
      
      def react!
        if ship_sunk?
          strategy.expended_targets.each {|target| strategy.old_targets.delete(target)}
          [strategy.old_targets, nil]
        else
          targets, old_targets = strategy.targets.dup, strategy.targets.dup
          new_immediate_targets = strategy.current_target.crosswise_spaces
          strategy.expended_targets.each {|target| new_immediate_targets.delete(target)}
          new_immediate_targets.each {|target| targets.delete(target)}
          new_immediate_targets.reverse.each {|target| targets.unshift(target)}
          
          [targets, old_targets]
        end
      end
    end
  end
end