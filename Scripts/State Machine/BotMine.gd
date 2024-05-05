# Virtual base class for all states.
extends State

var mines = []
var target_mine = null

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass


# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass


# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	pass


# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass


func _on_area_2d_body_entered(body):
	if body.name.contains("Mine") and owner.player_controlled:
		mines.append(body)

func _on_area_2d_body_exited(body):
	if body.name.contains("Mine") and owner.player_controlled:
		mines.erase(body)
