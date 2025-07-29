extends CharacterBody2D

const GRAVITY : int = 2250
const JUMP_SPEED : int = -800

func _physics_process(delta: float):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			$WalkCol.disabled = false
			if Input.is_key_pressed(KEY_W):
				velocity.y = JUMP_SPEED
				$JumpSoundEffect.play()
			elif Input.is_key_pressed(KEY_S):
				$AnimatedSprite2D.play("duck")
				$WalkCol.disabled = true
			else:
				$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
