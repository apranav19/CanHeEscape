# A class that represents a cell entity in a maze.
class Cell
	attr_accessor :visited, :blocked
	attr_reader :row_num, :col_num

	def initialize(visited=false, blocked=false, row_num, col_num)
		@visited = visited
		@blocked = blocked
		@row_num = row_num
		@col_num = col_num
	end

end

# A class that represents a maze
class Maze
	attr_reader :num_rows, :num_cols
	attr_accessor :grid

	def initialize(dimensions)
		@num_rows = dimensions[0] + 2
		@num_cols = dimensions[1] + 2
		@grid = create_maze()
	end

	# Prints each cell and its state
	def print_maze
		print 'Num rows: ' + @num_rows.to_s + ' Num Cols: ' + @num_cols.to_s + "\n"
		@grid.each do |row|
			row.each do |cell|
				if cell.blocked
					print "x\t"
				elsif cell.visited
					print "=>\t"
				else
					print "___\t"
				end
			end
			print "\n\n"
		end
	end

	# Given a cell location (row & col pair)
	# This function blocks that cell
	def block_cell(cell_location)
		cell_row, cell_col = cell_location[0], cell_location[1]
		@grid[cell_row][cell_col].blocked = true
	end

	private
	# Constructs a complete maze that is ready for exploration
	def create_maze
		grid = initialize_empty_maze
		return grid
	end

	# Function that simply creates an empty maze where all
	# the cells are unblocked
	def initialize_empty_maze
		grid = []
		for row_num in 0 ... @num_rows
			tmp_grid = []
			for col_num in 0 ... @num_cols
				if (row_num > 0 and row_num < @num_rows-1) and (col_num > 0 and col_num < @num_cols-1)
					tmp_grid.push(Cell.new(false, false, row_num, col_num))
				else
					tmp_grid.push(Cell.new(true, true, row_num, col_num))
				end
			end
			grid.push(tmp_grid)
		end
		return grid
	end
end

# This class has the logic that solves a maze
class MazeSolver
	attr_reader :start_position, :end_position, :path_stack, :maze, :has_a_solution

	def initialize(maze)
		@maze = maze
		@start_position = [1,1]
		@end_position = [@maze.num_rows-2, @maze.num_cols-2]
		@path_stack = []
		@has_a_solution = false
	end

	# Finds a path in the maze
	def find_path
		decision_stack = [@maze.grid[1][1]]
		result = find_path_helper(decision_stack)
		return result
	end

	# Prints an ordered list of the path
	def print_path
		if @path_stack.empty?
			print "No paths found!\n"
		else
			@path_stack.each_with_index do |path, num|
				print (num+1).to_s + ") Move to: [" + (path[0]-1).to_s + ", " + (path[1]-1).to_s + "]\n"
			end
		end
	end

	private
	# The path finding algorithm 
	def find_path_helper(ds_stack)
		while not ds_stack.empty?
			popped_cell = ds_stack.pop()
			popped_cell.visited = true
			@path_stack.push([popped_cell.row_num, popped_cell.col_num])
			if [popped_cell.row_num, popped_cell.col_num] == @end_position
				@has_a_solution = true
				return true
			else
				# Get possible moves from current position
				possible_moves = get_possible_moves(popped_cell)
				if not possible_moves.empty?
					possible_moves.each do |move|
						ds_stack.push(move)
					end
				else
					@path_stack.pop()
				end
			end
		end
		return false
	end

	# Given a cell, this function finds all the possible locations
	# that can be moved on to
	def get_possible_moves(cell)
		possible_moves = []
		if can_move_north(cell)
			north_position = @maze.grid[cell.row_num-1][cell.col_num]
			possible_moves.push(north_position)
		end
		if can_move_east(cell)
			east_position = @maze.grid[cell.row_num][cell.col_num+1]
			possible_moves.push(east_position)
		end
		if can_move_west(cell)
			west_position = @maze.grid[cell.row_num][cell.col_num-1]
			possible_moves.push(west_position)
		end
		if can_move_south(cell)
			south_position = @maze.grid[cell.row_num+1][cell.col_num]
			possible_moves.push(south_position)
		end
		return possible_moves
	end

	def can_move_north(cell)
		north_cell = @maze.grid[cell.row_num-1][cell.col_num]
		if north_cell.visited or north_cell.blocked 
			return false
		end
		return true
	end

	def can_move_south(cell)
		south_cell = @maze.grid[cell.row_num+1][cell.col_num]
		if south_cell.visited or south_cell.blocked
			return false  
		end
		return true
	end

	def can_move_east(cell)
		east_cell = @maze.grid[cell.row_num][cell.col_num+1]
		if east_cell.visited or east_cell.blocked
			return false 
		end
		return true
	end

	def can_move_west(cell)
		west_cell = @maze.grid[cell.row_num][cell.col_num-1]
		if west_cell.visited or west_cell.blocked
			return false
		end
		return true
	end

end