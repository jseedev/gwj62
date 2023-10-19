extends Node

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
func lerp_environment(night_weight):
	if night_weight >= 0.75:
		$Moon.show()
		$DuskSun.hide()
		$MorningSun.hide()
	elif night_weight >= 0.5:
		$Moon.hide()
		$DuskSun.show()
		$MorningSun.hide()
	else:
		$Moon.hide()
		$DuskSun.hide()
		$MorningSun.show()
	var mat = env.sky.sky_material
	for prop in environments.day.keys():
		if prop.find("fog") > -1:
			env[prop]=lerp(environments.day[prop],environments.night[prop],night_weight)
		else:
			mat[prop]=lerp(environments.day[prop],environments.night[prop],night_weight)
