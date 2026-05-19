extends CharacterBody2D

@onready var area = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var sfx_fromage: AudioStreamPlayer = $SFXFromage
@onready var sfx_souris: AudioStreamPlayer = $SFXSouris

@export_enum("Souris", "Fromage") var animal_type := "Souris"
var mask_feared: String
var can_move = false
var speed = 1000.0
var rotation_v = 0.0
var rotation_spd = 1.0
var player


func _process(delta):
	# Déplacements
	_move(delta)

	# Animaux
	match animal_type:
		"Souris":
			mask_feared = "Chat"
			sprite.frame = 0
		"Fromage":
			mask_feared = "Souris"
			sprite.frame = 1


func _move(delta):
	if can_move:
		var diff = global_position - player.global_position
		velocity = diff.normalized() * speed
		rotation_v = rotation_spd
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.05)
		velocity.y = lerp(velocity.y, 0.0, 0.05)
		rotation_v = lerp(rotation_v, 0.0, 0.1)

	rotation += rotation_v

	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
		can_move = false
		player = null


func _play_sound():
	match animal_type:
		"Souris": sfx_souris.play()
		"Fromage": sfx_fromage.play()
