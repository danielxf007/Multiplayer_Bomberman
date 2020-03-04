extends StaticBody2D
class_name Bomb

export(int) var TYPE: int = 1
var board_coordinates: Tuple
var explosion_packed_scene: PackedScene = preload("res://explosion/Explosion.tscn")
var game_board: Board
var explosions: Array = []
var from_player

func _ready():
	$AnimationPlayer.play("placed_bomb")
	$PlacedBombTimer.start()
	$ExplosionTime.start()

func _on_PlacedBombTimer_timeout():
	self.bomb_explosion()

func create_explosions(explosion_range_size: int) -> void:
	var explosion: Explosion
# warning-ignore:unused_variable
	for i in range(0, explosion_range_size):
		explosion = self.explosion_packed_scene.instance()
		explosion.from_player = self.from_player
		self.explosions.append(explosion)

func place_explosions(explosions_coordinates: Array) -> void:
	var explosion: Explosion
	var explosion_coord: Tuple
	var cell: Cell
	var row_coord: int
	var column_coord: int
	var matrix_of_cells: Array = self.game_board.matrix_of_cells
	for i in range(0, explosions_coordinates.size()):
		explosion = self.explosions[i]
		explosion_coord = explosions_coordinates[i]
		row_coord = explosion_coord.first_element
		column_coord = explosion_coord.second_element
		cell = matrix_of_cells[row_coord][column_coord]
		self.game_board.add_child(explosion)
		explosion.global_position = cell.global_position

func explode() -> void:
	var explosion_coordinates: Array = $CrossExplosion.explode(
		board_coordinates, self.game_board.matrix_of_cells)
	self.create_explosions(explosion_coordinates.size())
	self.place_explosions(explosion_coordinates)

func bomb_explosion() -> void:
	self.explode()


func _on_ExplosionTime_timeout():
	self.queue_free()
