extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1800

func _physics_process(delta: float):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		if Input.is_key_pressed(KEY_W):
			velocity.y = JUMP_SPEED
			$JumpSoundEffect.play()
		elif Input.is_key_pressed(KEY_S):
			$AnimatedSprite2D.play("duck")
		else:
			$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
