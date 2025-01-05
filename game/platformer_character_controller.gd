extends CharacterBody2D

@export var move_speed: float = 200.0  # Horizontal movement speed
@export var extra_upward_force: float = 500.0  # Extra upward force
@export var gravity: float = 500.0  # Gravity force applied every second

var previous_y_velocity: float = 0.0  # To track the y-direction

func _physics_process(delta: float) -> void:
	# Apply gravity to the vertical velocity
	velocity.y += gravity * delta

	# Horizontal movement
	var input_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_direction * move_speed

	# Detect upward switch (when switching from falling to moving upward)
	if previous_y_velocity > 0 and velocity.y < 0:
		print("Direction switched to upward, applying extra force!")
		apply_upward_force()

	# Update previous velocity for the next frame
	previous_y_velocity = velocity.y

	# Move the character
	move_and_slide()

func apply_upward_force() -> void:
	# Apply an upward force by modifying velocity
	velocity.y -= extra_upward_force
	print("Applied extra upward force!")
