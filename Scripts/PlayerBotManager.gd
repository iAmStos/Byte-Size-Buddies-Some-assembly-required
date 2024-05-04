extends Node2D

var player_bots = []
@export var player_node : NodePath = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#called on first frame and when a bot dies.
func refresh():
	player_bots = get_children()
	for bot in player_bots:
		bot.controller = "../../Player"
