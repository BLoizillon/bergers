extends CharacterBody2D

@onready var area = $Area2D

@export_enum("Souris", "Fromage") var animal_type = "Souris"
var can_move = false
var speed = 1000.0
var player


func _process(delta):
	# Déplacements
	_move(delta)
	

func _move(delta):
	if can_move:
		var diff = global_position - player.global_position
		velocity = diff.normalized() * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.y = lerp(velocity.y, 0.0, 0.05)

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		can_move = false
		player = null
