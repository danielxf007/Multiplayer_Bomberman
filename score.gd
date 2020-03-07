extends HBoxContainer

var player_labels = {}

func _process(_delta):
	var rocks_left = get_node("../rocks").get_child_count()
	if false and rocks_left == 0:
		var winner_name = ""
		var winner_score = 0
		for p in player_labels:
			if player_labels[p].score > winner_score:
				winner_score = player_labels[p].score
				winner_name = player_labels[p].name
		if winner_score == 0:
			get_node("../winner").set_text("DRAW")
			get_node("../winner").show()
		get_node("../winner").set_text("THE WINNER IS:\n" + winner_name)
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

	player_labels[id] = { name = new_player_name, label = l, lifes = 3 }

func _ready():
	get_node("../winner").hide()
	set_process(true)

func _on_exit_game_pressed():
	gamestate.end_game()
