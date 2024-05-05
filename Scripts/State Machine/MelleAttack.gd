#Controls the bot when it engages in combat
extends State

var enemy_bots = []
var target
var melle_range = false

var target_position = Vector2.ZERO
@onready var nav_agent = owner.get_node("NavigationAgent2D")

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	if melle_range:
		if $MelleTimer.is_stopped():
			$MelleTimer.start(owner.attack_speed)
	else:
		nav_agent.target_position = target.global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		var new_velocity: Vector2 = owner.global_position.direction_to(next_path_position)
		owner.velocity = new_velocity * owner.movement_speed
		owner.move_and_slide()
	



# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	find_nearest()
	nav_agent.target_position = target.global_position


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass


func _on_area_2d_body_entered(body):
	if not body.name.contains("Mine"):
		if body.controller != owner.controller:
			enemy_bots.append(body)
			state_machine.transition_to("MelleAttack")

func _on_area_2d_body_exited(body):
	if body in enemy_bots:
		enemy_bots.erase(body)
	
	if enemy_bots.is_empty():
		state_machine.transition_to("BotMove")
	elif owner.health > 0:
		find_nearest()

func find_nearest():
	if enemy_bots.is_empty():
		pass
	var shortest_distance = INF
	var temp_nearest_bot
	for bot in enemy_bots:
		if bot.health <= 0 or owner.health <= 0:
			pass
		if owner.position.distance_to(bot.position) < shortest_distance:
			shortest_distance = owner.position.distance_to(bot.position)
			temp_nearest_bot = bot
	target = temp_nearest_bot


func _on_navigation_agent_2d_target_reached():
	melle_range = true


func _on_navigation_agent_2d_path_changed():
	melle_range = false


func _on_melle_timer_timeout():
	if target != null:
		target.take_damage(owner.melle_damage)
		if not enemy_bots.is_empty():
			find_nearest()
