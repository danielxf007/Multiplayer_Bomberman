extends "res://game_objects/chest/chest.gd"

class_name BombBoosterChest

const VERTICAL_FRAMES: float = 12.0
const HORIZONTAL_FRAMES: float = 8.0
export(int) var MAX_BOOST: int = 10
export(int ) var MIN_BOOST: int = 1

func _ready():
	self.content = randi() % (self.MAX_BOOST+1) + self.MIN_BOOST
	self.chest_name = "BombBoosterChest"

func scale_chest() -> void:
	var texture_dim: Vector2 = self.texture.get_size()
	texture_dim.x/= self.VERTICAL_FRAMES
	texture_dim.y/= self.HORIZONTAL_FRAMES
	self.scale.x=self.dimensions.first_element/texture_dim.x
	self.scale.y=self.dimensions.second_element/texture_dim.y
