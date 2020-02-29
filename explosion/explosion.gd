extends Sprite

class_name Explosion

var targets: Array
var from_player
func _ready():
	$Timer.start()

func _on_Area2D_body_entered(body):
	if body.has_method("exploded"):
		self.targets.append(body)

func _on_Area2D_area_entered(area):
	if area.has_method("explode"):
		area.destroy()


func _on_Timer_timeout():
	for p in self.targets:
		p.rpc("exploded", from_player)
	self.queue_free()
