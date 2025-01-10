extends RigidBody2D

@export var move_speed: float = 200.0
@export var extra_bounce_force: float = 500.0

var previous_y_velocity: float = 0.0

func _ready() -> void:
	# Disable gravity for a top-down style
	gravity_scale = 0.0
	can_sleep = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# 1) Gather input for X and Y movement
	var input_direction_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_direction_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# 2) Assign velocity
	state.linear_velocity.x = input_direction_x * move_speed
	state.linear_velocity.y = input_direction_y * move_speed

	# 3) Check if we're switching from moving downward (y > 0) to upward (y < 0)
	var current_y_velocity = state.linear_velocity.y
	if previous_y_velocity > 0 and current_y_velocity < 0:
		print("Direction switched to upward, applying extra force!")
		apply_extra_bounce(state)

	# 4) Update previous velocity for the next frame
	previous_y_velocity = current_y_velocity

func apply_extra_bounce(state: PhysicsDirectBodyState2D) -> void:
	# Apply a quick impulse upward (negative Y) for a bounce-like effect
	state.apply_central_impulse(Vector2(0, -extra_bounce_force))
	print("Applied extra bounce force!")
