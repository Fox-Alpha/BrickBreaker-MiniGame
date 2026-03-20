extends RigidBody2D

const SPEED: float = 100.0
var _speed: float = 0.0
var ballspeed: Vector2 = Vector2.ZERO
var _init_force: float = 2050.0

var dbg: Control = null


func _ready() -> void:
	randomize()
	_speed = SPEED
	apply_central_impulse(Vector2(0, -1200))


func reset() -> void:
	position = get_viewport_rect().get_center()
	randomize()
	_speed = SPEED


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass
