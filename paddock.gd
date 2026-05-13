extends Area2D

@export var animal_type = "Souris"
@export var animal_count = 5

var current_count = 0
@onready var label = $Label


func _ready():
	label.text = "[wave]" + str(current_count) + "/" + str(animal_count) + "[/wave]"


func _on_body_entered(body):
	if body.animal_type == animal_type:
		current_count += 1
		label.text = "[wave]" + str(current_count) + "/" + str(animal_count) + "[/wave]"
		if current_count == animal_count:
			print("Victory!")


func _on_body_exited(body):
	if body.animal_type == animal_type:
		current_count -= 1
		label.text = "[wave]" + str(current_count) + "/" + str(animal_count) + "[/wave]"
