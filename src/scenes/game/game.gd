extends Node2D

## signals:
# Brick To Map
# -> GM: Increment Brickcount
# Brick hit by ball
# -> GM: Update Score Counter / (Highscore)
# -> Map: Check Brick Count for == 0
# -> UI: Update Score Label
# Ball hit bottom void
# -> GM: Update Lives
# --> UI: Update Lives
# --> GameState: GameOver if no more lives
# No More Bricks in Map
# -> GM: Update GameState >> Level Won
# -> UI: Show Win Dialog / Next Level

const BALL_BODY = preload("uid://bx7lmlxv60bk7")
const PADDLE = preload("uid://xxrnnvqgevnr")

signal NoMoreBrickInMap
signal Ball_Respawned

#region Global_Signals
@warning_ignore_start("unused_signal")
signal Reset_Game
signal Player_Score
signal GS_GAME_PAUSED
signal GS_GAME_UNPAUSED
#signal GL_GAMESTATE_CHANGE
@warning_ignore_restore("unused_signal")
#endregion

#@export var paddle : PaddleController
@export var brickmap : TileMapLayer
@export var cam : Camera2D
@export var canvas_layer: CanvasLayer

@onready var vps := get_viewport_rect()
@onready var center_marker: Marker2D = $CenterMarker
@onready var respawn_timer: Timer #= $RespawnTimer

var ball : Node
var paddle_instance : Node


var worldsize : Vector2i = Vector2i(800,800)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Game
	NoMoreBrickInMap.connect(_on_no_more_bricks)
	cam.position = get_viewport_rect().get_center()
	center_marker.position = get_viewport_rect().get_center()
	GS_GAME_UNPAUSED.connect(startgame)
	Game.GL_BALL_LOST.connect(_on_ball_lost)
	Game.GL_GAMESTATE_CHANGE.connect(_on_game_state_changed, CONNECT_DEFERRED)

	# Setup respawn timer
	if not respawn_timer:
		respawn_timer = Timer.new()
		respawn_timer.name = "RespawnTimer"
		respawn_timer.one_shot = true
		respawn_timer.wait_time = 1.5
		respawn_timer.timeout.connect(_respawn_ball)
		add_child(respawn_timer)

	# If already in RUNNING state (e.g. scene reloaded), start immediately
	if Game.GameState == Game.GameStates.RUNNING:
		startgame()


## React to game state changes
func _on_game_state_changed(new_state: Game.GameStates) -> void:
	match new_state:
		Game.GameStates.RUNNING:
			# Only start if not already started (no ball/paddle yet)
			if not paddle_instance or not is_instance_valid(paddle_instance):
				startgame()
		Game.GameStates.GAMEOVER:
			print("Game: Game over state received")


## Handle level complete when all bricks are destroyed
func _on_no_more_bricks() -> void:
	print("Game: All bricks destroyed - Level Complete!")
	Game.GL_LEVEL_COMPLETE.emit()
	# Stop ball
	if ball and is_instance_valid(ball):
		ball.linear_velocity = Vector2.ZERO
		ball.freeze = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


## Handle input events for pause toggle
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause()


## Toggle pause state
func _toggle_pause() -> void:
	if Game.GameState == Game.GameStates.RUNNING:
		Game.GameState = Game.GameStates.PAUSED
	elif Game.GameState == Game.GameStates.PAUSED:
		Game.GameState = Game.GameStates.RUNNING


func startgame() -> void:
	# Initialize game state
	Game.init_game()

	var pad : PaddleController = PADDLE.instantiate()
	spawn_ball()
	canvas_layer.ball = ball
	add_child(pad)
	paddle_instance = pad
	var p:= Vector2(vps.get_center().x, vps.end.y -pad.get_paddle_size().y *2)
	pad.position = p


## Spawn ball at paddle position
func spawn_ball() -> void:
	ball = BALL_BODY.instantiate()

	# Position ball above paddle if it exists, else at bottom center
	if paddle_instance and is_instance_valid(paddle_instance):
		ball.global_position = paddle_instance.global_position + Vector2(0, -20)
	else:
		ball.global_position = Vector2(vps.get_center().x, vps.end.y - 164)

	add_child(ball)
	print("Game: Ball spawned at position %s" % ball.global_position)


## Handle ball loss - remove old ball and start respawn timer
func _on_ball_lost() -> void:
	print("Game: Ball lost, starting respawn countdown...")

	# Remove old ball
	if ball and is_instance_valid(ball):
		ball.queue_free()
		ball = null

	# Only respawn if player has lives remaining (not game over)
	if Game.lives > 0:
		respawn_timer.start()


## Respawn ball after delay
func _respawn_ball() -> void:
	print("Game: Respawning ball...")
	spawn_ball()
	Ball_Respawned.emit()
