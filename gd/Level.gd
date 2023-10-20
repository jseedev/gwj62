extends Node

signal call_ended(call)

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

@onready var music_player = $Level/Music
func _on_call_ended(call):
	if call == "call2":
		#change music to new tune
		change_music(load("res://audio/music/music_2_acoustic_92bpm_loop.ogg"))

		

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
