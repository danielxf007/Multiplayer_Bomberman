extends Sprite

class_name Cell

var element
var dimensions: Tuple
var container_dimensions: Tuple

func set_element(new_element) -> void:
	if not self.element:
		self.element = new_element

func clear_element() -> void:
	self.element = null

func is_occupied() -> bool:
	return self.element != null
