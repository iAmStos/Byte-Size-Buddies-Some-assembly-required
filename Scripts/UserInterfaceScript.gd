extends CanvasLayer

@onready var scarp_number = $VBoxContainer/Scrap/ScrapNumber
@onready var quests = $VBoxContainer/Quests

@export var quest_info_scene : PackedScene

func update_scrap(scrap):
	scarp_number.text = str(scrap)

func update_quests(quest_dictionary):
	if quests.get_children() != null:
		for quest in quests.get_children():
			quest.queue_free()
	for each in quest_dictionary:
		var new_quest_node = quest_info_scene.instantiate()
		new_quest_node.get_child(0).text = each
		new_quest_node.get_child(1).text = str(quest_dictionary[each])
		quests.add_child(new_quest_node)
