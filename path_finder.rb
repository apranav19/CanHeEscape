load 'maze.rb'
require 'erb'
include ERB::Util

# This class handles an input file and solves the maze
class PathFinder
	attr_reader :maze_solver

	# Constructor to initialize the input data
	# Instantiates a MazeSolver and loads a maze
	def initialize(input_data)
		@input_data = input_data
		@maze_solver = MazeSolver.new(create_maze)
	end

	# Prints the state of the maze
	def print_maze
		print "Printing the maze\n"
		@maze_solver.maze.print_maze
	end

	# Prepares to solve the maze
	# If there's a solution, it prints the path
	def find_solution
		print "Finding Solution\n"
		solution = @maze_solver.find_path
		if solution
			print "There is a path through the maze\n"
			print "Printing the path\n"
			@maze_solver.print_path
		else
			print "There is no path\n"
		end
		return solution
	end

	private
	# Function that reads the 1st line of the input file
	# It then creates a new maze on those dimensions
	# And blocks user specified cells and returns the maze
	def create_maze
		maze_dimensions = nil
		begin
			maze_dimensions = parse_text_to_location(@input_data[0])
		rescue Exception => e
			puts "Looks like the input file contains non-integer data"
		end
		
		maze = Maze.new(maze_dimensions)
		return block_custom_cells(maze)
	end

	# Function that blocks the user specified cells in a maze
	# Returns the updated maze
	def block_custom_cells(maze)
		for line_num in 1...@input_data.size
			cell_location = parse_text_to_location(@input_data[line_num])
			cell_location[0] += 1
			cell_location[1] += 1
			maze.block_cell(cell_location)
		end
		return maze
	end

	# Function that converts an array comprising of two strings into an integer array
	def parse_text_to_location(text_array)
		result = []
		begin
			result = text_array.split(",").map{|elem| elem.to_i}
		rescue Exception => e
			puts "Looks like the input file contains non-integer data"
		end
		return result
	end
end

# This class takes in a maze solver and a boolean if a maze has been solved
# It's role is primarily to render the HTML output
class WebPrinter
	attr_accessor :template, :maze_solver
	attr_reader	:has_a_solution

	# Constructor that initializes the instance variables
	def initialize(maze_solver, has_a_solution)
		@maze_solver = maze_solver
		@has_a_solution = has_a_solution
		@template = generate_template
	end

	# Prepares an embedded ruby file
	def render
		return ERB.new(@template).result(binding())
	end
	
	private
	# Returns a string representing the skeleton HTML ERB template
	def generate_template
		%{
			<!DOCTYPE html>
			<html>
				<head>
				 	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
				 	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
				 	<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
				 	<link href="http://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
					<link rel="stylesheet" type="text/css" href="maze.css">
					<script src="http://use.edgefonts.net/fredericka-the-great;love-ya-like-a-sister.js"></script> 
				 	<script src="maze.js"></script>
				 	<script>
				 		<% @maze_solver.path_stack.each do |path| %>
				 			var path_row = <%=path[0]%>;
				 			var path_col = <%=path[1]%>;
				 			visitedGrid.push({row_num: path_row, col_num: path_col});
			 			<% end %>
				 	</script>
				</head>
				<body>
					<div class="maze_container container">
						<h2>Can he escape?</h2>
						<h5 id="myname"> By Pranav Angara </h5>
						<div class="grid-container">
							<% (1...@maze_solver.maze.grid.size-1).each do |row| %>
								<div class="row row-n">
									<% (1...@maze_solver.maze.grid[row].size-1).each do |col| %>
										<div class="cell col-md-1" id="r<%=row%>c<%=col%>">
										</div>
										<% if @maze_solver.maze.grid[row][col].blocked %>
											<script>
												var row_num = <%= row %>;
												var col_num = <%= col %>;
												dataGrid.push({row: row_num, col: col_num});
											</script>
										<% end %>
									<% end %>
								</div>
							<% end %>
						</div>
						<div class="btn-row row">
							<div class="col-md-1 btn-wrapper">
								<h5 id="myname">Play<button type="button" id="play-button" class="btn btn-primary"><i class="fa fa-play fa-2x"></i></button>
								</h5>
							</div>
						</div>
					</div>
					<!-- Modal -->
					<button id="modal-btn" class="btn" data-toggle="modal" data-target="#video-box" style="display:none">
  						Launch demo modal
					</button>
					<div class="modal fade" id="video-box" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					  <div class="modal-dialog">
					    <div class="modal-content">
					      <div class="modal-body">
					      	<% if @has_a_solution %>
					      		<h2>And he's outta here!</h2>
					      		<img class="exit-meme" src="http://www.funnymeme.com/wp-content/uploads/2014/05/Funny-gifs-this-guy-is-a-pro.gif">
					      	<% else %>
					      		<h2>  He's doomed! </h2>
					      		<img class="exit-meme" src="http://www.funnymeme.com/wp-content/uploads/2014/05/Funny-gifs-take-advantage-of-the-situation.gif">
					      	<% end %>
					      </div>
					    </div>
					  </div>
					</div>
				</body>
			</html>
		}
	end
end

# Load & Handle Input text files
begin
	input_file = File.open('input2.txt', 'r')
rescue Exception => e
	puts "Looks like the input file either doesn't exist or is invalid"
else
	input_data = input_file.readlines
end

path_finder = PathFinder.new(input_data)
path_finder.print_maze 		# Before attempting to find a path
solution = path_finder.find_solution 	# Find a solution
if solution
	path_finder.print_maze
end

wp = WebPrinter.new(path_finder.maze_solver, solution)
output_file = File.open('output.html', 'w+')
output_file.write(wp.render)