# Virtual base class for all states.
extends State

var mines = []
var target_mine = null
var mining_range = false
var returning = false
@onready var nav_agent = owner.get_node("NavigationAgent2D")

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	#If the bot is within mining range then start the mining timer
	if mining_range:
		if $MineTimer.is_stopped():
			$MineTimer.start(owner.mining_speed)
	#If the bot has collected its payload then it will return to the player
	elif returning:
		nav_agent.target_position = get_tree().root.get_node("GameManager/Player").global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		var new_velocity: Vector2 = owner.global_position.direction_to(next_path_position)
		owner.velocity = new_velocity * owner.movement_speed
		owner.move_and_slide()
	#Else go to the mine
	else:
		nav_agent.target_position = target_mine.global_position
		var next_path_position: Vector2 = nav_agent.get_next_path_position()
		var new_velocity: Vector2 = owner.global_position.direction_to(next_path_position)
		owner.velocity = new_velocity * owner.movement_speed
		owner.move_and_slide()


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass


func _on_area_2d_body_entered(body):
	#If the detection area detects a mine add it to the list of mines
	if body.name.contains("Mine") and owner.player_controlled:
		mines.append(body)
		$"../BotIdle".mine_present = true
		find_nearest()

func _on_area_2d_body_exited(body):
	if body.name.contains("Mine") and owner.player_controlled:
		mines.erase(body)
	
	if mines.is_empty():
		$"../BotIdle".mine_present = false
		if not returning:
			state_machine.transition_to("BotIdle")

func find_nearest():
	var shortest_distance = INF
	var temp_nearest_mine
	for mine in mines:
		if owner.position.distance_to(mine.position) < shortest_distance:
			shortest_distance = owner.position.distance_to(mine.position)
			temp_nearest_mine = mine
	target_mine = temp_nearest_mine


func _on_mine_timer_timeout():
	if target_mine != null:
		owner.scrap = target_mine.mine_scrap(owner.mining_value)
		returning = true
		mining_range = false


func _on_navigation_agent_2d_target_reached():
	if state_machine.state == self:
		if returning:
			get_tree().root.get_node("GameManager").add_scrap(owner.scrap)
			owner.scrap = 0
			returning = false
			if not mines.is_empty():
				find_nearest()
			else:
				returning = false
				state_machine.transition_to("BotIdle")
		else:
			returning = true
			mining_range = true
