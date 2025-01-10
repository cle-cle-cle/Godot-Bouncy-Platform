extends RigidBody2D

@export var move_speed: float = 200.0  # Horizontal movement speed
@export var extra_upward_force: float = 500.0  # Extra upward force

var previous_y_velocity: float = 0.0  # To track the y-direction

func _integrate_forces(state):  # No explicit type needed
	# Horizontal movement
	var input_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	state.linear_velocity.x = input_direction * move_speed

	# Get current vertical velocity
	var current_y_velocity = state.linear_velocity.y

	# Detect upward switch (when switching from falling to moving upward)
	if previous_y_velocity > 0 and current_y_velocity < 0:
		print("Direction switched to upward, applying extra force!")
		apply_upward_force(state)

	# Update previous velocity for the next frame
	previous_y_velocity = current_y_velocity

func apply_upward_force(state):  # No explicit type needed
	# Apply an upward impulse
	state.apply_central_impulse(Vector2(0, -extra_upward_force))
	print("Applied extra upward force!")
