extends Node2D

@export var scrap : int = 10
@export var bot_list = {
	"1": {"name": "basic_bot", "cost": 1, "path": "res://Scenes/basic_bot.tscn"}
}

@onready var player_bot_manager_node = get_node("PlayerBotManager")
@onready var player_node = get_node("Player")

#var inputs = ["1", "2", "3", "4", "5"]
var inputs = ["1"]

func _input(event):
	for i in bot_list:
		if event.is_action_pressed(i):
			buy(i)

func buy(bot_number):
	if bot_list[bot_number]["cost"] < scrap:
		scrap -= bot_list[bot_number]["cost"]
		var instance = load(bot_list[bot_number]["path"]).instantiate()
		player_bot_manager_node.add_child(instance)
		instance.global_position = player_node.global_position
		player_bot_manager_node.refresh()
