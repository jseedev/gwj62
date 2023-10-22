extends Control

func _ready():
	await get_tree().create_timer(4.0).timeout
	$AnimationPlayer.play("startup")

func return_to_main_menu():
	get_tree().change_scene_to_file("res://Scenes/ui/main_menu.tscn")
