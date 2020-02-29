extends Sprite
class_name Chest

var content
var chest_name: String
func set_content(new_content) -> void:
	self.content = new_content

func open_chest():
	return self.content

func content_taken():
	self.content = null
	$AnimationPlayer.play("chest_content_taken")
	$Timer.start()

func _on_Area2D_body_entered(body):
	if body.has_method("on_chest"):
		body.on_chest(self)


func _on_Timer_timeout():
	self.queue_free()


func _on_Area2D_body_exited(body):
	if body.has_method("out_of_chest"):
		body.out_of_chest()

func has_content() -> bool:
	return self.content != null
