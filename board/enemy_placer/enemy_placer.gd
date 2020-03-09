extends Node

class_name EnemyPlacer

var movements: Array = [Vector2(1, 0), Vector2(-1, 0),
 Vector2(0, -1), Vector2(0, 1)]
var ghost_packed_scene: PackedScene = preload("res://enemies/Ghost.tscn")
var game_board: Board

func init() -> void:
	self.place_ghosts(self.game_board.matrix_of_cells,
	int(self.game_board.NUMBER_OF_CELLS_ROWS),
	int(self.game_board.NUMBER_OF_CELLS_COLUMNS),
	Vector2(1, 0), self.ghost_packed_scene, true)
	self.place_ghosts(self.game_board.matrix_of_cells,
	int(self.game_board.NUMBER_OF_CELLS_COLUMNS),
	int(self.game_board.NUMBER_OF_CELLS_ROWS),
	Vector2(0, 1), self.ghost_packed_scene, false)

func _on_Board_board_created(board):
	self.game_board = board

func place_ghosts(matrix_of_cells: Array, static_range_size: int, 
dynamic_range_size: int, movement_v: Vector2, ghost_scene: PackedScene,
type: bool) -> void:
	var flag: bool = true
	var i = 1
	var j = 1
	var cell: Cell
	while i < static_range_size-1:
		if type:
			cell = matrix_of_cells[i][i]
		else:
			cell = matrix_of_cells[j][i]
		var ghost: Ghost = ghost_scene.instance()
		ghost.game_board = self.game_board
		ghost.global_position = cell.global_position
		if flag:
			ghost.movement_v = movement_v
		else:
			ghost.movement_v = movement_v*-1
		flag = not flag
		self.game_board.get_node("enemies").add_child(ghost)
		j += 1
		j %= dynamic_range_size
		i += 2
