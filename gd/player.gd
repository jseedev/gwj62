extends CharacterBody3D
class_name PlayerBody

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const RUN_MULT = 2.0

const mouse_sensitivity = .005

const max_stamina = 7.0
var stamina = max_stamina
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var hand_pumpkin = $Viewmodel/ArmRig/Skeleton3D/InHand/Pumpkin
@onready var Camera = $Camera3D
@onready var cameraTarget = $Camera_Target
@onready var phone = $Camera3D/PhoneHolder/Phone
@onready var player_sounds = $PlayerSounds/AnimationPlayer
@onready var caster = $Camera3D/ShapeCast3D
@onready var stamina_bar = $Control/ProgressBar
var holding_item = false : set = _set_holding_pumpkin

func _set_holding_pumpkin(ibool):
	holding_item=ibool
	if is_instance_valid(hand_pumpkin):
		if ibool and !hand_pumpkin.visible:
			hand_pumpkin.show()
			$Viewmodel/AnimationPlayer.play("RestPose")
			#todo - change hand placements
		elif !ibool and hand_pumpkin.visible:
			hand_pumpkin.hide()
			$Viewmodel/AnimationPlayer.play("Idle",0.5)

#Flag for when the player exactly performs a step (needed for sfx)
var just_stepping = false
var stepping = false

var ground_type = "grass"
 
var walking = false
var just_walking = false
var running = false
var just_running = false

# procedural headbob junk
var init = 0
var timeOffset = 0
var bob = 0.0
var bob_alpha = 0.0
var tilt = 0.0

# animation junk
@onready var Viewmodel = $Viewmodel
@onready var Animations = $Viewmodel/AnimationPlayer
@onready var waypoint = get_tree().current_scene.get_node("Game/PumpkinZones")

#this function can be replaced with lerp()
#func interpolate(from, to, by):
#	return from + (to - from) * by

func runtime():
	return Time.get_unix_time_from_system() - init
	

func _ready():
	get_tree().current_scene.player=self
	Animations.play("Idle", 0.5)
	init = Time.get_unix_time_from_system()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(2.0).timeout
	$PlayerSounds.stream=load("res://audio/voice/errol_pumpkins.ogg")
	$PlayerSounds.play()
	$Control/ProgressBar.max_value=max_stamina

func play_step_sound():
	get_node("footsteps_" + ground_type).play()

func _process(delta):
	if just_walking and walking or just_running and running:
		timeOffset = runtime()
	if walking:
		if just_walking:
			just_walking = false
			if !holding_item:
				Animations.play("Walk", 0.9, 1.75)
	elif running:
		if just_running:
			just_running = false
			if !holding_item:
				Animations.play("Run", 0.5, 1.75)
	else:
		if (just_walking or just_running):
			if !holding_item:
				Animations.play("Idle", 0.9)
	if stepping:
		if just_stepping:
			just_stepping = false
			play_step_sound()
var run_timer = 0.0
func _physics_process(delta):
	if caster.enabled:
		var bodies = $Camera3D/LineOfSight.get_overlapping_bodies()
		if bodies.size() > 0:
			if bodies[0].global_position.distance_to(global_position) > 20.0:
				get_tree().current_scene.emit_signal("villain_sighting",bodies[0])
			elif caster.is_colliding():
				var fc = caster.get_collider(0) #colliding object
				if fc is Villain:
					get_tree().current_scene.emit_signal("villain_sighting",fc)
	if position.y <= -2.0:
		position.y = 6.0
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	var arrow = $Camera3D/Arrow
	if waypoint != null:
		arrow.look_at(waypoint.global_position)
		arrow.rotation_degrees.x=88.0
		arrow.rotation_degrees.z=0.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_just_pressed("run"):
		run_timer=0.0
	if Input.is_action_pressed("run") and input_dir.y<0 and stamina > 0.0:
		if not running:
			just_running = true
		
		running = true
		walking = false
		stamina-=delta
		velocity.x = direction.x * SPEED * RUN_MULT
		velocity.z = direction.z * SPEED * RUN_MULT
	elif direction:
		if not walking:
			just_walking = true
		
		walking = true
		running = false
		stamina+=delta
		stamina=clamp(stamina,0.0,max_stamina)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		walking = false
		running = false
		just_walking = true
		just_running = true
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var move = 0.0
	var timeScale = 1.0
	if walking:
		move = 1.0
	if running and stamina > 0.0:
		run_timer+=delta
		if !$PlayerSounds.playing and !player_sounds.is_playing() and !$Camera3D/PhoneHolder/Phone/calls/AnimationPlayer.is_playing():
			if run_timer >= 3.0:
				player_sounds.play("breathing_heavy")
			elif run_timer >=0.5:
				player_sounds.play("breathing_light")
		move = 1.75
		timeScale = 2.0
	
	bob_alpha = lerp(bob_alpha, move, 0.075)
	
	# procedural headbob junk
	bob = lerp(bob, cos((runtime() - timeOffset) * SPEED * RUN_MULT * timeScale) * bob_alpha * 0.05, 0.1)
	
	#When bobbing closes to end of movement before turning back to the other direction, raise flag that step sound should play
	if abs(bob - 0.05) < 0.02 or abs(bob + 0.05) < 0.02:
		if not stepping: just_stepping = true
		stepping = true
	else:
		stepping = false
		just_stepping = false
		
	tilt = lerp(tilt, -input_dir.x / 15, 0.1)
	Camera.rotation = cameraTarget.rotation + Vector3(-abs(bob) / 2.5, (bob / 5), tilt)
	if velocity==Vector3.ZERO:
		stamina+=delta
		stamina=clamp(stamina,0.0,max_stamina)
	stamina_bar.value=stamina
	if stamina < max_stamina:
		stamina_bar.show()
	else:
		stamina_bar.hide()
	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cameraTarget.rotate_x(-event.relative.y * mouse_sensitivity)
		cameraTarget.rotation.x = clampf(cameraTarget.rotation.x, -deg_to_rad(70), deg_to_rad(70))


func _on_line_of_sight_body_entered(body):
	pass # Replace with function body.
