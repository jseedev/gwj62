extends Control

@onready var main = $Front/Main
@onready var front = $Front
@onready var settings = $Front/Settings
@onready var controls = $Front/Controls
@onready var credits = $Front/Credits
@onready var back_button = $Front/BackButton

@onready var music_slider: HSlider = $Front/Settings/VolumeVertical/MusicHorizontal/MusicSlider
@onready var sfx_slider: HSlider = $Front/Settings/VolumeVertical/SFXHorizontal/SFXSlider
@onready var dialogue_slider: HSlider = $Front/Settings/VolumeVertical/DialogueHorizontal/DialogueSlider

@onready var scene_animations = $MainMenuAnimPlayer
@onready var transition_animations = $TransitionAnimPlayer


func _ready():
	music_slider.value = AudioServer.get_bus_volume_db(3)
	sfx_slider.value = AudioServer.get_bus_volume_db(1)
	dialogue_slider.value = AudioServer.get_bus_volume_db(2)
	show_main()


func show_main() -> void:
	main.visible = true
	settings.visible = false
	controls.visible = false
	credits.visible = false
	back_button.visible = false


func _on_begin_button_pressed():
	$SoundUIBeginGame.play()
	await $SoundUIBeginGame.finished
	get_tree().change_scene_to_file("res://Scenes/Environment.tscn")


func _on_settings_button_pressed():
	main.visible = false
	settings.visible = true
	controls.visible = false
	credits.visible = false
	back_button.visible = true
	scene_animations.play("settings")
	$SoundUISelect.play()


func _on_controls_button_pressed():
	main.visible = false
	settings.visible = false
	controls.visible = true
	credits.visible = false
	back_button.visible = true
	scene_animations.play("controls")
	$SoundUISelect.play()


func _on_credits_button_pressed():
	main.visible = false
	settings.visible = false
	controls.visible = false
	credits.visible = true
	back_button.visible = true
	scene_animations.play("credits")
	$SoundUISelect.play()


func _on_exit_button_pressed():
	$SoundUISelect.play()
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()


func _on_back_button_pressed():
	show_main()
	$SoundUIBack.play()


# Volume Sliders

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(3,value)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1,value)


func _on_dialogue_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2,value)


# Hover Sounds

func _on_begin_button_mouse_entered():
	$SoundUIHover.play()


func _on_settings_button_mouse_entered():
	$SoundUIHover.play()


func _on_controls_button_mouse_entered():
	$SoundUIHover.play()


func _on_credits_button_mouse_entered():
	$SoundUIHover.play()


func _on_exit_button_mouse_entered():
	$SoundUIHover.play()
