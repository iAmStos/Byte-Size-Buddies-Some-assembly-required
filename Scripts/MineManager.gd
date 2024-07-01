extends StaticBody2D

@onready var navmesh_agent = $NavigationAgent2D
@export var scrap_resources = 10

@export var basic_bot_scene : PackedScene

signal mine_depleted()

func _ready():
	navmesh_agent.target_position = self.global_position
	var game_manager = get_tree().root.get_child(0)
	var _error = mine_depleted.connect(game_manager.update_objectives)
	
func mine_scrap(mining_value):
	if scrap_resources >= mining_value:
		scrap_resources -= mining_value
		if scrap_resources <= 0:
			$DeathTimer.start()
		return mining_value
	else:
		var leftover = scrap_resources
		scrap_resources = 0
		$DeathTimer.start()
		return leftover

func _on_death_timer_timeout():
	emit_signal("mine_depleted", "mines", 1)
	call_deferred("queue_free")


func _on_spawn_bot_timer_timeout():
	var new_bot = basic_bot_scene.instantiate()
	$BotManager.add_child(new_bot)
	$BotManager.refresh()
