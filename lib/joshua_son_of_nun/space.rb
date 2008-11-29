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
      adjacent_row_range.include?(other.row_index) && adjacent_column_range.include?(other.column_index)
    end
    
    def column_index
      COLUMNS.index(column)
    end
    
    def crosswise_spaces
      top    = (index = row_index - 1) < 0 ? nil : Space.new(ROWS[index], column)
      right  = (index = column_index + 1) > 9 ? nil : Space.new(row, COLUMNS[index])
      bottom = (index = row_index + 1) > 9 ? nil : Space.new(ROWS[index], column)
      left   = (index = column_index - 1) < 0 ? nil : Space.new(row, COLUMNS[index])
      [top, right, bottom, left].compact
    end
    
    def linear_spaces(other, all_illegal_spaces = [], successful_illegal_spaces = [])
      top, left, bottom, right = nil
      illegal_spaces = all_illegal_spaces.dup.concat([self, other]).uniq
      successful_spaces = successful_illegal_spaces.dup
      
      if row_index == other.row_index
        left, right = assign_left_and_right(other.column_index, illegal_spaces, successful_spaces)
      elsif column_index == other.column_index
        top, bottom = assign_top_and_bottom(other.row_index, illegal_spaces, successful_spaces)
      end
      
      [top, left, bottom, right].compact
    end
    
    def linear?(other)
      row_index == other.row_index || column_index == other.column_index
    end
    
    def row_index
      ROWS.index(row)
    end
    
    def spaces_for_placement(ship_length)
      args = case orientation
      when 'horizontal': lambda {|i| [row, COLUMNS[column_index + i].to_s]}
      when 'vertical':   lambda {|i| [ROWS[row_index + i].to_s, column]}
      end
      
      (0..(ship_length - 1)).collect {|i| Space.new(*args.call(i)) rescue nil}
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
        Space.new(ROWS[r_index], COLUMNS[c_index])
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
          spaces << Space.new(ROWS[r_index], COLUMNS[c_index])
        end
      end
      
      spaces
    end
    
    def to_s
      [row.to_s + column.to_s, orientation].compact * ' '
    end
    alias_method :inspect, :to_s
    
    def ==(other)
      to_s == other.to_s
    end
    
    private
      def adjacent_column_range
        ((column_index == 0 ? 0 : column_index-1)..column_index+1)
      end
      
      def adjacent_row_range
        ((row_index == 0 ? 0 : row_index-1)..row_index+1)
      end
      
      def assign_left_and_right(other_column_index, illegal_spaces, successful_spaces)
        left_index = (column_index < other_column_index ? column_index : other_column_index)
        right_index = left_index + 1
        
        surrounding_linear_spaces(left_index, right_index, illegal_spaces, successful_spaces) do |i, row, column|
          Space.new(row, COLUMNS[i])
        end
      end
      
      def assign_top_and_bottom(other_row_index, illegal_spaces, successful_spaces)
        top_index = (row_index < other_row_index ? row_index : other_row_index)
        bottom_index = top_index + 1
        
        surrounding_linear_spaces(top_index, bottom_index, illegal_spaces, successful_spaces) do |i, row, column|
          Space.new(ROWS[i], column)
        end
      end
      
      def surrounding_linear_spaces(side_one_index, side_two_index, illegal_spaces, successful_spaces, &space_creation_block)
        side_one_spaces  = (0..side_one_index).collect {|i| space_creation_block.call(i, row, column)}
        side_two_spaces = (side_two_index..9).collect {|i| space_creation_block.call(i, row, column)}
        
        illegal_spaces.each do |space|
          side_one_spaces.delete(space)
          side_two_spaces.delete(space)
        end
        
        spaces = {
          :side_one_space => side_one_spaces.pop,
          :side_two_space => side_two_spaces.shift
        }
        
        unless illegal_spaces.empty? || successful_spaces.empty?
          unsuccessful_spaces = illegal_spaces.reject {|s| successful_spaces.include?(s)}
          
          [:side_one_space, :side_two_space].each do |key|
            space = spaces[key]
            spaces[key] = nil if !space.nil? &&
                                 unsuccessful_spaces.detect {|s| space.adjacent?(s)} &&
                                 !successful_spaces.detect {|s| space.adjacent?(s)}
          end
        end
        
        [spaces[:side_one_space], spaces[:side_two_space]]
      end
  end
end