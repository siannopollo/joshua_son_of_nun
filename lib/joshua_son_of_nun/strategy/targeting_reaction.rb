module JoshuaSonOfNun
  module Strategy
    class TargetingReaction
      attr_reader :strategy
      
      def initialize(strategy, ship_sunk)
        @strategy, @ship_sunk = strategy, ship_sunk
      end
      
      def react!
        return [] if @ship_sunk
        
        if targets_lined_up?
          targets = strategy.successful_targets
          reject_expended(targets[-2].linear_spaces(targets.last, strategy.expended_targets, strategy.successful_targets))
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
          targets.size > 1 && targets[-2].linear?(targets.last)
        end
    end
  end
end
