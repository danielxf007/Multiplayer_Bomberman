extends Node

class_name BombExplosions

var explosionF: ExplosionF = ExplosionF.new()
var util_f: UtilFunctions = UtilFunctions.new()

func get_left_range(left_range: int, explosion_point: Tuple) -> Array:
	return range(explosion_point.second_element, 
	explosion_point.second_element - (left_range +1), -1)

func get_right_range(right_range: int, explosion_point: Tuple) -> Array:
	return range(explosion_point.second_element +1,
	explosion_point.second_element + right_range +1) 

func get_up_range(up_range: int, explosion_point: Tuple) -> Array:
	return range(explosion_point.first_element, 
	explosion_point.first_element - (up_range +1), -1)

func get_down_range(down_range: int, explosion_point: Tuple) -> Array:
	return range(explosion_point.first_element+1,
	explosion_point.first_element + down_range +1)

func get_explosion_row(explosion_range: Array, explosion_x: int,
matrix_of_cells: Array) -> Array:
	return self.explosionF.row_explosion(explosion_range, explosion_x,
	matrix_of_cells)

func get_explosion_column(explosion_range: Array, explosion_y: int,
matrix_of_cells: Array) -> Array:
	return self.explosionF.column_explosion(explosion_range, explosion_y,
	matrix_of_cells)

func get_row_explosion(_range: Array, explosion_point: Tuple,
matrix_of_cells: Array) -> Array:
	return self.get_explosion_row(
		_range, explosion_point.first_element,
		matrix_of_cells)

func get_column_explosion(_range: Array, explosion_point: Tuple,
matrix_of_cells: Array) -> Array:
	return self.get_explosion_column(_range, explosion_point.second_element,
	matrix_of_cells)

func filter_explosions(matrix_of_cells: Array, explosions: Array) -> Array:
	var filtered_explosions: Array = []
	var matrix_dim: Tuple = self.util_f.get_dimensions_matrix(
		matrix_of_cells)
	for explosion in explosions:
		if self.util_f.is_inside_matrix(matrix_dim, explosion):
			filtered_explosions.append(explosion)
	return filtered_explosions
