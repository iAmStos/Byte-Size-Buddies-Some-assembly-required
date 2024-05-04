# Virtual base class for all states.
extends State

var target_position = Vector2.ZERO
@onready var nav_agent = owner.get_node("NavigationAgent2D")

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("click"):
		state_machine.transition_to("BotMove")

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
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

#Wait 0.2 secounds for the controller to update before getting new target position
func _on_timer_timeout():
	retarget()
	
func retarget():
	#get target position for Nav Mesh Agent
	target_position = owner.get_node(owner.controller).get_node("NavigationAgent2D").target_position
	# Add a random radius around the target position so it does not land too close to the controller
	var random_radius = randi_range(50, 100)
	target_position += Vector2(randi_range(1,-1), randi_range(1,-1)) * random_radius
	nav_agent.target_position = target_position
