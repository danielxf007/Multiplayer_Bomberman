extends StaticBody2D

class_name Obstacle

var cell: Cell

func destroy() -> void:
	if cell:
		cell.clear_element()
	self.queue_free()
