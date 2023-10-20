extends Control




#@onready var main = $Front/Main
#@onready var background = $Behind/WhiteBackground
#@onready var front = $Front
#@onready var settings = $Front/Settings
#@onready var controls = $Front/Controls
#@onready var credits = $Front/Credits
#@onready var back_button = $Front/BackButton
#
#@onready var music_slider: HSlider = $Front/Settings/VolumeVertical/Music/MusicSlider
#@onready var sfx_slider: HSlider = $Front/Settings/VolumeVertical/SFX/SFXSlider
#@onready var ui_slider: HSlider = $Front/Settings/VolumeVertical/UI/UISlider
#
#@onready var scene_animations = $MainMenuAnimPlayer
#@onready var transition_animations = $TransitionAnimPlayer
#
#
#func _ready():
#	music_slider.value = AudioServer.get_bus_volume_db(1)
#	sfx_slider.value = AudioServer.get_bus_volume_db(2)
#	ui_slider.value = AudioServer.get_bus_volume_db(4)
#	show_main()
#
#
#func show_main() -> void:
#	main.visible = true
#	settings.visible = false
#	controls.visible = false
#	credits.visible = false
#	back_button.visible = false
#
#
#func _on_start_button_pressed():
#	$SoundUIStartGame.play()
#	await $SoundUIStartGame.finished
#	get_tree().change_scene_to_file("res://game/game.tscn")
#
#
#func _on_settings_button_pressed():
#	main.visible = false
#	settings.visible = true
#	controls.visible = false
#	credits.visible = false
#	back_button.visible = true
#	scene_animations.play("settings")
#	transition_animations.play("title_movement")
#	$SoundUISelect.play()
#
#
#func _on_controls_button_pressed():
#	main.visible = false
#	settings.visible = false
#	controls.visible = true
#	credits.visible = false
#	back_button.visible = true
#	scene_animations.play("controls")
#	transition_animations.play("title_movement")
#	$SoundUISelect.play()
#
#
#func _on_credits_button_pressed():
#	main.visible = false
#	settings.visible = false
#	controls.visible = false
#	credits.visible = true
#	back_button.visible = true
#	scene_animations.play("credits")
#	transition_animations.play("title_movement")
#	$SoundUISelect.play()
#
#
#func _on_exit_button_pressed():
#	$SoundUISelect.play()
#	await get_tree().create_timer(1.0).timeout
#	get_tree().quit()
#
#
#func _on_back_button_pressed():
#	show_main()
#	transition_animations.play_backwards("title_movement")
#	$SoundUIBack.play()
#
#
## Volume Sliders
#
#func _on_music_slider_value_changed(value):
#	AudioServer.set_bus_volume_db(1,value)
#
#
#func _on_sfx_slider_value_changed(value):
#	AudioServer.set_bus_volume_db(2,value)
#
#
#func _on_ui_slider_value_changed(value):
#	AudioServer.set_bus_volume_db(4,value)
#
#
## Hover Sounds
#
#func _on_start_button_mouse_entered():
#	$SoundUIHover.play()
#
#
#func _on_settings_button_mouse_entered():
#	$SoundUIHover.play()
#
#
#func _on_controls_button_mouse_entered():
#	$SoundUIHover.play()
#
#
#func _on_credits_button_mouse_entered():
#	$SoundUIHover.play()
#
#
#func _on_exit_button_mouse_entered():
#	$SoundUIHover.play()
 
