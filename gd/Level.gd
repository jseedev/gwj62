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
		player.waypoint=$Game/PumpkinZones
	clouds.global_position.x=player.global_position.x
	clouds.global_position.z=player.global_position.z

var environments = {
	day = {
		sun_angle_max = 30.0,
		sky_top_color = Color(.20, .29, .41),
		sky_horizon_color = Color(.66, .72, .73),
		fog_light_energy = 0.5,
		fog_light_color = Color(.67, .71, .74),
		ambient_light_color = Color(0.0, 0.0, 0.0, 1.0),
		ambient_light_sky_contribution = 1.0,
		sky_energy_multiplier = 1.5,
		ambient_light_energy = 1.0,
	},
	morning = {
		sun_angle_max = 30.0,
		sky_top_color = Color(.23, .40, .54),
		sky_horizon_color = Color(.60, .74, .72),
		fog_light_energy = 0.5,
		fog_light_color = Color(.63, .73, .73),
		ambient_light_color = Color(.74, .77, .74, 1.0),
		ambient_light_sky_contribution = 0.5,
		sky_energy_multiplier = 2.0,
		ambient_light_energy = 0.5,
	},
	evening = {
		sun_angle_max = 20.0,
		sky_top_color = Color(.34, .39, .48),
		sky_horizon_color = Color(.75, .70, .67),
		fog_light_energy = 0.5,
		fog_light_color = Color(.71, .70, .69),
		ambient_light_color = Color(.55, .58, .55, 1.0),
		ambient_light_sky_contribution = 0.0,
		sky_energy_multiplier = 2.0,
		ambient_light_energy = 1.0,
	},
	dusk = {
		sun_angle_max = 0.0,
		sky_top_color = Color(.69, .36, .41),
		sky_horizon_color = Color(.97, .51, .39),
		fog_light_energy = 0.35,
		fog_light_color = Color(.81, .58, .61),
		ambient_light_color = Color(.18, .05, .04, 1.0),
		ambient_light_sky_contribution = 0.0,
		sky_energy_multiplier = 1.0,
		ambient_light_energy = 1.0,
	},
	night = {
		sun_angle_max = 0.0,
		sky_top_color = Color(.12, .12, .29),
		sky_horizon_color = Color(.08, .05, .14),
		fog_light_energy = 0.5,
		fog_light_color = Color(.04, .03, .10),
		ambient_light_color = Color(0.0, 0.0, 0.0, 1.0),
		ambient_light_sky_contribution = 0.3,
		sky_energy_multiplier = 0.3,
		ambient_light_energy = 1.0,
	},
}

@onready var lights = {
	morning = $MorningSun,
	day = $DaySun,
	evening = $EveningSun,
	dusk = $DuskSun,
	night = $Moon
}

func _ready():
	#lerp_environment(0.0)
	skyChange()
	player.caster.add_exception($Level/NavigationRegion3D/Field/Field/StaticBody3D)
	player.caster.add_exception(player)

@onready var env:Environment = $WorldEnvironment.environment
@onready var anim_light = $AnimatedLight
var fromSky = environments.morning
var targetSky = environments.day
@onready var from_light = lights.morning
@onready var target_light = lights.day

func lerp_environment(weight):
	anim_light.transform = anim_light.transform.interpolate_with(target_light.transform,weight)
	anim_light.light_color = lerp(from_light.light_color,target_light.light_color,weight)
	anim_light.light_energy = lerp(from_light.light_energy,target_light.light_energy,weight)
	var mat = env.sky.sky_material
	for prop in fromSky.keys():
		if prop.find("fog") > -1 or prop.find("ambient") > -1:
			env[prop]=lerp(fromSky[prop],targetSky[prop],weight)
		else:
			mat[prop]=lerp(fromSky[prop],targetSky[prop],weight)

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

var pumpkinsPerChange = 2.0
func skyChange():
	# Ricky wants 10 tweens, so each sky gets 2 passes
	if pumpkins_picked <= 10:
		env_target = env_target + (1.0 / pumpkinsPerChange)
		if env_target > 1.0:
			env_target = (1.0 / pumpkinsPerChange)
			env_current = 0.0
		
		var rounded = ceil(float(pumpkins_picked)/pumpkinsPerChange)
		if rounded == 1.0:
			fromSky = environments.morning
			targetSky = environments.day
			from_light = lights.morning
			target_light = lights.day
		elif rounded == 2.0:
			fromSky = environments.day
			targetSky = environments.evening
			from_light = lights.day
			target_light = lights.evening
		elif rounded == 3.0:
			fromSky = environments.evening
			targetSky = environments.dusk
			from_light = lights.evening
			target_light = lights.dusk
		elif rounded == 4.0:
			fromSky = environments.dusk
			targetSky = environments.night
			from_light = lights.dusk
			target_light = lights.night
		elif rounded == 5.0:
			fromSky = environments.night
			targetSky = environments.night
			from_light = lights.night
			target_light = lights.night
		tween_sky()
		
		if pumpkins_picked == 1:
			#no monsanto, sad
			player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Holo","call2")
		elif pumpkins_picked == 2:
			#it's getting darker but only a few minutes have passed
			player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call3")
			await get_tree().create_timer(15.0).timeout
			change_music(load("res://audio/music/music_2_acoustic_92bpm_loop.ogg"))
		elif pumpkins_picked == 4:
			#candy calls back to ask what you wanted
			player.get_node("Camera3D/PhoneHolder/Phone").incoming_call("Candy","call5")
			await get_tree().create_timer(30.0).timeout
			change_music(load("res://audio/music/music_3_hybrid_92bpm_loop.ogg"))
		elif pumpkins_picked == 5:
			#holo crisis
			player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Holo","call4")
			await get_tree().create_timer(9.0).timeout
			change_music(load("res://audio/music/music_4_electronic_92bpm_loop.ogg"))
		elif pumpkins_picked == 6:
			#oh boy it's gettin spicy
			player.get_node("Camera3D/PhoneHolder/Phone").voicemail("Holo","holo_voicemail")
		

func _on_pumpkin_gathered():
	pumpkins_picked+=1
	await get_tree().create_timer(1.0).timeout
	skyChange()
	player.waypoint=$PumpkinDropZone
	if pumpkins_picked == 1:
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call1")
		change_music(load("res://audio/music/music_2_acoustic_92bpm_loop.ogg"))
	elif pumpkins_picked == 2:
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Holo","call2")
		change_music(load("res://audio/music/music_2_acoustic_92bpm_loop.ogg"))
	elif pumpkins_picked == 3:
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call3")
		change_music(load("res://audio/music/music_3_hybrid_92bpm_loop.ogg"))
	elif pumpkins_picked == 4:
		player.get_node("Camera3D/PhoneHolder/Phone").incoming_call("Holo","call4")
		change_music(load("res://audio/music/music_4_electronic_92bpm_loop.ogg"))
	elif pumpkins_picked == 5:
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call5")
	elif pumpkins_picked == 6:
		player.get_node("Camera3D/PhoneHolder/Phone").voicemail("Holo","holo_voicemail")

var env_current = 0.0
var env_target = 0.0
func tween_sky():
	var sky_tween = get_tree().create_tween()
	sky_tween.tween_method(get_tree().current_scene.lerp_environment,env_current,env_target,4.0)
	env_current=env_target
	sky_tween.play()

@onready var music_player = $Level/Music
func _on_call_ended(callid):
	if callid == "holo_voicemail":
		#change music to new tune
		change_music(load("res://audio/music/music_5_chase_var1_145bpm_loop.ogg"),-3.0)
		#tween the environment
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
