extends Node

var pumpkins_picked = 0
var player = null #filled by the player itself.
var ended = false

signal call_ended(call)
signal pumpkin_gathered(player)
signal game_over(player)

@onready var clouds = $Game/Clouds
func _process(_delta):
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

func change_music(new_track):
	if music_player.playing:
		var mtween = get_tree().create_tween()
		mtween.tween_property(music_player,"volume_db",-50.0,2.0)
		mtween.play()
		await get_tree().create_timer(2.3).timeout
		music_player.stop()
	var vtween = get_tree().create_tween()
	music_player.stream=new_track
	music_player.play()
	vtween.tween_property(music_player,"volume_db",-12.0,2.0)
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

func _on_pumpkin_gathered(tplayer):
	pumpkins_picked+=1
	if pumpkins_picked == 1:
		await get_tree().create_timer(1.0).timeout
		player.get_node("Camera3D/PhoneHolder/Phone").outgoing_call("Holo","call2")

@onready var music_player = $Level/Music
func _on_call_ended(callid):
	if callid == "call2":
		#change music to new tune
		change_music(load("res://audio/music/music_5_chase_var1_145bpm_loop.ogg"))
		#tween the environment
		var sky_tween = get_tree().create_tween()
		sky_tween.tween_method(get_tree().current_scene.lerp_environment,0.0,1.0,6.0)
		sky_tween.play()
		spawn_villain()


func _on_game_over(_player):
	print("Game over .. player was caught.")
