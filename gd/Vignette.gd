extends Node

@onready var effect = $CanvasLayer/ColorRect
@onready var mat = effect.material
@onready var multiplier = 0.0
@onready var softness = 0.25
@onready var color = Color.BLACK
@onready var pulse_speed = 0.0
@onready var pulse_strength = 0.0
@onready var weight = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mat["shader_parameter/Multiplier"] = lerp(mat["shader_parameter/Multiplier"], multiplier, weight)
	mat["shader_parameter/Softness"] = lerp(mat["shader_parameter/Softness"], softness, weight)
	mat["shader_parameter/Color"] = lerp(mat["shader_parameter/Color"], color, weight)
	mat["shader_parameter/Pulse_Speed"] = pulse_speed
	mat["shader_parameter/Pulse_Strength"] = lerp(mat["shader_parameter/Pulse_Strength"], pulse_strength, weight)
