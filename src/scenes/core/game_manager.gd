extends Node

#region ScenesAndNodes
#var GameMainScene : PackedScene = preload("res://scenes/game/pong.tscn")
var DebugControl : Control :
	set (value):
		DebugControl = value
	get:
		return DebugControl
#endregion

#region GameStates
#var isMultiplayerGame : bool = false
####
#	BITS		12		11		10	9	8	7	6	5	4	3	2	1	0
#	Values		2048	1024	512	256	128	64	32	16	8	4	2	1	0
# 	0b00000001
#####
enum GameStates {
# Allgemeine States
	NOTDEFINED			= 0b00000000000,	# 0
	NOTUSED				= 0b00000000001,	# 1
	ERROR				= 0b00000000010,	# 2
	STARTUP				= 0b00000000011,	# 3
	ACTIVE				= 0b00000000100,	# 4
	QUIT,
# # # # #
# Module
# # # # #
	GAME,
	SZENE,
	SESSION,
	INTERFACE,
	MENU,
# # # # #
# UI's
# # # # #
	MAIN,
	HUD,
	SETTINGS,
	PAUSE,
	SCORE,
# # # # #
#
# # # # #
	INITIALIZING,
	INITIALIZED,
	LOADING,
	LOADED,
	RESETTING,
	RESETED,
	CANCELING,
	CANCELED,
	WAITING,
	PAUSING,
	PAUSED,
	RUNNING,
	ENDED,
# # # # #
#
# # # # #
	GAMEMAINMENU,
	GAMEPAUSEMENU,
	GAMESETTINGSMENU,
	GAMESCOREMENU,
# # # # #
#
# # # # #
	GAME_SESSION_INITIALIZED,
	GAMESESSIONPAUSED,
	GAMESESSIONRUNNING,
	GAMESESSIONWAITFORSTART,
# # # # #
#
# # # # #
	GAMEMAINSZENEREADY,
	GAMEPAUSEMENUACTIVE,
	GAMEMAINSZENEACTIVE,
	GAMESTATERESET,
	GAMEOVER,
# # # # #
#
# # # # #
}

var GameState : GameStates = GameStates.NOTDEFINED :
	set(value):
		GameState = value
		GL_GAMESTATE_CHANGE.emit(GameState)
	get():
		return GameState

## Player lives (3 by default, can be configured)
@export_range(1, 10, 1) var max_lives: int = 3
var lives: int = max_lives :
	set(value):
		lives = clampi(value, 0, max_lives)
		GL_LIVES_CHANGED.emit(lives)
		if lives <= 0:
			_on_game_over()
	get():
		return lives

#endregion

@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

#region ##### Beispiel Setter / Getter
#var sprite_offset : Vector2 = Vector2.ZERO :
#	set (value):
#		sprite_offset = on_sprite_offset_change(value)
#	get:
#		return sprite_offset
#
#func on_sprite_offset_change(value: Vector2) -> Vector2:
#	return Vector2.ZERO
#endregion #####

#region Signals
signal Game_Window_Size_Changed
#signal Game_State_Changed(gs : GameStates)
## Gamestate has just changed
signal GL_GAMESTATE_CHANGE(gs : GameStates)
## Change Gamestate to new state
signal GL_CHANGE_GAMESTATE(gs : GameStates)
## Ball was lost (fell off bottom boundary)
signal GL_BALL_LOST
## Lives count changed
signal GL_LIVES_CHANGED(lives_remaining : int)
## All bricks destroyed - level complete
signal GL_LEVEL_COMPLETE

#signal Register_Game_Logic(instanceid : int)
#signal Register_UI_Manager(instanceid : int)
#signal Register_SCORE_Manager(instanceid : int)
#endregion

#region GAMEMANAGER
#var GameLogic : Node
#var Scr_Manager : ManagerBaseClass
#var UI_Manager : ManagerBaseClass
#endregion

#signal Update_Player_Dict(p1:String, p2:String,score:int,rounds:int)

func _ready() -> void:
	print("Global Autoload => _ready()")
	get_tree().get_root().size_changed.connect(func(): Game_Window_Size_Changed.emit())
	get_tree().get_root().tree_exited.connect(_Game_is_closing)
	GL_GAMESTATE_CHANGE.connect(_Game_State_Has_Changed, CONNECT_DEFERRED)
	GL_CHANGE_GAMESTATE.connect(_Game_State_On_Change_State, CONNECT_DEFERRED)

	#Register_SCORE_Manager.connect(_Register_SCORE_Manager, CONNECT_ONE_SHOT)
	#Register_UI_Manager.connect(_Register_UI_Manager, CONNECT_ONE_SHOT)
	#Register_Game_Logic.connect(_Register_Game_Logic, CONNECT_ONE_SHOT)

	rng.seed = 19771202
	GL_BALL_LOST.connect(_on_ball_lost, CONNECT_DEFERRED)


