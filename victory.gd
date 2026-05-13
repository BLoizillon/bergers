extends Node

@onready var victory_screen: CanvasLayer = %VictoryScreen
@export var next_level_path = ""
@onready var next_level = load(next_level_path)
var victory := false
var paddocks : Array


func _ready():
	victory_screen.hide()
	paddocks = get_children()


func _process(_delta):
	for paddock in paddocks:
		if paddock.is_full: victory = true
		else: victory = false

	if victory:
		victory_screen.show()
		if Input.is_action_just_pressed("players_action"):
			get_tree().change_scene_to_packed(next_level)
