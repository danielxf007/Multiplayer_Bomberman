extends Area2D

class_name Ghost

var movement_v: Vector2
puppet var puppet_pos = Vector2()
var movements_permu: Array
var game_board: Board
var util_f: UtilFunctions
var coordinate_conversor: CoordinatesConversor
var target_cell: Tuple
var current_cell: Tuple

func _ready():
	self.util_f = UtilFunctions.new()
	self.coordinate_conversor = CoordinatesConversor.new(
	self.game_board.cell_dim)
	self.current_cell = self.coordinate_conversor.get_cell_coordinates_on_board(
	self.global_position)
	$Timer.start()

func _on_Area2D_body_entered(body):
	if not is_network_master():
		return
	if body.has_method("exploded"):
		body.rpc("exploded")

func next_target_cell(movement: Vector2, current_matrix_pos: Tuple) -> Tuple:
	return Tuple.new(current_matrix_pos.first_element +
	movement.y, current_matrix_pos.second_element + movement.x)

func valid_target_cell(target: Tuple) -> bool:
	return (self.util_f.number_in_range(0, 
	int(self.game_board.NUMBER_OF_CELLS_ROWS)-1, target.first_element) and
	self.util_f.number_in_range(0, 
	int(self.game_board.NUMBER_OF_CELLS_COLUMNS)-1, target.second_element))

func get_board_cell(coordinates: Tuple) -> Cell:
	return self.game_board.matrix_of_cells[coordinates.first_element][coordinates.second_element]

func move_ghost() -> void:
	$Timer.start()
	if is_network_master():
		var next_targeted_cell: Tuple = self.next_target_cell(
		self.movement_v, self.current_cell)
		if self.valid_target_cell(next_targeted_cell):
			self.current_cell = next_targeted_cell
			var cell: Cell = self.get_board_cell(next_targeted_cell)
			self.global_position = cell.global_position
			rset("puppet_pos", self.global_position)
		else:
			self.movement_v *= -1
			$Sprite.flip_h = not $Sprite.flip_h
	else:
		self.global_position = puppet_pos

func _on_Timer_timeout():
	self.move_ghost()

sync func do_explosion():
	self.queue_free()

master func exploded():
	rpc("do_explosion") # Re-sent to puppet rocks
