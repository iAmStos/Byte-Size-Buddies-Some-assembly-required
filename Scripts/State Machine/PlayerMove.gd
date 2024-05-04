# Virtual base class for all states.
extends State

var target_position = Vector2.ZERO
@onready var nav_agent = owner.get_node("NavigationAgent2D")

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("click"):
		state_machine.transition_to("PlayerMove")
		target_position = owner.get_global_mouse_position()
		nav_agent.target_position = target_position


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = owner.global_position.direction_to(next_path_position)
	owner.velocity = new_velocity * owner.movement_speed
	owner.move_and_slide()

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	target_position = owner.get_global_mouse_position()
	nav_agent.target_position = target_position


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass
