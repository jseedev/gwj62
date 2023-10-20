extends Area3D
class_name GroundSound

enum step_materials {GRASS,LEAVES,STONE,DIRT,WOOD}
var string_types = ["grass","leaves","rock","dirt","woodcreak"]
@export var ground_type : step_materials

func _ready():
	connect("body_entered",_body_entered)
	connect("body_exited",_body_exit)

func _body_entered(body):
	if body is PlayerBody:
		body.ground_type = string_types[ground_type]
	
func _body_exit(body):
	if body is PlayerBody:
		body.ground_type = string_types[step_materials.GRASS]
