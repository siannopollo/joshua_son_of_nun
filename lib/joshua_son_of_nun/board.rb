module JoshuaSonOfNun
  class Board
    ROWS = ('A'..'J').to_a
    COLUMNS = ('1'..'10').to_a
    
    attr_reader :occupied_spaces, :valid_spaces
    
    def initialize
      @occupied_spaces, @valid_spaces = [], []
      ROWS.each do |row|
        COLUMNS.each do |column|
          @valid_spaces << Space.new(row, column)
        end
      end
    end
    
    def adjacent_to_occupied_spaces?(space, ship_length)
      spaces = space.spaces_for_placement(ship_length)
      occupied_spaces.inject(false) do |memo, occupied_space|
        memo |= spaces.inject(false) {|m, s| m |= s.adjacent?(occupied_space)}
      end
    end
    
    def accomodate?(space, ship_length)
      space.spaces_for_placement(ship_length).inject(true) do |success, possible_space|
        success &= !occupied_spaces.include?(possible_space) && valid_spaces.include?(possible_space)
      end
    end
    
    def placement(ship_length)
      space = nil
      while space.nil? || !accomodate?(space, ship_length) || adjacent_to_occupied_spaces?(space, ship_length)
        space = Space.generate
      end
      occupied_spaces.concat(space.spaces_for_placement(ship_length))
      space.to_s
    end
  end
end