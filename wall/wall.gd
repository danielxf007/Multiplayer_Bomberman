extends StaticBody2D
class_name Wall
var dimensions: Tuple

func scale_wall() -> void:
	var texture_dim: Vector2 = $Sprite.texture.get_size()
	self.scale.x=self.dimensions.first_element/texture_dim.x
	self.scale.y=self.dimensions.second_element/texture_dim.y
