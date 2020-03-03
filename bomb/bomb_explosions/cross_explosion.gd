extends "res://bomb/bomb_explosions/bomb_explosions.gd"

class_name CrossExplosion

export(int) var LEFT_RANGE = 0
export(int) var RIGHT_RANGE = 0
export(int) var UP_RANGE = 0
export(int) var DOWN_RANGE = 0
var bomb_type: int = 1


func explode( explosion_point: Tuple, matrix_of_cells: Array) -> Array:
	var center: Array = [explosion_point]
	var left_explosion: Array = self.get_row_explosion(
		self.get_left_range(self.LEFT_RANGE * self.bomb_type,
		 explosion_point), explosion_point, matrix_of_cells
	)
	var right_explosion: Array = self.get_row_explosion(
		self.get_right_range(self.RIGHT_RANGE * self.bomb_type,
		 explosion_point), explosion_point, matrix_of_cells
	)
	var up_explosion: Array = self.get_column_explosion(
		self.get_up_range(self.UP_RANGE * self.bomb_type,
		 explosion_point), explosion_point, matrix_of_cells
	)
	var down_explosion: Array = self.get_column_explosion(
		self.get_down_range(self.DOWN_RANGE  * self.bomb_type,
		 explosion_point), explosion_point, matrix_of_cells
	)
	return (center + left_explosion + right_explosion + 
	up_explosion + down_explosion)


func _on_Bomb_bomb_typed(type: int):
	self.bomb_type = type
