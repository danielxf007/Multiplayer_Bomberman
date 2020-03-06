extends Node
signal board_created(board)
class_name Board

export(Vector2) var cell_dimensions = Vector2(1, 1)
export(Vector2) var board_top_pos: Vector2 = Vector2()
export(Texture) var ON_CELL
export(Texture) var OFF_CELL
export(bool) var PATTERN_ON_OFF = true
export(float) var NUMBER_OF_CELLS_COLUMNS: float = 22
export(float) var NUMBER_OF_CELLS_ROWS: float = 13
var cell_dim: Tuple 
var cells_node
var board_size: Vector2
var matrix_of_cells: Array


func _ready():
	self.cells_node = $Cells
	var window: Viewport = self.get_parent().get_viewport()
	var window_size: Vector2 = window.size
	self.board_size = Vector2(floor(window.size.x/self.cell_dimensions.x),
	floor(window.size.y/ self.cell_dimensions.y))
	self.cell_dim = Tuple.new(window_size.x/self.NUMBER_OF_CELLS_COLUMNS,
	window_size.y/self.NUMBER_OF_CELLS_ROWS)
	self.matrix_of_cells = self.create_matrix(self.board_top_pos,
	self.board_size, self.cell_dimensions,
	preload("res://cell/Cell.tscn"))
	self.organize_matrix_of_cells(self.PATTERN_ON_OFF, 
	self.board_size, self.ON_CELL, self.OFF_CELL)


func create_matrix(matrix_top_pos: Vector2, dimensions: Vector2,
 cell_size: Vector2,cell_scene: PackedScene) -> Array:
	var one_x_n_matrix: Array = []
	var cell: Cell
	var before_cell: Cell
	for i in range(0, dimensions.y):
		if i != 0:
			cell = cell_scene.instance()
			self.cells_node.add_child(cell)
			cell.cell_size = cell_size
			cell.dimensions = self.cell_dim
			before_cell = one_x_n_matrix[i-1][0]
			cell.position.x = matrix_top_pos.x
			cell.position.y = (before_cell.position.y +
			before_cell.cell_size.y)
			one_x_n_matrix.append([cell])
		else:
			cell = cell_scene.instance()
			self.cells_node.add_child(cell)
			cell.cell_size = cell_size
			cell.dimensions = self.cell_dim
			cell.position = matrix_top_pos
			one_x_n_matrix.append([cell])
	var cell_matrix: Array = []
	for i in range(0, dimensions.y):
		cell_matrix.append(one_x_n_matrix[i])
# warning-ignore:unused_variable
		for j in range(1, dimensions.x):
			cell = cell_scene.instance()
			self.cells_node.add_child(cell)
			cell.cell_size = cell_size
			cell.dimensions = self.cell_dim
			before_cell = cell_matrix[i][j-1]
			cell.position.x = (before_cell.position.x +
			before_cell.cell_size.x)
			cell.position.y = before_cell.position.y
			cell_matrix[i].append(cell)
	return cell_matrix

func organize_on_cells(flag: bool, matrix_size: Vector2,
 on_cell: Texture) -> void:
	var i = 0
	var j = 0
	var pattern = flag
	while i < matrix_size.y:
		if pattern:
			j = 0
		else:
			j = 1
		while j < matrix_size.x:
			self.matrix_of_cells[i][j].texture = on_cell
			self.matrix_of_cells[i][j].scale_cell()
			j += 2
		pattern = not pattern
		i += 1

func organize_off_cells(flag: bool,matrix_size: Vector2,
 off_cell: Texture) -> void:
	var i = 0
	var j = 0
	var pattern = flag
	while i < matrix_size.y:
		if pattern:
			j = 1
		else:
			j = 0
		while j < matrix_size.x:
			self.matrix_of_cells[i][j].texture = off_cell
			self.matrix_of_cells[i][j].scale_cell()
			j += 2
		pattern = not pattern
		i += 1

func organize_matrix_of_cells(flag: bool, matrix_size: Vector2, 
on_cell: Texture, off_cell: Texture) -> void:
	self.organize_on_cells(flag, matrix_size, on_cell)
	self.organize_off_cells(flag, matrix_size, off_cell)

func board_created() -> void:
	for element in self.get_tree().get_nodes_in_group("board_listener"):
# warning-ignore:return_value_discarded
		self.connect("board_created", element, "_on_Board_board_created")
	self.emit_signal("board_created", self)
