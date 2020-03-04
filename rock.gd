extends KinematicBody2D

const ROCK_POINTS: int = 1
var cell: Cell
# Sent to everyone else
puppet func do_explosion():
	get_node("anim").play("explode")
	if self.cell:
		self.cell.clear_element()

# Received by owner of the rock
master func exploded(by_who):
	rpc("do_explosion") # Re-sent to puppet rocks
	get_node("../../score").rpc("increase_score", self.ROCK_POINTS, by_who)
	do_explosion()
