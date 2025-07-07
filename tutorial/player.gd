extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	_movePlayer(delta)

func _movePlayer(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("player_move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("player_move_right"):
		velocity.x += 1
	if Input.is_action_pressed("player_move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("player_move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	_updatePlayerAnimation(velocity)
	_updatePlayerPosition(velocity, delta)
	
func _updatePlayerAnimation(velocity):
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
		
		var animation = "walk"
		var flip_v = false
		var flip_h = false
		if velocity.y != 0:
			animation = "up"
			flip_v = velocity.y > 0
		elif velocity.x != 0:
			animation = "walk"
			flip_h = velocity.x < 0
		
		$AnimatedSprite2D.animation = animation
		$AnimatedSprite2D.flip_v = flip_v
		$AnimatedSprite2D.flip_h = flip_h
	else:
		$AnimatedSprite2D.stop()

func _updatePlayerPosition(velocity, delta):
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
