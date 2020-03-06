extends Node2D


const BUTTON_RADIUS: float = 96.0
const JOYSTICK_RADIUS: float = 288.0
var util_f: UtilFunctions = UtilFunctions.new()
var button: TouchScreenButton
var stick: TouchScreenButton

func _ready():
	self.button = $Button
	self.stick = $Stick
 
func _input(event):
	if event is InputEventScreenTouch:
		if self.util_f.is_inside_circle(self.BUTTON_RADIUS, self.global_position,
		event.position):
			self.button.action = "set_bomb"
		else:
			self.button.action = ""
	if event is InputEventScreenDrag:
		if self.util_f.is_inside_circle(self.JOYSTICK_RADIUS, self.global_position,
		event.position):
			var pos: float
			if event.position.x >= self.global_position.x:
				pos = event.position.x - self.global_position.x
			else:
				pos = event.position.x - self.global_position.x
			var motion_x: float = self.joystick_action_conversion(pos)
			print(motion_x)
			self.joystick_movement_cases_x_dir(motion_x)
		else:
			self.stick.action = ""

func joystick_action_conversion(pos_x: float) -> float:
	var motion_x: float = 0.0
	if not util_f.number_in_range(-self.BUTTON_RADIUS, self.BUTTON_RADIUS, pos_x):
		motion_x = 1.0 * sign(pos_x)
	return motion_x

func joystick_movement_cases_x_dir(motion_x: float) -> void:
	if motion_x > 0:
		self.stick.action = "move_right"
	if motion_x < 0:
		self.stick.action = "move_left"
	else:self.stick.action = ""

func joystick_movement_cases_y_dir(motion_y: float) -> void:
	match motion_y:
		1.0:
			self.stick.action = "move_down"
		-1.0:
			self.stick.action = "move_up"
		0.0:
			self.stick.action = ""
