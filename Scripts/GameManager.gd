extends Node

@export var scrap : int = 10
@export var bot_list = {
	"1": {"name": "basic_bot", "cost": 1, "path": "res://Scenes/basic_bot.tscn"}
}

var quests = {
	"mines": 4,
	"enemy":20,
	"scrap":200
}

@onready var player_bot_manager_node = get_node("PlayerBotManager")
@onready var player_node = get_node("Player")
@onready var user_interface = get_node("UserInterface")

#var inputs = ["1", "2", "3", "4", "5"]
var inputs = ["1"]

func _ready():
	user_interface.update_scrap(scrap)
	user_interface.update_quests(quests)

func _input(event):
	for i in bot_list:
		if event.is_action_pressed(i):
			buy(i)

func buy(bot_number):
	if bot_list[bot_number]["cost"] < scrap:
		remove_scrap(bot_list[bot_number]["cost"])
		var instance = load(bot_list[bot_number]["path"]).instantiate()
		player_bot_manager_node.add_child(instance)
		instance.global_position = player_node.global_position
		player_bot_manager_node.refresh()

func add_scrap(mined_scrap):
	scrap += mined_scrap
	user_interface.update_scrap(scrap)

func remove_scrap(scrap_cost):
	scrap -= scrap_cost
	user_interface.update_scrap(scrap)

func update_objectives(objective_string, number):
	if quests.has(objective_string):
		quests[objective_string] -= number
		if quests[objective_string] <= 0:
			quests.erase(objective_string)
		user_interface.update_quests(quests)
