class_name PaddleController extends CharacterBody2D


@export_range(100.0, 1000.0, 10.0) var SPEED = 650.0

@export_color_no_alpha var playercolor
@onready var paddle_collision: CollisionShape2D = $PaddleCollision

@export var paddle_width: float = 100.0

# Für Maussteuerung
@export var use_mouse := true
@export var mouse_sensitivity: float = 1.0

func get_paddle_size() -> Vector2i:
	return paddle_collision.shape.size


func _ready() -> void:
	$Paddle.self_modulate = playercolor


func _physics_process(delta: float) -> void:
	if use_mouse:
		_mouse_move()
	else:
		_move_with_keyboard(delta)
	
	# Bewegung ausführen
	move_and_slide()


func _mouse_move() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var target_x = mouse_pos.x
	
	# Sanfte Bewegung
	position.x = lerp(position.x, target_x, mouse_sensitivity * 0.3)
	
	# Velocity für Physics setzen (wichtig für Kollisionen)
	velocity.x = (target_x - position.x) * 10


func _move_with_keyboard(delta: float) -> void:
	var direction := 0.0
	
	direction = Input.get_axis("p1_left", "p1_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 5)
	
	velocity = direction * SPEED * delta


func _reset_position() -> void:
	# Paddle Positionen
	position.x = get_viewport_rect().size.x / 2
	$Paddle.self_modulate = playercolor


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Ball":  # Passe den Namen an deinen Ball an
		# Berechne relativen Treffpunkt (-1 bis 1)
		var hit_pos = (body.global_position.x - global_position.x) / get_paddle_size().x / 2

		# Ändere Ball-Richtung basierend auf Treffpunkt
		var bounce_angle = hit_pos * 60  # Max 60 Grad Ablenkung
		var new_direction = Vector2(sin(deg_to_rad(bounce_angle)), -1).normalized()

		body.linear_velocity = new_direction * body.linear_velocity.length()
