extends Node

var pumpkins_picked = 0
var player = null #filled by the player itself.
var ended = false

@onready var cabin = $Level/NavigationRegion3D/Cabin
@onready var cabinator = $Level/NavigationRegion3D/Cabin/AnimationPlayer
@onready var creak = $Level/NavigationRegion3D/Cabin/Door/DoorCreak
@onready var vignette = $Game/player/Vignette

var call_order = [
	["out","call2","Holo"],
	["out","call3","Candy","res://audio/music/music_2_acoustic_92bpm_loop.ogg"],
	["in","call4","Holo","res://audio/music/music_3_hybrid_92bpm_loop.ogg"],
	["vm","holo_voicemail","Holo","res://audio/music/music_4_electronic_92bpm_loop.ogg"]
]
signal call_ended(call)
signal pumpkin_gathered()
signal game_over()
signal villain_sighting()

#func droppedOffPumpkin():
#	if pumpkins_picked == 4:
#		#it's kinda late but only a few minutes seem to have passed
#		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call3")
#		await get_tree().create_timer(15.0).timeout
#		change_music(load("res://audio/music/music_2_acoustic_92bpm_loop.ogg"))

@onready var clouds = $Game/Clouds
func _process(_delta):
	if Input.is_action_just_pressed("interact") and in_pumpkin_zone and player.holding_item:
		#droppedOffPumpkin()
		player.holding_item = false
		$PumpkinDropZone/PumpkinPile.add_pumpkin()
		$Game/PumpkinZones.spawn_pumpkins(1)
		$PumpkinDropZone/Highlite.hide()
		player.waypoint=null
		#player.waypoint=$Game/PumpkinZones.get_children()
	clouds.global_position.x=player.global_position.x
	clouds.global_position.z=player.global_position.z
	if $ArrowHider.overlaps_body(player) and $Game/player/Camera3D/Arrow.visible:
		$Game/player/Camera3D/Arrow.hide()
	elif !$ArrowHider.overlaps_body(player) and player.waypoint != null:
		$Game/player/Camera3D/Arrow.show()
#	if Input.is_action_just_pressed("cheater"):
#		emit_signal("pumpkin_gathered")

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
		ambient_light_color = Color(0.1, 0.1, 0.1, 1.0),
		ambient_light_sky_contribution = 0.8,#0.3
		sky_energy_multiplier = 0.8,#0.3
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
	$Game/player/Camera3D/Arrow.hide()
	cabinator.play("Door_Closed")
	skyChange(true)
	player.caster.add_exception($Level/NavigationRegion3D/Field/Field/StaticBody3D)
	player.caster.add_exception(player)
	vignette.weight = 0.005
	vignette.softness = 3.0
	vignette.multiplier = 0.2
	
	await get_tree().create_timer(2.0).timeout
	player.can_update_vignette = true
	#await get_tree().create_timer(2.0).timeout
	player.waypoint=null
	player.PlayerSounds.stream=load("res://audio/voice/errol_pumpkins.ogg")
	player.PlayerSounds.play()
	cabinator.play("Door_Open", 0.5)
	creak.play()
	change_music(load("res://audio/music/music_1_theme_92bpm_loop.ogg"))
	await get_tree().create_timer(3.0).timeout
	player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Candy","call1")
	
#	spawn_villain() # Spawns the villain immediately for testing purposes


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
		player.villain = villain
		$Game.add_child(villain)
		var point = $Game/SpawnPoints.get_children().pick_random()
		villain.global_position = point.global_position
		villain.global_position.y = 6.0
		print("villain spawned")
	else:
		print("villain already spawned")
		
func despawn_villain():
	if villain != null:
		player.villain = null
		villain.queue_free()
		villain=null

var quick_scare=false
func quick_jump_scare():
	if villain != null:
		return
	quick_scare=true
	did_quick_scare=true
	var js = player.get_node("JumpSpot")
	var temp_villain = villain_scene.instantiate()
	add_child(temp_villain)
	temp_villain.global_position = js.global_position
	temp_villain.look_at(player.global_position)
	#temp_villain.rotation_degrees.y-=180
	temp_villain.rotation_degrees.x=0
	temp_villain.rotation_degrees.z=0
	temp_villain.animations.play("Catch")
	temp_villain.animations.speed_scale=2.0
	

