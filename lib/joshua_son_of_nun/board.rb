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
          @valid_spaces << row + column
        end
      end
    end
    
    def accomodate?(board_placement, ship_length)
      success = true
      spaces_for_placement(board_placement, ship_length).each do |space|
        success &= !occupied_spaces.include?(space) && valid_spaces.include?(space)
      end
      success
    end
    
    def coordinates(x, y)
      ROWS[y-1] + COLUMNS[x-1]
    end
    
    def occupied_spaces
      @occupied_spaces ||= []
    end
    
    def placement(ship_length)
      board_placement = nil
      while board_placement.nil? || !accomodate?(board_placement, ship_length)
        board_placement = generate_placement
      end
      occupied_spaces.concat(spaces_for_placement(board_placement, ship_length))
      board_placement
    end
    
    def spaces_for_placement(board_placement, ship_length)
      starting_square, orientation = board_placement.split(' ')
      row, column = starting_square.scan(/(\w)(\d{1,2})/).first
      
      if orientation == 'horizontal'
        index = COLUMNS.index(column) || COLUMNS.size
        (0..(ship_length - 1)).collect {|i| row + COLUMNS[index + i].to_s}
      else
        index = ROWS.index(row) || ROWS.size
        (0..(ship_length - 1)).collect {|i| ROWS[index + i].to_s + column}
      end
    end
    
    private
      def generate_placement
        board_placement = ROWS[rand(10).to_i] + COLUMNS[rand(10).to_i]
        orientation = %w(horizontal vertical)[rand(2)]
        board_placement + ' ' + orientation
      end
  end
end