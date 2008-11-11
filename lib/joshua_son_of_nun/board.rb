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
        (0..(ship_length - 1)).collect {|i| Space.new(space.row, COLUMNS[index + i].to_s)}
      else
        index = ROWS.index(space.row) || ROWS.size
        (0..(ship_length - 1)).collect {|i| Space.new(ROWS[index + i].to_s, space.column)}
      end
    end
    
    private
      def extract_row_and_column(square)
        square.scan(/(\w)(\d{1,2})/).first
      end
      
      def generate_placement
      end
    public
    
    class Space
      ROWS = Board::ROWS
      COLUMNS = Board::COLUMNS
      
      def self.generate
        new(ROWS[rand(10).to_i], COLUMNS[rand(10).to_i], %w(horizontal vertical)[rand(2)])
      end
      
      attr_reader :row, :column, :orientation
      
      def initialize(row = nil, column = nil, orientation = nil)
        @row, @column, @orientation = row, column, orientation
      end
      
      def adjacent?(other)
        success = true
        success &= begin
          row_range = ((row_index == 0 ? 0 : row_index-1)..row_index+1)
          other_row_range = ((other.row_index == 0 ? 0 : other.row_index-1)..other.row_index+1)
          
          row_range.include?(other.row_index) || other_row_range.include?(row_index)
        end
        
        success &= begin
          column_range = ((column_index == 0 ? 0 : column_index-1)..column_index+1)
          other_column_range = ((other.column_index == 0 ? 0 : other.column_index-1)..other.column_index+1)
          
          column_range.include?(other.column_index) || other_column_range.include?(column_index)
        end
        
        success
      end
      
      def column_index
        COLUMNS.index(column)
      end
      
      def row_index
        ROWS.index(row)
      end
      
      def to_s
        [row.to_s + column.to_s, orientation].compact * ' '
      end
      
      def ==(other)
        to_s == other.to_s
      end
    end
  end
end