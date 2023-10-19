extends Node3D

@onready var harvest_progress = $Control/ProgressBar
@onready var ui_part = $Control
@onready var hilight = $Hilight
@onready var spawn : PumpkinSpawn = get_parent()

var player = null

func _physics_process(delta):
	if Input.is_action_pressed("interact") and hilight.visible and !player.get_node("Camera3D/PhoneHolder/Phone/AnimationPlayer").is_playing():
		if !$pumpkin_harvesting.playing:
			$pumpkin_harvesting.play()
		ui_part.show() #Show the ui piece for this pumpkin
		harvest_progress.value+=delta #change progress bar value with delta.
		var hval = harvest_progress.value
		if hval >= harvest_progress.max_value:
			spawn.harvest()
			hilight.hide()
			ui_part.hide()
			$pumpkin_pick.play()
			$pumpkin_harvesting.stop()
			if is_instance_valid(player):
				player.holding_item=true
			#example call
			await get_tree().create_timer(1.0).timeout
			player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Holo","call2")
			var sky_tween = get_tree().create_tween()
			sky_tween.tween_method(get_tree().current_scene.lerp_environment,0.0,1.0,3.0)
			sky_tween.play()
	elif ui_part.visible:
		harvest_progress.value=0
		ui_part.hide()

func _on_harvest_area_body_entered(body):
	if body is PlayerBody and !body.holding_item:
		#Show the interaction hint when player inside area.
		if player == null:
			player=body
		hilight.show()

func _on_harvest_area_body_exited(body):
	if body is PlayerBody and hilight.visible:
		hilight.hide()
		if ui_part.visible:
			ui_part.hide()

func enable():
	show()
	#turn on collision
	$Pumpkin/Pumpkin/CollisionShape3D.set_deferred("disabled",false)
	#$Pumpkin2/Pumpkin/CollisionShape3D.set_deferred("disabled",false)
	#$Pumpkin3/Pumpkin/CollisionShape3D.set_deferred("disabled",false)
	
func disable():
	hide()
	#turn off collision
	$Pumpkin/Pumpkin/CollisionShape3D.set_deferred("disabled",true)
	#$Pumpkin2/Pumpkin/CollisionShape3D.set_deferred("disabled",true)
	#$Pumpkin3/Pumpkin/CollisionShape3D.set_deferred("disabled",true)