func _exit_tree() -> void:
	print("Global Autoload => _exit_tree()")


func _Game_is_closing() -> void:
	print("Global Autoload => GameScene::_exiting_tree()")


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			print("Global Autoload => _notification()::NOTIFICATION_ENTER_TREE")
			pass
		NOTIFICATION_EXIT_TREE:
			print("Global Autoload => _notification()::NOTIFICATION_EXIT_TREE")
			pass


func _Game_State_On_Change_State(new_gs : Game.GameStates) -> void:
	if GameState == new_gs: return

	GameState = new_gs
	pass

func _Game_State_Has_Changed(new_gs : Game.GameStates) -> void:
	print("Global Autoload => _Game_State_Has_Changed(GS:%s)" % Game.GameStates.keys()[new_gs])
	
	match new_gs:
		Game.GameStates.LOADING:
			print("Game: Entering LOADING state...")
			# Scene is being loaded, transition to RUNNING after brief delay
			await get_tree().create_timer(0.1).timeout
			GameState = Game.GameStates.RUNNING
		
		Game.GameStates.RUNNING:
			print("Game: Entering RUNNING state - gameplay active")
		
		Game.GameStates.PAUSED:
			print("Game: Entering PAUSED state")
		
		Game.GameStates.GAMEOVER:
			print("Game: Entering GAMEOVER state")
			# Game over screen is handled by game_ui



func _Connect_Signals() -> void:
	pass


func _Register_SCORE_Manager(IID : int) -> void:
	if is_instance_id_valid(IID):
		print("Global => _Register_SCORE_Manager()")
		#Scr_Manager = instance_from_id(IID)
	else:
		#GL_GAMESTATE_CHANGE.emit(GameStates.GAMELOADINGERROR)
		print("Global => ERROR: _Register_SCORE_Manager()")


func _Register_UI_Manager(IID : int) -> void:
	if is_instance_id_valid(IID):
		print("Global => _Register_UI_Manager()")
		#UI_Manager = instance_from_id(IID)
	else:
		#GL_GAMESTATE_CHANGE.emit(GameStates.GAMELOADINGERROR)
		print("Global => ERROR: _Register_UI_Manager()")


func _Register_Game_Logic(IID : int) -> void:
	if is_instance_id_valid(IID):
		print("Global => _Register_Game_Logic()")
		#GameLogic = instance_from_id(IID)
	else:
		#GL_GAMESTATE_CHANGE.emit(GameStates.GAMELOADINGERROR)
		print("Global => ERROR: _Register_Game_Logic()")


func _Game_Max_Score_Reached() -> void:
	#GL_GAMESTATE_CHANGE.emit(GameStates.GAMEMAXSCORE)
	pass


func _Game_Max_Round_Reached() -> void:
	#GL_GAMESTATE_CHANGE.emit(GameStates.GAMEMAXROUND)
	pass


## Initialize game session - reset lives to max
func init_game() -> void:
	lives = max_lives
	print("Game: Lives initialized to %d" % lives)


## Lose one life - called when ball is lost
func lose_life() -> void:
	lives -= 1
	print("Game: Life lost. Remaining lives: %d" % lives)


## Handle ball loss event
func _on_ball_lost() -> void:
	print("Game: Ball lost detected")
	lose_life()


## Handle game over condition
func _on_game_over() -> void:
	print("Game: Game Over - No lives remaining")
	GameState = GameStates.GAMEOVER


########

#func __ready():
	#get_tree().get_root().size_changed.connect(func(): Game_Window_Size_Changed.emit())
	#Game_State_Changed.connect(_Game_State_Changed)
	#
	#Game_Prepare_Next_Round.connect(_Prepare_Next_Round)
	#Game_Max_Round_Reached.connect(_Game_Is_over, CONNECT_DEFERRED)
	#Game_Is_over.connect(_Game_Is_over, CONNECT_DEFERRED)
	#Left_Player_Scored.connect(_Player_has_Scored)
	#Right_Player_Scored.connect(_Player_has_Scored)
	#
	#New_Game_Started.connect(func(): pass)
	#Next_Round_Started.connect(func(): pass)
	#Game_Reseted.connect(func(): pass)
	#Game_Prepare_Round.connect(func(): pass)


#func _Game_Is_over(ply):
	#var roundname = "round_{rnd}".format({"rnd":str(currentround)})
#
	#playerdic[roundname] = {"p1": p1_score, "p2":p2_score, "won": ply}
	#currentround += 1
	#pass
