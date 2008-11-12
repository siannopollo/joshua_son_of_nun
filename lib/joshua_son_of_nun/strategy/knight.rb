module JoshuaSonOfNun
  module Strategy
    class Knight < Base
      private
        def assign_targets
          targets = [choose_target]
          until possible_targets.empty?
            next_target = targets.last.spaces_in_knighted_move(random_direction)
            next_target = choose_target if targets.include?(next_target) || next_target.nil?
            possible_targets.delete(next_target)
            targets << next_target
          end
          targets
        end
    end
  end
end