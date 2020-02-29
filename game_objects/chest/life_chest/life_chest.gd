extends "res://game_objects/chest/chest.gd"

class_name LifeChest

export(int) var MAX_HEALTH: int = 2
export(int ) var MIN_HEALTH: int = 1

func _ready():
	self.content = randi() % (self.MAX_HEALTH+1) + self.MIN_HEALTH
	self.chest_name = "LifeChest"
