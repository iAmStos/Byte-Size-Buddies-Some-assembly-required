# Virtual base class for all states.
extends State

var target_position = Vector2.ZERO
@onready var nav_agent = owner.get_node("NavigationAgent2D")
var next_path_position: Vector2 = Vector2.ZERO

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if owner.player_controlled:
		if _event is InputEventMouseButton and _event.is_action_pressed("click"):
			if  state_machine.state != $"../MelleAttack":
				state_machine.transition_to("BotMove")

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	next_path_position = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = owner.global_position.direction_to(next_path_position)
	owner.velocity = new_velocity * owner.movement_speed
	owner.move_and_slide()

#When it enters BotMove start a 0.2 secound timer
func enter(_msg := {}) -> void:
	$Timer.start()

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

#Wait 0.05 secounds for the controller to update before getting new target position
func _on_timer_timeout():
	retarget()
	
func retarget():
	#get target position for Nav Mesh Agent
	target_position = owner.get_node(owner.controller).get_node("NavigationAgent2D").target_position
	# Add a random radius around the target position so it does not land too close to the controller
	var random_radius = randi_range(100, 150)
	target_position += Vector2(randi_range(1,-1), randi_range(1,-1)) * random_radius
	nav_agent.target_position = target_position
	next_path_position = nav_agent.get_next_path_position()


func _on_navigation_agent_2d_target_reached():
	if state_machine.state == self:
		state_machine.transition_to("BotIdle")
