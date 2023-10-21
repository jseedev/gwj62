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
		if !hiding:
			#reached the player
			target = Vector3.ZERO
			if player.global_position.distance_to(global_position) <= 5.0:
				get_tree().current_scene.emit_signal("game_over",player)
		else:
			hiding=false
	# Add the gravity.
	if not is_on_floor():
		velocity.y = -gravity
	move_and_slide()

func get_nearest_hiding_spot():
	var spots = get_tree().current_scene.get_node("Game/HidingSpots").get_children()
	var closest = null
	for spot in spots:
		if closest == null:
			closest=spot
			continue
		if closest.global_position.distance_to(player.global_position) > spot.global_position.distance_to(player.global_position):
			closest=spot
	return closest

var hiding = false
func _on_timer_timeout():
	#randomly hide
	var tdist = player.global_position.distance_to(global_position)
	if !hiding and randi() % 10 > 5 and tdist >= 50.0:
		var nspot = get_nearest_hiding_spot()
		if nspot != null:
			target=nspot.global_position
			print("hiding at "+nspot.name)
			hiding=true
	if target != Vector3.ZERO or tdist > 10.0:
		if target.distance_to(global_position) <= 20.0 and !hiding:
			if not $AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()
		else:
			$AudioStreamPlayer3D.stop()
		if not hiding:
			target = player.global_position
			nav_agent.set_target_position(player.global_position)
