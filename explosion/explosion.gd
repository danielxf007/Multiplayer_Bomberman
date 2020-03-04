extends Sprite

class_name Explosion

var from_player
func _ready():
	$Timer.start()

func _on_Area2D_body_entered(body):
	if not is_network_master():
		return
	if body.has_method("exploded"):
		body.rpc("exploded", from_player)

func _on_Timer_timeout():
	self.queue_free()
