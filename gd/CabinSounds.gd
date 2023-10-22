extends GroundSound
@export var bus_id = 4
@export var volume_dampening = -6.0
@export var reverb_amount = 0.5
@export var tween_time = 0.5

var dvol = AudioServer.get_bus_volume_db(bus_id)
@onready var reverb = AudioServer.get_bus_effect(bus_id,0)

func _ready():
	connect("body_entered",_cabin_entered)
	connect("body_exited",_cabin_exit)
	#print(dvol)

var tween = null
func _cabin_entered(body):
	if body is PlayerBody:
		body.ground_type = string_types[ground_type]
		var cvol = AudioServer.get_bus_volume_db(bus_id)
		if tween == null or !tween.is_running():
			tween = get_tree().create_tween()
			tween.tween_method(change_bus_vol,cvol,dvol+volume_dampening,0.5)
			tween.tween_property(reverb,"wet",reverb_amount,0.5)
			tween.play()
		
		
func _cabin_exit(body):
	if body is PlayerBody:
		print(AudioServer.get_bus_volume_db(bus_id))
		body.ground_type = string_types[step_materials.GRASS]
		var cvol = AudioServer.get_bus_volume_db(bus_id)
		if tween == null or !tween.is_running():
			tween = get_tree().create_tween()
			tween.tween_method(change_bus_vol,cvol,dvol,0.5)
			tween.tween_property(reverb,"wet",0.0,0.5)
			tween.play()
			
func change_bus_vol(new_vol):
	AudioServer.set_bus_volume_db(bus_id,new_vol)
