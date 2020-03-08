extends Node2D
signal board_created(board)
class_name Board
const CELL_X_DIM: float = 48.0
const CELL_Y_DIM: float = 48.0
export(Vector2) var board_top_pos: Vector2 = Vector2()
export(Texture) var ON_CELL
export(Texture) var OFF_CELL
export(bool) var PATTERN_ON_OFF = true
export(float) var NUMBER_OF_CELLS_COLUMNS: float = 22.0
export(float) var NUMBER_OF_CELLS_ROWS: float = 13.0
var dimensions: Tuple
var cell_dim: Tuple 
var cells_node
var matrix_of_cells: Array
var walls: Node2D


func _ready():
	self.dimensions = Tuple.new(self.NUMBER_OF_CELLS_ROWS,
	 self.NUMBER_OF_CELLS_COLUMNS)
	self.cells_node = $Cells
	self.walls = $walls
	self.cell_dim = Tuple.new(self.CELL_X_DIM, self.CELL_Y_DIM)
	self.board_top_pos.x = self.cell_dim.first_element/2.0
	self.board_top_pos.y = self.cell_dim.second_element/2.0
	self.matrix_of_cells = self.create_matrix(self.board_top_pos,
	self.NUMBER_OF_CELLS_ROWS, self.NUMBER_OF_CELLS_COLUMNS,
	self.cell_dim, preload("res://cell/Cell.tscn"))
	self.organize_matrix_of_cells(self.PATTERN_ON_OFF, 
	self.dimensions, self.ON_CELL, self.OFF_CELL)
	self.organize_surroundings(preload("res://wall/Wall.tscn"))

func create_column_cells(starting_point: Vector2, n_cells: float,
 cell_dimensions: Tuple, cell_packed_scene: PackedScene) -> Array:
	var cell: Cell = cell_packed_scene.instance()
	self.cells_node.add_child(cell)
	cell.dimensions = cell_dimensions
	cell.position = starting_point
	var cell_column: Array = [cell]
	var before_cell: Cell
	for j in range(1, n_cells):
			cell = cell_packed_scene.instance()
			self.cells_node.add_child(cell)
			cell.dimensions = cell_dimensions
			before_cell = cell_column[j-1]
			cell.position.x = (before_cell.position.x +
			before_cell.dimensions.first_element)
			cell.position.y = before_cell.position.y
			cell_column.append(cell)
	return cell_column

func create_matrix(matrix_top_pos: Vector2, n_rows: float, n_columns: float,
cell_dimensions: Tuple, cell_scene: PackedScene) -> Array:
	var matrix: Array = []
	for _i in range(0, n_rows):
		matrix.append(self.create_column_cells(matrix_top_pos, n_columns,
		cell_dimensions, cell_scene))
		matrix_top_pos.y+= cell_dimensions.second_element
	return matrix

func organize_on_cells(flag: bool, board_dimensions: Tuple,
 on_cell: Texture) -> void:
	var i = 0
	var j = 0
	var pattern = flag
	while i < board_dimensions.first_element:
		if pattern:
			j = 0
		else:
			j = 1
		while j < board_dimensions.second_element:
			self.matrix_of_cells[i][j].texture = on_cell
			j += 2
		pattern = not pattern
		i += 1

func organize_off_cells(flag: bool, board_dimensions: Tuple,
 off_cell: Texture) -> void:
	var i = 0
	var j = 0
	var pattern = flag
	while i < board_dimensions.first_element:
		if pattern:
			j = 1
		else:
			j = 0
		while j < board_dimensions.second_element:
			self.matrix_of_cells[i][j].texture = off_cell
			j += 2
		pattern = not pattern
		i += 1

func organize_matrix_of_cells(flag: bool, board_dimensions: Tuple, 
on_cell: Texture, off_cell: Texture) -> void:
	self.organize_on_cells(flag, board_dimensions, on_cell)
	self.organize_off_cells(flag, board_dimensions, off_cell)

func create_row_of_walls(starting_point: Vector2, n_rows: float,
 cell_dimensions: Tuple, wall_packed_scene: PackedScene) -> void:
	var wall: Wall = wall_packed_scene.instance()
	self.walls.add_child(wall)
	wall.dimensions = cell_dimensions
	wall.global_position = starting_point
	var wall_row: Array = [wall]
	var before_wall: Wall
	for i in range(1, n_rows):
		wall = wall_packed_scene.instance()
		before_wall = wall_row[i-1]
		self.walls.add_child(wall)
		wall.dimensions = cell_dimensions
		wall.global_position.x = before_wall.global_position.x
		wall.global_position.y = (cell_dimensions.second_element +
		 before_wall.global_position.y)
		wall_row.append(wall)

func create_column_of_walls(starting_point: Vector2, n_columns: float,
 cell_dimensions: Tuple, wall_packed_scene: PackedScene) -> void:
	var wall: Wall = wall_packed_scene.instance()
	self.walls.add_child(wall)
	wall.dimensions = cell_dimensions
	wall.global_position = starting_point
	var wall_column: Array = [wall]
	var before_wall: Wall
	for j in range(1, n_columns):
		wall = wall_packed_scene.instance()
		before_wall = wall_column[j-1]
		self.walls.add_child(wall)
		wall.dimensions = cell_dimensions
		wall.global_position.x = (cell_dimensions.first_element +
		 before_wall.global_position.x)
		wall.global_position.y = before_wall.global_position.y
		wall_column.append(wall)

func organize_surroundings(wall_packed_scene: PackedScene) -> void:
	self.create_row_of_walls(Vector2(-self.board_top_pos.x, self.board_top_pos.y),
	self.NUMBER_OF_CELLS_ROWS, self.cell_dim, wall_packed_scene)
	self.create_row_of_walls(Vector2(
	self.board_top_pos.x+self.cell_dim.first_element*(
	self.NUMBER_OF_CELLS_COLUMNS), self.board_top_pos.y),
	self.NUMBER_OF_CELLS_ROWS, self.cell_dim, wall_packed_scene)
	self.create_column_of_walls(Vector2(self.board_top_pos.x,
	-self.board_top_pos.y), self.NUMBER_OF_CELLS_COLUMNS, self.cell_dim,
	wall_packed_scene)
	self.create_column_of_walls(Vector2(self.board_top_pos.x,
	self.board_top_pos.y+self.cell_dim.second_element*(
	self.NUMBER_OF_CELLS_ROWS)),self.NUMBER_OF_CELLS_COLUMNS,
	self.cell_dim, wall_packed_scene)

func board_created() -> void:
	for element in self.get_tree().get_nodes_in_group("board_listener"):
# warning-ignore:return_value_discarded
		self.connect("board_created", element, "_on_Board_board_created")
	self.emit_signal("board_created", self)
