extends Node

class_name ObjectPlacer

export(int) var CHOICE_OBJECT: int = 10
export(int) var CHOICE_CHEST_TYPE: int = 10
export(Array) var CHOICE_CHEST_INTERVAL: Array  = [0, 1, 2]
export(Array) var CHOICE_LIFE_CHEST_INTERVAL: Array = [0, 1, 2] 
var obstacle_packed_scene: PackedScene = preload("res://rock.tscn")
var life_chest_p_scene: PackedScene = preload("res://game_objects/chest/life_chest/LifeChest.tscn")
var boost_chest_p_scene: PackedScene = preload("res://game_objects/chest/bomb_booster_chest/BombBoosterChest.tscn")
var game_board: Board
var cell: Cell

func init():
	self.organize_obstacle_cells(self.game_board.PATTERN_ON_OFF,
	self.game_board.dimensions)

func _on_Board_board_created(board):
	self.game_board = board

func organize_obstacle_cells(flag: bool, board_dimensions: Tuple) -> void:
	var i = 1
	var j = 1
	var pattern = flag
	var matrix_of_cells: Array = self.game_board.matrix_of_cells
	while i < board_dimensions.first_element-1:
		if pattern:
			j = 1
		else:
			j = 2
		while j < board_dimensions.second_element-1:
			self.cell = matrix_of_cells[i][j]
			self.place_object()
			j += 2
		pattern = not pattern
		i += 1

func place_obstacle() -> void:
	var obstacle
	obstacle = self.obstacle_packed_scene.instance()
	self.game_board.get_node("rocks").add_child(obstacle)
	obstacle.dimensions = self.cell.dimensions
	obstacle.global_position = self.cell.global_position
	self.cell.element = obstacle
	obstacle.cell = self.cell

func place_chest(chest_packed_scene: PackedScene) -> void:
	var chest: Chest = chest_packed_scene.instance()
	self.game_board.get_node("Chests").add_child(chest)
	chest.dimensions = self.cell.dimensions
	chest.scale_chest()
	chest.global_position = self.cell.global_position

func place_obstacle_and_chest() -> void:
	var type_chest: int = randi() % self.CHOICE_CHEST_TYPE
	if type_chest in self.CHOICE_LIFE_CHEST_INTERVAL:
		self.place_chest(self.life_chest_p_scene)
	else:
		self.place_chest(self.boost_chest_p_scene)
	self.place_obstacle()

func place_object() -> void:
	var choice: int = randi() % self.CHOICE_OBJECT
	if choice in self.CHOICE_CHEST_INTERVAL:
		self.place_obstacle_and_chest()
	else:
		self.place_obstacle()
