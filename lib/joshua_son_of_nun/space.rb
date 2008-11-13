module JoshuaSonOfNun
  class Space
    ROWS = Board::ROWS
    COLUMNS = Board::COLUMNS
    
    def self.directions
      [:southeast, :southwest, :northeast, :northwest]
    end
    
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
    
    def linear_spaces(other, illegal_spaces = [])
      top, left, bottom, right = nil
      
      if row_index == other.row_index
        left_column_index = (column_index < other.column_index ? column_index : other.column_index)
        right_column_index = left_column_index + 1
        
        unless left_column_index == 0
          while left.nil? || illegal_spaces.include?(left)
            left_column_index -= 1
            left = self.class.new(row, COLUMNS[left_column_index])
          end
        end
        
        unless right_column_index >= 8
          while right.nil? || illegal_spaces.include?(right)
            right_column_index += 1
            right = self.class.new(row, COLUMNS[right_column_index])
          end
        end
      elsif column_index == other.column_index
        top_row_index = (row_index < other.row_index ? row_index : other.row_index)
        bottom_row_index = top_row_index + 1
        
        unless top_row_index == 0
          while top.nil? || illegal_spaces.include?(top)
            top_row_index -= 1
            top = self.class.new(ROWS[top_row_index], column)
          end
        end
        
        unless bottom_row_index >= 8
          while bottom.nil? || illegal_spaces.include?(bottom)
            bottom_row_index += 1
            bottom = self.class.new(ROWS[bottom_row_index], column)
          end
        end
      end
      
      [top, left, bottom, right].compact
    end
    
    def linear_to?(other)
      row_index == other.row_index || column_index == other.column_index
    end
    
    def row_index
      ROWS.index(row)
    end
    
    def spaces_in_knighted_move(direction)
      row_offset, column_offset = case direction
      when :northeast: [[-1, 2], [-2, 1]][rand(2)]
      when :southeast: [[1, 2], [2, 1]][rand(2)]
      when :southwest: [[1, -2], [2, -1]][rand(2)]
      when :northwest: [[-1, -2], [-2, -1]][rand(2)]
      end
      
      r_index, c_index = row_index + row_offset, column_index + column_offset
      if r_index < 0 || c_index < 0 || r_index > 9 || c_index > 9
        nil
      else
        row, column = ROWS[r_index], COLUMNS[c_index]
        self.class.new(row, column)
      end
    end
    
    def spaces_on_diagonal(direction)
      spaces, boundary_reached = [], false
      until boundary_reached
        row_offset, column_offset = case direction
        when :northeast: [-1, 1]
        when :southeast: [1, 1]
        when :southwest: [1, -1]
        when :northwest: [-1, -1]
        end
        
        seed_space = spaces.last || self
        r_index, c_index = seed_space.row_index + row_offset, seed_space.column_index + column_offset
        
        if r_index < 0 || c_index < 0 || r_index > 9 || c_index > 9
          boundary_reached = true
        else
          row, column = ROWS[r_index], COLUMNS[c_index]
          spaces << self.class.new(row, column)
        end
      end
      
      spaces
    end
    
    def to_s
      [row.to_s + column.to_s, orientation].compact * ' '
    end
    alias_method :inspect, :to_s
    
    def ===(klass)
      self.is_a?(klass)
    end
    
    def ==(other)
      to_s == other.to_s
    end
    
    def eql?(other)
      self == other
    end
    
    def equal?(other)
      self.eql?(other) && other === self.class
    end
  end
end