extends CharacterBody2D

const SPEED = 300.0
@onready var area_animal: Area2D = $Area2D
@onready var area_mask: Area2D = $AreaMask
@onready var progress_bar = $ProgressBar
@onready var sprite: Sprite2D = $Sprite2D

var h_dir
var v_dir
var throw_spd_min = 250.0
var throw_spd_max = 1000.0
var throw_spd = 0
@export var player_id = 0
@export_enum ("Chat", "Souris") var animal_type = ""


func _ready():
	progress_bar.min_value = throw_spd_min
	progress_bar.max_value = throw_spd_max
	match animal_type:
		"": sprite.frame = 0 + player_id * 6
		"Chat": sprite.frame = 2 + player_id * 6
		"Souris": sprite.frame = 4 + player_id * 6


func _physics_process(_delta):
	# Mouvements
	_move()
	# Action
	_action()
	# Animation
	_animation()

	move_and_slide()


func _move():
	if player_id:
		h_dir = Input.get_axis("player1_left", "player1_right")
		v_dir = Input.get_axis("player1_up", "player1_down")
	else:
		h_dir = Input.get_axis("player2_left", "player2_right")
		v_dir = Input.get_axis("player2_up", "player2_down")
		
	if h_dir:
		velocity.x = h_dir
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if v_dir:
		velocity.y = v_dir
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	velocity = velocity.normalized() * SPEED


func _action():
	if throw_spd > 0 && throw_spd < throw_spd_max:
		throw_spd += 25.0
		progress_bar.show()
		progress_bar.value = throw_spd
	if Input.is_action_just_pressed("players_action"):
		throw_spd = throw_spd_min
	if Input.is_action_just_released("players_action"):
		var bodies = area_animal.get_overlapping_bodies()
		if bodies:
			for body in bodies:
				if body.is_in_group("animals"):
					if body.mask_feared == animal_type:
						body.can_move = true
						body.player = self
						body.speed = throw_spd
		throw_spd = 0
		progress_bar.hide()
		progress_bar.value = 0


func _animation():
	match animal_type:
		"":
			if v_dir > 0: sprite.frame = 0 + player_id * 6
			elif v_dir < 0: sprite.frame = 1 + player_id * 6
		"Chat":
			if v_dir > 0: sprite.frame = 2 + player_id * 6
			elif v_dir < 0: sprite.frame = 3 + player_id * 6
		"Souris":
			if v_dir > 0: sprite.frame = 4 + player_id * 6
			elif v_dir < 0: sprite.frame = 5 + player_id * 6


func _on_body_exited(body):
	if body.is_in_group("animals"):
		body.can_move = false
		body.player = null


func _on_mask_area_entered(area):
	var last_animal_type = animal_type
	animal_type = area.mask_type
	_ready()
	if last_animal_type == "":
		area.queue_free()
	else:
		area.mask_type = last_animal_type
		area._mask_sprite()
