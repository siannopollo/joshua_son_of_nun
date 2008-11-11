module JoshuaSonOfNun
  class Board
    ROWS = ('A'..'J').to_a
    COLUMNS = ('1'..'10').to_a
    
    attr_reader :width, :height, :valid_spaces
    
    def initialize
      @width, @height = 10, 10
      @valid_spaces = []
      ROWS.each do |row|
        COLUMNS.each do |column|
          @valid_spaces << Space.new(row, column)
        end
      end
    end
    
    def adjacent_to_occupied_spaces?(space, ship_length)
      spaces = spaces_for_placement(space, ship_length)
      occupied_spaces.inject(false) do |memo, occupied_space|
        memo |= spaces.inject(false) {|m, s| m |= s.adjacent?(occupied_space)}
      end
    end
    
    def accomodate?(space, ship_length)
      success = true
      spaces_for_placement(space, ship_length).each do |possible_space|
        success &= !occupied_spaces.include?(possible_space) && valid_spaces.include?(possible_space)
      end
      success
    end
    
    def occupied_spaces
      @occupied_spaces ||= []
    end
    
    def placement(ship_length)
      space = nil
      while space.nil? || !accomodate?(space, ship_length) || adjacent_to_occupied_spaces?(space, ship_length)
        space = Space.generate
      end
      occupied_spaces.concat(spaces_for_placement(space, ship_length))
      space.to_s
    end
    
    def spaces_for_placement(space, ship_length)
      if space.orientation == 'horizontal'
        index = COLUMNS.index(space.column) || COLUMNS.size
        (0..(ship_length - 1)).collect {|i| Space.new(space.row, COLUMNS[index + i].to_s) rescue nil}
      else
        index = ROWS.index(space.row) || ROWS.size
        (0..(ship_length - 1)).collect {|i| Space.new(ROWS[index + i].to_s, space.column) rescue nil}
      end
    end
  end
end