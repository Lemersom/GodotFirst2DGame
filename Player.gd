extends Area2D

signal hit

export var speed = 400.0  #px/s
var screen_size = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO #vetor(0, 0)
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite.play()  # $ funciona como um get_node()
	else:
		$AnimatedSprite.stop()
	
	position += direction * speed *delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if direction.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = direction.y > 0
	

func start(new_position):
	position = new_position
	show() #mostra o player
	$CollisionShape2D.disabled = false


func _on_Player_body_entered(body):
	hide() #esconde o player caso morrer
	$CollisionShape2D.set_deferred("disabled", true)
	emit_signal("hit")
