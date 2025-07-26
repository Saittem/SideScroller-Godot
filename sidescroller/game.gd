extends Node2D

const PLAYER_START_POS := Vector2i(80, 320)
const CAM_START_POS := Vector2i(310, 180)

var speed : float
const START_SPEED : float = 2.0
const MAX_SPEED : float = 15.0
var screen_size : Vector2i

func _ready():
	screen_size = get_window().size
	new_game()

func new_game():
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Ground.position = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS

func _process(delta: float):
	speed = START_SPEED
	
	$Player.position.x += speed
	$Camera2D.position.x += speed
	
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x
