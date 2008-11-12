module JoshuaSonOfNun
  module Strategy
    class Diagonal < Base
      private
        def assign_targets
          targets = []
          until possible_targets.empty?
            target = choose_target
            diagonal_targets = target.spaces_on_diagonal(random_direction)
            targets << target
            diagonal_targets.each do |diagonal_target|
              targets << possible_targets.delete(diagonal_target)
            end
          end
          targets.compact
        end
    end
  end
end