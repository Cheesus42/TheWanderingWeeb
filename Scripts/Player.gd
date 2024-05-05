extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const ROLL_VELOCITY = 15000.0

var can_jump = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		var current_speed = 0.0
		current_speed = get_real_velocity()
		$AnimatedSprite2D.transform.y = $AnimatedSprite2D.transform.y * (980/current_speed)
		print(current_speed)
		print($AnimatedSprite2D.transform.y)
	# Handle jump.
	if Input.is_action_just_pressed("ui_select") and (is_on_floor() or can_jump):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimatedSprite2D.play("Roll")
		velocity.x = ROLL_VELOCITY * direction
	
	if direction < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false
		
	if is_on_floor():
		if direction == 0:
			$AnimatedSprite2D.play("Idle")
		else:
			$AnimatedSprite2D.play("Idle")
	else:
		$AnimatedSprite2D.play("Jump")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimatedSprite2D.play("Roll")
		velocity.x = ROLL_VELOCITY * direction
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func _on_jump_room_body_entered(body):
	print("Body entered")
	can_jump = true


func _on_jump_room_body_exited(body):
	print("Body exited")
	can_jump = false
