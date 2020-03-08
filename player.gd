extends KinematicBody2D

const MOTION_SPEED = 90.0
const VERTICAL_FRAMES: float = 4.0
const HORIZONTAL_FRAMES: float = 4.0
const MAX_BOMB_TYPE: int = 20
puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()
sync var lifes: int = 4
sync var bomb_type: int  = 1
export var stunned = false
var target_chest: Chest
var game_board: Board
var coordinates_conversor: CoordinatesConversor
# Use sync because it will be called everywhere
sync func setup_bomb(bomb_name, pos, by_who):
	#var bomb = preload("res://bomb.tscn").instance()
	var bomb: Bomb = preload("res://bomb/Bomb.tscn").instance()
	bomb.set_name(bomb_name) # Ensure unique name for the bomb
	bomb.position = pos
	bomb.from_player = by_who
	bomb.add_collision_exception_with(self)
	bomb.game_board = self.game_board
	bomb.board_coordinates = self.coordinates_conversor.get_player_coordinates_on_board(
		self.global_position)
	bomb.TYPE = self.bomb_type
	# No need to set network master to bomb, will be owned by server by default
	get_node("../..").add_child(bomb)

var current_anim = ""
var prev_bombing = false
var bomb_index = 0

func _physics_process(_delta):
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)
		if self.target_chest:
			if self.target_chest.chest_type == "Booster":
				var type = self.bomb_type + self.target_chest.content
				if type < self.MAX_BOMB_TYPE:
					rset("bomb_type", type)
				else:
					rset("bomb_type", self.MAX_BOMB_TYPE)
				self.target_chest.open_chest()
			else:
				rset("lifes", self.lifes + self.target_chest.content)
				get_node("../../score").rpc("increase_life", self.target_chest.content,
				 int(self.name))
				self.target_chest.open_chest()
			self.target_chest = null

		var bombing = Input.is_action_pressed("set_bomb")
		if stunned:
			bombing = false
			motion = Vector2()

		if bombing and not prev_bombing:
			var bomb_name = get_name() + str(bomb_index)
			var bomb_pos = position
			rpc("setup_bomb", bomb_name, bomb_pos, get_tree().get_network_unique_id())

		prev_bombing = bombing

		rset("puppet_motion", motion)
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		motion = puppet_motion

	var new_anim = "standing"
	if motion.y < 0:
		new_anim = "walk_up"
	elif motion.y > 0:
		new_anim = "walk_down"
	elif motion.x < 0:
		new_anim = "walk_left"
	elif motion.x > 0:
		new_anim = "walk_right"

	if stunned:
		new_anim = "stunned"

	if new_anim != current_anim:
		current_anim = new_anim
		get_node("anim").play(current_anim)

	# FIXME: Use move_and_slide
	move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

puppet func stun():
	stunned = true

master func exploded():
	if stunned:
		return
	rpc("stun") # Stun puppets
	stun() # Stun master - could use sync to do both at once
	get_node("../../score").rpc("decrease_life", 1, int(self.name))

func set_player_name(new_name):
	get_node("label").set_text(new_name)

func _ready():
	stunned = false
	puppet_pos = position

func _on_Board_board_created(board: Board) -> void:
	self.game_board = board
	self.coordinates_conversor = CoordinatesConversor.new(
		self.game_board.cell_dim)

func scale_player() -> void:
	var texture_dim: Vector2 = $sprite.texture.get_size()
	texture_dim.x/= self.VERTICAL_FRAMES
	texture_dim.y/= self.HORIZONTAL_FRAMES
	self.scale.x=self.game_board.cell_dim.first_element/texture_dim.x
	self.scale.y=self.game_board.cell_dim.second_element/texture_dim.y

func on_chest(chest: Chest) -> void:
	self.target_chest = chest
