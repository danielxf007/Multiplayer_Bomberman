extends KinematicBody2D

const ROCK_POINTS: int = 1
var cell: Cell
var dimensions: Tuple
# Sent to everyone else
sync func do_explosion():
	get_node("anim").play("explode")
	if self.cell:
		self.cell.clear_element()


master func exploded():
	rpc("do_explosion") # Re-sent to puppet rocks
