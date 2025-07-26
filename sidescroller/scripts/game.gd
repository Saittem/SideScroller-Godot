extends Node2D

const PLAYER_START_POS := Vector2i(80, 320)
const CAM_START_POS := Vector2i(310, 180)
const START_SPEED : float = 2.0
const MAX_SPEED : float = 15.0
const SCORE_MODIFIER : int = 10
const SPEED_MODIFIER : int = 4000

var score : int
var speed : float
var screen_size : Vector2i
var game_running : bool

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	speed = 0
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Ground.position = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$HUD.get_node("PlayPrompt").show()

func _process(delta: float):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		score += speed
		show_score()
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		if Input.is_key_pressed(KEY_W):
			game_running = true
			$HUD.get_node("PlayPrompt").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)
