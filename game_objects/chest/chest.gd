extends Sprite
class_name Chest

puppet var content
var dimensions: Tuple
var chest_type: String
puppet var targeted: bool = false

func set_content(new_content) -> void:
	self.content = new_content

master func open_chest():
	if self.is_network_master():
		rset("content", null)
	else:
		self.content = null
	rpc("content_taken")

sync func content_taken():
	$AnimationPlayer.play("chest_content_taken")
	$Timer.start()

func _on_Area2D_body_entered(body):
	if body.has_method("on_chest") and not self.targeted:
		body.on_chest(self)
		self.targeted = true


func _on_Timer_timeout():
	self.queue_free()

func has_content() -> bool:
	return self.content != null
