extends Node

class_name EnemyPlacer

var movements: Array = [Vector2(1, 0), Vector2(1, 1), Vector2(1, -1),
Vector2(0, 0), Vector2(0, 1), Vector2(0, -1), Vector2(-1, 0), Vector2(-1, 1),
Vector2(-1, -1)]

func add_element_to_the_lists(permuted_movements: Array, element) -> Array:
	var new_list: Array = []
	for movement in permuted_movements:
		new_list.append(movement.push_front(element))
	return new_list

func generate_movements(movements_list: Array) -> Array:
	if movements_list.size() == 1:
		return [movements_list]
	var permuted_list : Array = []
	for element in movements_list:
		permuted_list.append(add_element_to_the_lists(
			generate_movements(movements_list.slice(1, movements_list.size())),
			 element))
	return permuted_list
