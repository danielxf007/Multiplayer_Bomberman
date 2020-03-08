extends Node2D

class_name Ghost

const SPEED: float = 90.0
puppet var movements: Array
puppet var puppet_pos = Vector2()
var right_ray: RayCast2D
var left_ray: RayCast2D
var up_ray: RayCast2D
var down_ray: RayCast2D
var game_board: Board
var util_f: UtilFunctions
var coordinate_conversor: CoordinatesConversor
var target_cell: Tuple
var current_board_pos: Tuple

func _ready():
	self.right_ray = $Right
	self.left_ray = $Left
	self.up_ray = $Up
	self.down_ray = $Down

func _on_Area2D_body_entered(body):
	if not is_network_master():
		return
	if body.has_method("exploded"):
		body.rpc("exploded")

func choose_movement() -> Array:
	return []

func colliding() -> bool:
	return (self.right_ray.is_colliding() or self.left_ray.is_colliding() or
	self.up_ray.is_colliding() or self.down_ray.is_colliding())

func set_target_cell(movement: Vector2, current_matrix_pos: Tuple) -> void:
	self.target_cell.first_element = (current_matrix_pos.first_element +
	movement.x)
	self.target_cell.second_element = (current_matrix_pos.second_element +
	movement.y)

func is_in_cell(ghost_indexes: Tuple, ghost_pos: Vector2) -> bool:
	return self.util_f.is_inside_square(self.game_board.cell_container_dim,
	self.game_board.matrix_of_cells[ghost_indexes.first_element][ghost_indexes.second_element],
	ghost_pos)

func _physics_process(delta):
		if is_network_master():
			pass
		else:
			global_position = puppet_pos
		if self.movements:
			if self.target_cell:
				self.global_position += self.movements[0]*self.SPEED*delta
				if not self.is_colli
		if not is_network_master():
			puppet_pos = global_position # To avoid jitter
