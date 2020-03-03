extends Node

class_name CoordinatesConversor
var cell_dim: Tuple

func _init(cell_dimensions: Tuple):
	self.cell_dim = cell_dimensions

func get_player_coordinates_on_board(player_pos: Vector2) -> Tuple:
	var board_coord: Tuple = Tuple.new(
		ceil(player_pos.y/self.cell_dim.second_element)-1,
		ceil(player_pos.x/self.cell_dim.first_element)-1)
	return board_coord
