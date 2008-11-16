module JoshuaSonOfNun
  module Strategy
    class Random < Base
      private
        def assign_targets
          targets = []
          possible_targets.size.times do |n|
            targets << choose_target(rand(100 - n))
          end
          targets
        end
    end
  end
end