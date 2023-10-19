extends CharacterBody3D
class_name PlayerBody

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const RUN_MULT = 2.0

const mouse_sensitivity = .005

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var hand_pumpkin = $Camera3D/ItemHolder/Pumpkin
@onready var Camera = $Camera3D
@onready var cameraTarget = $Camera_Target
var holding_item = false

var walking = false
var just_walking = false
var running = false
var just_running = false

# procedural headbob junk
var init = 0
var timeOffset = 0
var bob = 0.0
var tilt = 0.0

#this function can be replaced with lerp()
#func interpolate(from, to, by):
#	return from + (to - from) * by

func runtime():
	return Time.get_unix_time_from_system() - init
	

func _ready():
	init = Time.get_unix_time_from_system()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$AnimationPlayer.play("walk")

func _process(delta):
	if walking:
		if just_walking:
			just_walking = false
			timeOffset = runtime()
			$AnimationPlayer.play("walk", .5)
	elif running:
		if just_running:
			just_running = false
			$AnimationPlayer.play("run", .5)
	else:
		$AnimationPlayer.pause()

func _physics_process(delta):
	#If our player is holding a pumpkin, make it visible. Otherwise, hide it.
	if is_instance_valid(hand_pumpkin):
		if holding_item and !hand_pumpkin.visible:
			hand_pumpkin.show()
			$Camera3D/ArmRig.show()
			#todo - change hand placements
		elif !holding_item and hand_pumpkin.visible:
			hand_pumpkin.hide()
			$Camera3D/ArmRig.hide()
			#todo - change hand placements
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if Input.is_action_pressed("run") and input_dir.y<0:
		running = true
		walking = false
		velocity.x = direction.x * SPEED * RUN_MULT
		velocity.z = direction.z * SPEED * RUN_MULT
	elif direction:
		walking = true
		running = false
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		walking = false
		running = false
		just_walking = true
		just_running = true
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	var move = 0
	if (running or walking):
		move = 1
	
	# procedural headbob junk
	bob = lerp(bob, cos((runtime() - timeOffset) * SPEED * RUN_MULT) * move * 0.05, 0.1)
	tilt = lerp(tilt, -input_dir.x / 15, 0.1)
	Camera.rotation = cameraTarget.rotation + Vector3(-abs(bob) / 2.5, (bob / 5), tilt)
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		cameraTarget.rotate_x(-event.relative.y * mouse_sensitivity)
		cameraTarget.rotation.x = clampf(cameraTarget.rotation.x, -deg_to_rad(70), deg_to_rad(70))
