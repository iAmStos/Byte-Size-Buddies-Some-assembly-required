extends Node2D

var mine_bots = []


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#called on first frame and when a bot dies.
func refresh():
	mine_bots = get_children()
	for bot in mine_bots:
		bot.controller = "../.."
		if bot.player_controlled == false:
			bot.update_sprite(false)
