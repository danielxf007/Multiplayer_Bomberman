extends HBoxContainer

var player_labels = {}

func _process(_delta):
	var players_left = self.get_alive_players()
	var enemies_left = get_node("../enemies").get_child_count()
	if players_left.size() == 1 and enemies_left == 0:
		var winner_name = ""
		winner_name = player_labels[players_left[0]].name
		get_node("../winner").set_text("THE WINNER IS:\n" + winner_name)
		get_node("../winner").show()
	if players_left.size() == 0 and enemies_left > 0:
		get_node("../winner").set_text("THE WINNER IS:\n" + "MACHINE")
		get_node("../winner").show()
	if players_left.size() == 0 and enemies_left == 0:
		get_node("../winner").set_text("THE WINNER IS:\n" + "DRAW")
		get_node("../winner").show()

sync func increase_life(amount, to_who):
	assert(to_who in player_labels)
	var pl = player_labels[to_who]
	pl.lifes += amount
	pl.label.set_text(pl.name + "\n" + "Lifes: " + str(pl.lifes))

sync func decrease_life(amount, to_who):
	assert(to_who in player_labels)
	var pl = player_labels[to_who]
	pl.lifes -= amount
	pl.label.set_text(pl.name + "\n" + "Lifes: " + str(pl.lifes))

func add_player(id, new_player_name):
	var l = Label.new()
	l.set_align(Label.ALIGN_CENTER)
	l.set_text(new_player_name + "\n" + "Lifes: "+ "3")
	l.set_h_size_flags(SIZE_EXPAND_FILL)
	var font = DynamicFont.new()
	font.set_size(18)
	font.set_font_data(preload("res://montserrat.otf"))
	l.add_font_override("font", font)
	add_child(l)

	player_labels[id] = { name = new_player_name, label = l, lifes = 3 ,
	alive = true}

sync func player_die(who):
	assert(who in player_labels)
	var pl = player_labels[who]
	pl.alive = false

func get_alive_players() -> Array:
	var alive_players: Array = []
	for p in player_labels:
		if player_labels[p].alive == true:
			alive_players.append(p)
	return alive_players

func _ready():
	get_node("../winner").hide()
	set_process(true)

func _on_exit_game_pressed():
	gamestate.end_game()
