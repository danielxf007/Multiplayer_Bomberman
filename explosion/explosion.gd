extends Sprite

class_name Explosion

func _ready():
	$Timer.start()

func _on_Area2D_body_entered(body):
	if not is_network_master():
		return
	if body.has_method("exploded"):
		body.rpc("exploded")

func _on_Timer_timeout():
	self.queue_free()


func _on_Area2D_area_entered(area):
	if not is_network_master():
		return
	if area.has_method("exploded"):
		area.rpc("exploded")
