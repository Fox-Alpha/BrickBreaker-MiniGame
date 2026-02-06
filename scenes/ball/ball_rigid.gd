extends RigidBody2D

@export var initial_speed: float = 500.0
@export var max_speed: float = 850.0
@export var speed_increase: float = 1.07  # 5% Geschwindigkeitserhöhung pro Treffer

var min_angle: float = 0.2  # Verhindert zu flache Winkel

func _ready():
	# Startgeschwindigkeit setzen
	var start_direction = Vector2(randf_range(-0.5, 0.5), -1.0).normalized()
	linear_velocity = start_direction * initial_speed

func _integrate_forces(state: PhysicsDirectBodyState2D):
	var velocity = state.linear_velocity
	var speed = velocity.length()

	# Geschwindigkeit begrenzen
	if speed > max_speed:
		velocity = velocity.normalized() * max_speed
		state.linear_velocity = velocity
	elif speed < initial_speed * 0.8:  # Minimale Geschwindigkeit
		velocity = velocity.normalized() * initial_speed
		state.linear_velocity = velocity

	# Zu flache Winkel korrigieren (verhindert horizontales/vertikales Застревание)
	var normalized_vel = velocity.normalized()

	# Horizontale Bewegung korrigieren
	if abs(normalized_vel.y) < min_angle:
		var sign_y = sign(normalized_vel.y) if normalized_vel.y != 0 else -1
		normalized_vel.y = min_angle * sign_y
		normalized_vel = normalized_vel.normalized()
		state.linear_velocity = normalized_vel * speed

	# Vertikale Bewegung korrigieren
	if abs(normalized_vel.x) < min_angle:
		var sign_x = sign(normalized_vel.x) if normalized_vel.x != 0 else 1
		normalized_vel.x = min_angle * sign_x
		normalized_vel = normalized_vel.normalized()
		state.linear_velocity = normalized_vel * speed

func _on_body_entered(body):
	# Geschwindigkeit bei Kollision erhöhen
	linear_velocity = linear_velocity.normalized() * (linear_velocity.length() * speed_increase)
