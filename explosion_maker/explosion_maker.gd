extends Node

class_name ExplosionMaker

export(int) var BOMB_TYPE: int = 1
var explosion_packed_scene: PackedScene = preload("res://explosion/Explosion.tscn")
var bomb_packed_scene: PackedScene = preload("res://bomb/Bomb.tscn")
var cross_explosion: CrossExplosion = CrossExplosion.new()
var game_board: Board

func _on_Board_board_created(board):
	self.game_board = board
