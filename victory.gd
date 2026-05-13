extends Node

@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@export var next_level_path = ""
@onready var next_level = load(next_level_path)
var victory := false
var paddocks : Array


func _ready():
	paddocks = get_children()


func _process(_delta):
	for paddock in paddocks:
		if paddock.is_full: victory = true
		else: victory = false

	if victory:
		canvas_layer.show()
		if Input.is_action_just_pressed("players_action"):
			get_tree().change_scene_to_packed(next_level)
