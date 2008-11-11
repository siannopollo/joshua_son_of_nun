module JoshuaSonOfNun
  module Strategy
    class Random < Base
      private
        def assign_targets
          targets = []
          possible_targets.size.times do |n|
            i = 100 - n
            targets << possible_targets.delete(possible_targets[rand(i)])
          end
          targets
        end
    end
  end
end