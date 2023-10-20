extends CharacterBody3D


@export var SPEED = 50.0
@onready var nav_agent = $NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target = Vector3.ZERO
var player = null

func _ready():
	target = player.global_position
	nav_agent.set_target_position(player.global_position)
	
func _physics_process(delta):
	# Move to player
	if target != Vector3.ZERO and !nav_agent.is_target_reached():
		var next_point = nav_agent.get_next_path_position()
		next_point.y=global_position.y
		#next_point.z+=0.0001
		if next_point != global_position:
			look_at(next_point,Vector3.UP) #use later for skeleton
		rotation.x=0
		rotation.z=0
		velocity=(next_point-global_position).normalized()
		velocity*=SPEED
		velocity*=delta
	elif nav_agent.is_target_reached():
		#reached the player
		target = Vector3.ZERO
		get_tree().current_scene.emit_signal("game_over",player)
	# Add the gravity.
	if not is_on_floor():
		velocity.y = -gravity
	move_and_slide()


func _on_timer_timeout():
	if target != Vector3.ZERO or target.distance_to(global_position) > 10.0:
		target = player.global_position
		nav_agent.set_target_position(player.global_position)