var pumpkinsPerChange = 2.0
var on_call = 0
func skyChange(reset):
	if reset:
		env_target = 0.0
	else:
		env_target = env_target + 0.5
		if env_target > 1.0:
			env_target = 0.5
			env_current = 0.0
	
	var rounded = ceil(float(pumpkins_picked) / 2.0)
	if rounded == 1:
		fromSky = environments.morning
		targetSky = environments.day
		from_light = lights.morning
		target_light = lights.day
	elif rounded == 2:
		fromSky = environments.day
		targetSky = environments.evening
		from_light = lights.day
		target_light = lights.evening
	elif rounded == 3:
		fromSky = environments.evening
		targetSky = environments.dusk
		from_light = lights.evening
		target_light = lights.dusk
	elif rounded == 4:
		fromSky = environments.dusk
		targetSky = environments.night
		from_light = lights.dusk
		target_light = lights.night
	elif rounded == 5:
		fromSky = environments.night
		targetSky = environments.night
		from_light = lights.night
		target_light = lights.night
	tween_sky()

func _on_pumpkin_gathered():
	pumpkins_picked+=1
	await get_tree().create_timer(1.0).timeout
	skyChange(false)
	if not player.phone.get_node("calls/AnimationPlayer").is_playing() and !did_quick_scare:
		#sometimes you get jump scared
		quick_jump_scare()
	player.waypoint=$PumpkinDropZone
	if !player.phone.get_node("calls/AnimationPlayer").is_playing() and !player.phone.visible:
		play_next_call()

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
		spawn_villain()
		villain.target_player()


func _on_game_over():
	player.look_at_villain = true
	player.look_at(villain.global_position)
	player.rotation_degrees.x = 5.0
	player.rotation_degrees.z = 0.0
#	player.Camera.look_at(villain.global_position)
#	player.Camera.rotation_degrees.x-=0.5
	#villain.animations.play("Catch", 0.3)
	villain.loss_condition_animation.play("caught")
	await get_tree().create_timer(5.0).timeout
	#villain.animations.stop()
	print("Game over .. player was caught.")

var seen_times = 0
var did_quick_scare = false
func _on_villain_sighting(tvillain):
	if on_call < 3 and quick_scare:
		print("seen by player,quick")
		player.player_sounds.play("gasp3")
		quick_scare=false
		tvillain.get_node("Flash/AnimationPlayer").play("flash")
		await get_tree().create_timer(0.3).timeout
		tvillain.queue_free()
	elif tvillain.global_position.distance_to(player.global_position) >= 20:
		if seen_times == 0:
			print("seen by player, far away")
			player.player_sounds.play("gasp2")
			seen_times=1
	elif on_call >= 3:
		#This can only happen on last calls.
		if seen_times <= 1:
			print("seen by player, close")
			player.player_sounds.play("gasp3")
			seen_times=2
			player.caster.enabled=false

var in_pumpkin_zone=false
func _on_pumpkin_drop_zone_body_entered(body):
	if body is PlayerBody and body.holding_item:
		in_pumpkin_zone=true
		$PumpkinDropZone/Highlite.show()


func _on_pumpkin_drop_zone_body_exited(body):
	if body is PlayerBody:
		in_pumpkin_zone=false
		$PumpkinDropZone/Highlite.hide()


func return_closest(anchor,in_array):
	var closest = null
	var tdist = null
	for e in in_array:
		var d = e.global_position.distance_to(anchor.global_position)
		if closest == null:
			closest=e
			tdist=d
		elif d < tdist:
			closest=e
			tdist=d
	return closest
		
func play_next_call():
	var tc = call_order[on_call]
	if tc[1] == "call4":
		$Level/NavigationRegion3D/DistantCabin.hide()
	if tc[0] == "in":
		player.phone.incoming_call(tc[2],tc[1])
	elif tc[0] == "out":
		player.phone.outgoing_call(tc[2],tc[1])
	else:
		player.phone.voicemail(tc[2],tc[1])
	if tc.size() > 3:
		change_music(load(tc[3]))
	on_call+=1
