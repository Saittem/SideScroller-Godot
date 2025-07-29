extends Node2D

const PLAYER_START_POS := Vector2i(80, 320)
const CAM_START_POS := Vector2i(310, 180)
const START_SPEED : float = 2.0
const MAX_SPEED : float = 15.0
const SCORE_MODIFIER : int = 10
const SPEED_MODIFIER : int = 8000
const MAX_DIFFICULTY : int = 2

var stump_scene = preload("res://scenes/stomp.tscn")
var crate_scene = preload("res://scenes/crate.tscn")
var barrel_scene = preload("res://scenes/barrel.tscn")
var bird_scene = preload("res://scenes/bird.tscn")
var obstacle_types := [stump_scene, crate_scene, barrel_scene]
var obstacles : Array
var bird_heights := [270, 240]
var last_obs

var score : float
var speed : float
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var difficulty : int

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	difficulty = 0

func new_game():
	speed = 0
	$Player.position = PLAYER_START_POS
	$Player.velocity = Vector2i(0, 0)
	$Ground.position = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$HUD.get_node("PlayPrompt").show()

func _process(_delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		score += speed
		
		adjust_difficulty()
		show_score()
		generate_obstacles()
		
		for obs in obstacles:
			if obs.position.x <($Camera2D.postion.x - screen_size.x):
				remove_obs(obs)
		
		$Player.position.x += speed
		$Camera2D.position.x += speed
		
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x
	else:
		if Input.is_key_pressed(KEY_W):
			game_running = true
			$HUD.get_node("PlayPrompt").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(int(score / SCORE_MODIFIER))

func remove_obs(obs):
	obs.remove_free()
	obstacles.erase(obs)

func generate_obstacles():
	if obstacles.is_empty() or (last_obs.position.x + 200) < score + randi_range(300,500):
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs 
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x : int = screen_size.x + score + 100 + (i * 10)
			var obs_y : int = screen_size.y - ground_height - (obs_height * obs_scale.y / 4) + 10
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
		
		if difficulty == 0: #MAX_DIFFICULTY:
			if (randi() % 2) == 0:
				obs = bird_scene.instantiate()
				var obs_x : int = screen_size.x + score + 100
				var obs_y : int = bird_heights[randi() % bird_heights.size()]
				add_obs(obs, obs_x, obs_y)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func add_obs(obs, x, y):
	obs.position =Vector2i(x, y)
	add_child(obs)
	obstacles.append(obs)
