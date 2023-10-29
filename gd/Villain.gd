extends CharacterBody3D
class_name Villain

@export var SPEED = 50.0
@onready var nav_agent = $NavigationAgent3D
@onready var animations = $Shabahan/AnimationPlayer
@onready var loss_condition_animation = $LossConditionAnimation

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target = Vector3.ZERO
var player = null
var gameover = false

var previous_velocity = Vector3.ZERO

func _ready():
	#target = player.global_position
	#nav_agent.set_target_position(player.global_position)
	if get_tree().current_scene.quick_scare:
		$Timer.stop()
	animations.play("Idle")

func target_player():
	target = player.global_position
	nav_agent.set_target_position(player.global_position)

func _physics_process(delta):
	# Move to player
	if target == Vector3.ZERO:
		velocity.y = -gravity
		move_and_slide()
		return
	if target != Vector3.ZERO and !nav_agent.is_target_reached() and not gameover:
		var next_point = nav_agent.get_next_path_position()
		next_point.y=global_position.y
		#next_point.z+=0.0001
		if next_point != transform.origin:
			look_at(next_point,Vector3.UP) #use later for skeleton
		rotation.x=0
		rotation.z=0
		velocity=(next_point-global_position).normalized()
		velocity*=SPEED
		velocity*=delta
	elif nav_agent.is_target_reached() or (player.global_position - global_position).length() <= 3.0:
		#reached the player
		target = Vector3.ZERO
		velocity=Vector3.ZERO
		if player.global_position.distance_to(global_position) <= 5.0 and not gameover:
			gameover = true
			animations.play("Catch", 0.3)
			animations.speed_scale=0.2
			get_tree().current_scene.emit_signal("game_over")
	else:
		target=Vector3.ZERO
		velocity=Vector3.ZERO
	# Add the gravity.
	if not is_on_floor():
		velocity.y = -gravity
		
	if not gameover:
		if Vector2(velocity.x, velocity.z) == Vector2.ZERO:
			animations.play("Idle", 0.5)
		else:
			animations.play("Move", 0.5)
	
	previous_velocity = velocity
	
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

var hiding_spot = null
var hiding = false
func _on_timer_timeout():
	#randomly hide
	var tdist = player.global_position.distance_to(global_position)
	if tdist >= 30.0:
		var nspot = get_nearest_hiding_spot()
		if nspot != null and nspot != hiding_spot:
			hiding_spot=nspot
			global_position=hiding_spot.global_position
			global_position.y+=6.0
			target=Vector3.ZERO
			hiding=true
	if (tdist <= 20.0 and target == Vector3.ZERO) or !hiding:
		target = player.global_position
		nav_agent.set_target_position(player.global_position)
		hiding=false
		hiding_spot=null
		if !$AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.stream=load("res://audio/sfx/enemy/sfx_enemyfloat_loop.wav")
			$AudioStreamPlayer3D.play()
	elif tdist > 20.0:
		if $AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.stop()


func player_is_caught():
	loss_condition_animation.play("before_main_menu")
	loss_condition_animation.connect("animation_finished",the_end,CONNECT_ONE_SHOT)
	
func the_end(_anim):
	loss_condition_animation.play("caught",0.3)
	#get_tree().change_scene_to_file("res://Scenes/ui/main_menu.tscn")
	pass
