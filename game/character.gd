extends CharacterBody2D

@export var move_speed: float = 400.0
@export var push_force: float = 10000.0  # Force to push the rigid body

func _physics_process(delta: float) -> void:
	# Movement logic
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	# Move the character and handle collision
	var collision = move_and_collide(input_vector * move_speed * delta)
	if collision:
		push_rigid_body(collision)

func push_rigid_body(collision: KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	if collider is RigidBody2D:
		# Calculate the push direction
		var push_direction = collision.get_normal() * -1  # Reverse normal to push away

		# Apply impulse at the collision point
		var collision_point = collision.get_position() - collider.global_position
		collider.apply_impulse(collision_point, push_direction * push_force)
		print(collider)
