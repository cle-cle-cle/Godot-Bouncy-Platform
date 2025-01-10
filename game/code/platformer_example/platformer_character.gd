extends CharacterBody2D

@export var move_speed: float = 100.0  # Horizontal movement speed
@export var extra_upward_force: float = 50.0  # Extra upward force
@export var push_force: float = 30.0  # Impulse applied to RigidBody2D on collision
@export var gravity: float = 300.0  # Gravity force applied every second

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

	# Move the character and detect collisions
	move_and_slide()

	# Check for collisions and apply impulses to RigidBody2D
	for i in range(get_slide_collision_count()):
		var collision_info = get_slide_collision(i)
		handle_collision(collision_info)

func apply_upward_force() -> void:
	# Apply an upward force by modifying velocity
	velocity.y -= extra_upward_force
	print("Applied extra upward force!")

func handle_collision(collision_info: KinematicCollision2D) -> void:
	var collider = collision_info.get_collider()
	if collider is RigidBody2D:
		# Calculate push direction
		var push_direction = collision_info.get_normal() * -1  # Reverse the normal direction

		# Impact point relative to the collider's position
		var impact_point = collision_info.get_position() - collider.global_position

		# Calculate the impulse vector
		var push_impulse = push_direction * push_force

		# Apply the impulse to the RigidBody2D at the impact point
		collider.apply_central_impulse(push_impulse)

		# Debugging
		print("Applied impulse at point: ", impact_point, " Impulse: ", push_impulse, " to ", collider.name)
