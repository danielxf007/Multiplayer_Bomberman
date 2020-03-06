extends Node
class_name UtilFunctions

func mantain_in_range(lower_bound, upper_bound, number):
	if number <= lower_bound:
		return lower_bound
	if number >= upper_bound:
		return upper_bound
	return number

func has_reached_upper_bound(upperBound, number) -> bool:
	return number == upperBound

func number_in_range(lower_bound, upper_bound, number) -> bool:
	return lower_bound <= number and number <= upper_bound

func is_inside_matrix(matrix_dim: Tuple, coord: Tuple) -> bool:
	return (self.number_in_range(0, matrix_dim.first_element-1,
	 coord.first_element) and self.number_in_range(0,
	 matrix_dim.second_element-1, coord.second_element))

func is_inside_circle(circle_radius: float, center: Vector2,
 point_coord: Vector2) -> bool:
	return (pow(point_coord.x-center.x, 2.0) + pow(point_coord.y-center.y, 2.0)<=
	pow(circle_radius, 2.0))
