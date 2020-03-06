extends KinematicBody2D

const ROCK_POINTS: int = 1
var cell: Cell
var dimensions: Tuple
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

func scale_rock() -> void:
	var texture_dim: Vector2 = $sprite.texture.get_size()
	self.scale.x=self.dimensions.first_element/texture_dim.x
	self.scale.y=self.dimensions.second_element/texture_dim.y
