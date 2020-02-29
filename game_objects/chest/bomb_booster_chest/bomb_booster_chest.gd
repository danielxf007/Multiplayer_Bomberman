extends "res://game_objects/chest/chest.gd"

class_name BombBoosterChest

export(int) var MAX_BOOST: int = 10
export(int ) var MIN_BOOST: int = 1

func _ready():
	self.content = randi() % (self.MAX_BOOST+1) + self.MIN_BOOST
	self.chest_name = "BombBoosterChest"
