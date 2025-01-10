extends RigidBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var move_speed: float = 200.0
@export var push_force: float = 50.0          # Force applied to the other body
@export var player_push_force: float = 3000.0  # Force applied to this player
@export var modulate_duration: float = 0.2     # How long to stay red

# Keeps track of which bodies we've already pushed
var pushed_bodies := {}

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 10

func _process(delta: float) -> void:
	# Basic top-down movement
	var dir_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var dir_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	linear_velocity = Vector2(dir_x, dir_y) * move_speed

func _on_body_entered(body: Node) -> void:
	# Only push the other body & player once per collision event
	if body is RigidBody2D and not pushed_bodies.has(body):
		pushed_bodies[body] = true

		# 1) Calculate direction from this player to the other body
		var direction: Vector2 = (body.global_position - global_position).normalized()
		
		# 2) Clamp direction to one of the 4 cardinal directions
		direction = clamp_to_cardinal(direction)

		# 3) Push the other body away in that cardinal direction
		body.apply_central_impulse(direction * push_force)

		# 4) Push this player away in the opposite direction
		apply_central_impulse(-direction * player_push_force)

		# 5) Modulate the sprite red and schedule a reset
		animate_modulate_red()

		print(
			"Pushed body:", body.name, 
			"with push_force:", push_force,
			"and pushed player away with player_push_force:", player_push_force
		)

func _on_body_exited(body: Node) -> void:
	if pushed_bodies.has(body):
		pushed_bodies.erase(body)
		print("Body exited:", body.name)

func clamp_to_cardinal(direction: Vector2) -> Vector2:
	# Compare absolute X and Y to decide which axis is dominant
	if abs(direction.x) > abs(direction.y):
		# Horizontal axis is dominant
		return Vector2(sign(direction.x), 0)
	else:
		# Vertical axis is dominant
		return Vector2(0, sign(direction.y))

func animate_modulate_red() -> void:
	# Modulate the sprite to red
	animated_sprite_2d.modulate = Color(1, 0, 0)  # Fully red

	# Reset to original color after a short delay using `await`
	await get_tree().create_timer(modulate_duration).timeout
	animated_sprite_2d.modulate = Color(1, 1, 1)  # Original color (white)
