extends CharacterBody3D
class_name PlayerBody

var SPEED = 3.0
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
@onready var PlayerSounds = $PlayerSounds #for the level to see
@onready var player_sounds = $PlayerSounds/AnimationPlayer
@onready var caster = $Camera3D/ShapeCast3D
@onready var stamina_bar = $Control/ProgressBar
@onready var vignette = $Vignette
@onready var level = get_tree().current_scene

var caught = false
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
var look_at_villain = false
var villain = null
@onready var can_update_vignette = false

# procedural headbob junk
var init = 0
var timeOffset = 0
var bob = 0.0
var bob_alpha = 0.0
var tilt = 0.0

# animation junk
@onready var Viewmodel = $Viewmodel
@onready var Animations = $Viewmodel/AnimationPlayer
var waypoint = null

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
	#await get_tree().create_timer(2.0).timeout
	#$PlayerSounds.stream=load("res://audio/voice/errol_pumpkins.ogg")
	#$PlayerSounds.play()
	$Control/ProgressBar.max_value=max_stamina

func play_step_sound():
	get_node("footsteps_" + ground_type).play()

func _process(_delta):
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
	#Do i see the villain ?
	if caster.enabled and caster.is_colliding():
		for x in range(0,caster.get_collision_count()):
			var e = caster.get_collider(x)
			if e is Villain:
				level.emit_signal("villain_sighting",e)
				break 
	if position.y <= -2.0:
		position.y = 6.0
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	var arrow = $Camera3D/Arrow
	if waypoint != null:
		arrow.visible = true
		arrow.look_at(waypoint.global_position)
		arrow.rotation_degrees.x=80
		arrow.rotation_degrees.z=0.0
	else:
		arrow.visible = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	var villainOverrideVignette = false
	if villain != null:
		if look_at_villain:
			#Camera.look_at(villain.global_position)
			#Camera.rotation_degrees.x-=0.5
			villainOverrideVignette = true
			input_dir = Vector2.ZERO
			arrow.visible = false
			vignette.weight = 0.1
			vignette.multiplier = 0.2
			vignette.softness = 1.0
			await get_tree().create_timer(2).timeout
			vignette.color = Color.WEB_MAROON
			vignette.softness = 0.1
			vignette.multiplier = 0.0
			await get_tree().create_timer(0.25).timeout
			vignette.color = Color.BLACK
			vignette.softness = 0.05
			vignette.multiplier = 0.0
		else:
			if (villain.global_position - global_position).length() <= 30.0:
				villainOverrideVignette = true
				var num = 1.0 - ((villain.global_position - global_position).length() / 30.0)
				vignette.softness = 1 + (num * 2)
				vignette.weight = 0.1
				vignette.multiplier = 0.05 + (num * 0.6)
				vignette.pulse_speed = num
				vignette.pulse_strength = num * 0.6
	
	if not villainOverrideVignette and can_update_vignette:
		var num = 1.0
		vignette.weight = 0.1
		vignette.softness = 1 + (num * 2)
		vignette.multiplier = 0.2
		vignette.pulse_speed = (1 - num) * 0.4
		vignette.pulse_strength = (1 - num)
	
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
	if !look_at_villain:
		move_and_slide()

func _input(event):
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and not look_at_villain and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cameraTarget.rotate_x(-event.relative.y * mouse_sensitivity)
		cameraTarget.rotation.x = clampf(cameraTarget.rotation.x, -deg_to_rad(70), deg_to_rad(70))

var seen = false
func _on_line_of_sight_body_entered(_body):
	if level.quick_scare:
		return
	if not seen:
		seen=true
		get_tree().current_scene.change_music(load("res://audio/music/music_5_chase_var1_145bpm_loop.ogg"),-3.0)
	pass # Replace with function body.
