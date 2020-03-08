extends Node

class_name EnemyPlacer

var movements: Array = [Vector2(1, 0), Vector2(-1, 0),
 Vector2(0, -1), Vector2(0, 1)]
var ghost_scene: PackedScene = preload("res://enemies/Ghost.tscn")
var game_board: Board

func init() -> void:
	self.place_ghosts()

func _on_Board_board_created(board):
	self.game_board = board

func concat_array(accumulated: Array, array: Array) -> Array:
	return accumulated + array

func reduce_array(array: Array, initial_value: Array) -> Array:
	var accumulated: Array = initial_value
	for element in array:
		accumulated = self.concat_array(accumulated, element)
	return accumulated

func add_element_to_the_lists(permuted_movements: Array, element) -> Array:
	var new_list: Array = []
	for movement in permuted_movements:
		movement.push_front(element)
		new_list.append(movement)
	return new_list

func create_array_without_element(array: Array, index: int) -> Array:
	var new_array: Array = []
	for i in range(0, array.size()):
		if i != index:
			new_array.append(array[i])
	return new_array

func generate_movements(movements_list: Array) -> Array:
	if movements_list.size() == 1:
		return [[movements_list]]
	var permuted_list : Array = []
	for i in range(0, movements_list.size()):
		var new_array: Array = self.create_array_without_element(
		movements_list, i)
		var generated_movements: Array = generate_movements(new_array)
		generated_movements = self.reduce_array(generated_movements, [])
		permuted_list.append(add_element_to_the_lists(
		generated_movements, movements_list[i]))
	return permuted_list

func place_ghosts() -> void:
	var ghost: Ghost = self.ghost_scene.instance()
	ghost.game_board = self.game_board
	ghost.global_position = Vector2(24.0, 24.0)
	ghost.movement_v = Vector2(1, 0)
	self.game_board.get_node("enemies").add_child(ghost)
