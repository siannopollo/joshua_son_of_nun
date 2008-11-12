module JoshuaSonOfNun
  module Strategy
    class Random < Base
      private
        def assign_targets
          targets = []
          possible_targets.size.times do |n|
            i = 100 - n
            targets << choose_target(rand(i))
          end
          targets
        end
    end
  end
end