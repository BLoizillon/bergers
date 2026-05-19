extends Area2D

@export_enum("Chat", "Souris") var mask_type := "Chat"
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	_mask_sprite()


func _mask_sprite():
	match mask_type:
		"Chat": sprite.frame = 0
		"Souris": sprite.frame = 1
