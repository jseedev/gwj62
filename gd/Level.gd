extends Node

var pumpkins_picked = 0
var player = null #filled by the player itself.
var ended = false

signal call_ended(call)
signal pumpkin_gathered()
signal game_over()
signal villain_sighting()

@onready var clouds = $Game/Clouds
func _process(_delta):
	if Input.is_action_just_pressed("interact") and in_pumpkin_zone and player.holding_item:
		player.holding_item = false
		$PumpkinDropZone/PumpkinPile.add_pumpkin()
		$PumpkinDropZone/Highlite.hide()
	clouds.global_position.x=player.global_position.x
	clouds.global_position.z=player.global_position.z

var environments = {
	day = {
		sun_angle_max = 30.0,
		sky_top_color = Color(.17, .30, .36),
		sky_horizon_color = Color(.67, .73, .68),
		fog_light_energy = 0.5,
		fog_light_color = Color(.71, .71, .67)
	},
	night = {
		sun_angle_max = 0.0,
		sky_top_color = Color(.35, .26, .25),
		sky_horizon_color = Color(.97, .78, .61),
		fog_light_energy = 1.0,
		fog_light_color = Color(.90, .64, .46)
	}
}

func _ready():
	lerp_environment(0.0)
	player.caster.add_exception($Level/NavigationRegion3D/Field/Field/StaticBody3D)
	player.caster.add_exception(player)

@onready var env:Environment = $WorldEnvironment.environment
@onready var anim_light = $AnimatedLight
func lerp_environment(night_weight):
	var target_light
	if night_weight >= 0.75:
		target_light = $Moon
	elif night_weight >= 0.5:
		target_light=$DuskSun
	else:
		target_light = $MorningSun
	anim_light.transform = anim_light.transform.interpolate_with(target_light.transform,night_weight)
	anim_light.light_color = lerp(anim_light.light_color,target_light.light_color,night_weight)
	anim_light.light_energy = lerp(anim_light.light_energy,target_light.light_energy,night_weight)
	var mat = env.sky.sky_material
	for prop in environments.day.keys():
		if prop.find("fog") > -1:
			env[prop]=lerp(environments.day[prop],environments.night[prop],night_weight)
		else:
			mat[prop]=lerp(environments.day[prop],environments.night[prop],night_weight)

func change_music(new_track,new_volume=-12.0):
	if music_player.playing:
		var mtween = get_tree().create_tween()
		mtween.tween_property(music_player,"volume_db",-50.0,2.0)
		mtween.play()
		$Level/stingers.play()
		await get_tree().create_timer(2.3).timeout
		music_player.stop()
	var vtween = get_tree().create_tween()
	music_player.stream=new_track
	music_player.play()
	vtween.tween_property(music_player,"volume_db",new_volume,2.0)
	vtween.play()


var villain_scene = preload("res://objects/villain.tscn")
var villain = null
func spawn_villain():
	if villain == null:
		villain = villain_scene.instantiate()
		villain.player=player
		$Game.add_child(villain)
		var point = $Game/SpawnPoints.get_children().pick_random()
		villain.global_position = point.global_position
		villain.global_position.y = 6.0
		print("villain spawned")
	else:
		print("villain already spawned")
		
func despawn_villain():
	if villain != null:
		villain.queue_free()
		villain=null
		
func _on_pumpkin_gathered():
	pumpkins_picked+=1
	if pumpkins_picked == 1:
		await get_tree().create_timer(1.0).timeout
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Holo","call2")
		tween_sky(0.30)
		change_music(load("res://audio/music/music_2_acoustic_92bpm_loop.ogg"))
	elif pumpkins_picked == 2:
		await get_tree().create_timer(1.0).timeout
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call3")
		tween_sky(0.45)
		change_music(load("res://audio/music/music_3_hybrid_92bpm_loop.ogg"))
	elif pumpkins_picked == 3:
		await get_tree().create_timer(1.0).timeout
		player.get_node("Camera3D/PhoneHolder/Phone").incoming_call("Holo","call4")
		tween_sky(0.55)
		change_music(load("res://audio/music/music_4_electronic_92bpm_loop.ogg"))
	elif pumpkins_picked == 4:
		await get_tree().create_timer(1.0).timeout
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call5")
		tween_sky(0.75)
	elif pumpkins_picked == 5:
		await get_tree().create_timer(1.0).timeout
		player.get_node("Camera3D/PhoneHolder/Phone").voicemail("Holo","holo_voicemail")
		tween_sky(1.0)

var env_current = 0.0
func tween_sky(amount):
	var sky_tween = get_tree().create_tween()
	sky_tween.tween_method(get_tree().current_scene.lerp_environment,env_current,amount,4.0)
	env_current=amount
	sky_tween.play()

@onready var music_player = $Level/Music
func _on_call_ended(callid):
	if callid == "holo_voicemail":
		#change music to new tune
		change_music(load("res://audio/music/music_5_chase_var1_145bpm_loop.ogg"),-3.0)
		#tween the environment
		tween_sky(1.0)
		spawn_villain()


func _on_game_over():
	print("Game over .. player was caught.")

var seen_times = 0
func _on_villain_sighting(villain):
	if villain.global_position.distance_to(player.global_position) >= 20:
		if seen_times == 0:
			print("seen by player")
			player.player_sounds.play("gasp2")
			seen_times+=1
	else:
		if seen_times <= 1:
			print("seen by player")
			player.player_sounds.play("gasp3")
			seen_times=2
			player.caster.enabled=false
	pass # Replace with function body.

var in_pumpkin_zone=false
func _on_pumpkin_drop_zone_body_entered(body):
	if body is PlayerBody and body.holding_item:
		in_pumpkin_zone=true
		$PumpkinDropZone/Highlite.show()


func _on_pumpkin_drop_zone_body_exited(body):
	if body is PlayerBody:
		in_pumpkin_zone=false
		$PumpkinDropZone/Highlite.hide()
