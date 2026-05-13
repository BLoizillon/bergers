extends CharacterBody2D

const SPEED = 300.0
@onready var area = $Area2D
@onready var progress_bar = $ProgressBar

var h_dir
var v_dir
var throw_spd_min = 250.0
var throw_spd_max = 2500.0
var throw_spd = 0
@export var player_id = 1
@export_enum ("Chat", "Souris") var animal_type = ""


func _ready():
	progress_bar.min_value = throw_spd_min
	progress_bar.max_value = throw_spd_max


func _physics_process(_delta):
	# Mouvements
	_move()
	# Action
	_action()

	move_and_slide()


func _move():
	if player_id == 1:
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
		var bodies = area.get_overlapping_bodies()
		if bodies:
			for body in bodies:
				if body.is_in_group("animals"):
					body.can_move = true
					body.player = self
					body.speed = throw_spd
		throw_spd = 0
		progress_bar.hide()
		progress_bar.value = 0


func _on_body_exited(body):
	if body.is_in_group("animals"):
		body.can_move = false
		body.player = null
