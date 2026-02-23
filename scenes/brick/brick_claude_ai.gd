class_name Brick extends StaticBody2D

signal brick_destroyed(brick, points)

@export var hit_points: int = 1  # Anzahl Treffer bis Zerstörung
@export var points: int = 10  # Punkte beim Zerstören
@export var brick_color: Color = Color.RED

@export var brick_type: Brick_Base

# Visuelle Feedback-Farben für verschiedene Lebenspunkte
@export var colors_by_health: Array[Color] = [
	Color.DARK_RED,     # 1 HP
	Color.ORANGE,       # 2 HP
	Color.YELLOW,       # 3 HP
	Color.GREEN,        # 4 HP
	Color.NAVY_BLUE     # 4+ HP
]

var current_hit_points: int

func _ready():
	current_hit_points = hit_points
	#_update_visual()

	# PhysicsMaterial für perfekte Reflexion
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = 1.0
	physics_material.friction = 0.0
	physics_material_override = physics_material
	
	brick_destroyed.connect(_destroy, ConnectFlags.CONNECT_DEFERRED)


func _on_tree_entered() -> void:
	name = "Brick_" +str(get_instance_id())
	add_to_group("Brick", true)
	pass # Replace with function body.


func _on_brick_area_body_entered(body: Node2D) -> void:
	if body.name == "Ball" or body.is_in_group("ball"):
		_take_damage()


func _take_damage():
	current_hit_points -= 1

	if current_hit_points <= 0:
		brick_destroyed.emit(self, points)
		#_destroy()
	else:
		#_update_visual()
		await _play_hit_effect()


func _destroy(_node : Node2D, _points : int):
	print("Brick %s / points %s" % [name, points])
	await _play_destroy_effect()
	queue_free()


func _update_visual():
	var sprite = $Sprite2D if has_node("Sprite2D") else null
	var color_rect = $ColorRect if has_node("ColorRect") else null

	var color = _get_color_for_health()

	if sprite:
		sprite.self_modulate = color
	elif color_rect:
		color_rect.color = color


func _get_color_for_health() -> Color:
	if current_hit_points <= 0:
		return Color.BLACK
	elif current_hit_points <= colors_by_health.size():
		return colors_by_health[current_hit_points - 1]
	else:
		return colors_by_health[-1]  # Letzte Farbe für hohe HP


func _play_hit_effect():
	# Kurzes Blinken
	var tween = create_tween()
	tween.tween_property(self, "self_modulate", Color.WHITE, 0.6)
	tween.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.6)
	await tween.finished
	pass
	#return true


func _play_destroy_effect():
	# Partikeleffekt oder Animation beim Zerstören
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.25,1.5), 0.5).from_current()
	tween.tween_property(self, "scale", Vector2.ZERO, 1.5).from_current()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	pass
	#return true


func _on_tweening() -> void :
	print("OnTweening()")
