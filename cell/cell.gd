extends Sprite

class_name Cell

var element
var cell_size: Vector2
var dimensions: Tuple

func set_element(new_element) -> void:
	if not self.element:
		self.element = new_element

func clear_element() -> void:
	self.element = null

func is_occupied() -> bool:
	return self.element != null

func scale_cell() -> void:
	pass
	#var texture_dim: Vector2 = self.texture.get_size()
	#self.scale.x=self.dimensions.first_element/texture_dim.x
	#self.scale.y=self.dimensions.second_element/texture_dim.y
