module JoshuaSonOfNun
  class Space
    ROWS = Board::ROWS
    COLUMNS = Board::COLUMNS
    
    def self.generate
      new(ROWS[rand(10).to_i], COLUMNS[rand(10).to_i], %w(horizontal vertical)[rand(2)])
    end
    
    attr_reader :row, :column, :orientation
    
    def initialize(row, column, orientation = nil)
      raise 'Invalid space' unless ROWS.include?(row) && COLUMNS.include?(column)
      
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
    
    def crosswise_spaces
      top, right, bottom, left = nil
      
      top    = (index = row_index - 1) < 0 ? nil : self.class.new(ROWS[index], column)
      right  = (index = column_index + 1) > 9 ? nil : self.class.new(row, COLUMNS[index])
      bottom = (index = row_index + 1) > 9 ? nil : self.class.new(ROWS[index], column)
      left   = (index = column_index - 1) < 0 ? nil : self.class.new(row, COLUMNS[index])
      [top, right, bottom, left].compact
    end
    
    def row_index
      ROWS.index(row)
    end
    
    def to_s
      [row.to_s + column.to_s, orientation].compact * ' '
    end
    alias_method :inspect, :to_s
    
    def ==(other)
      to_s == other.to_s
    end
  end
end