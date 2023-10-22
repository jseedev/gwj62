extends MeshInstance3D
var ringing = false
var con_timer=0
var on_call = null
var call_playing = false
@onready var call_player = $calls/AnimationPlayer
@onready var evoice = $calls/Errol
@onready var cvoice = $calls/Caller

var lplay = null
func _ready():
	#voicemail("Holo","errol_voicemail1") #for testing
	pass
	
func _physics_process(_delta):
#	if ringing and Input.is_action_just_released("answer_phone"):
#		answer()
#		play_call(on_call)
	if visible and Input.is_action_just_pressed("ui_cancel"):
		hang_up()
	if call_playing and !call_player.is_playing():
		call_playing=false
		var current_level = get_tree().current_scene
		current_level.emit_signal("call_ended",on_call)
		$calls/Control/Captions.text=""
		hang_up()
		

func play_call(call_name):
	call_player.play(call_name)
	$calls.on_caption = 0

func outgoing_call(to_name,call_name):
	$CallFrom.text="Calling"
	$CallFrom.show()
	$PhoneIcon.show()
	$PhoneIcon.transparency=0.0
	$Name.text=to_name
	on_call=call_name
	ringing=true
	$AnimationPlayer.play("OutgoingCall")
	$ConnectedTime.hide()
	await get_tree().create_timer(7.0).timeout
	if visible:
		answer()
		play_call(on_call)
	
	
func incoming_call(from_name,call_name):
	$PhoneIcon.show()
	$CallFrom.text="Call From"
	$CallFrom.show()
	$Name.text=from_name
	$AnimationPlayer.play("NewCall")
	$ConnectedTime.hide()
	ringing=true
	on_call=call_name
	await get_tree().create_timer(7.0).timeout
	if visible:
		answer()
		play_call(on_call)
		
func hang_up():
	$PhoneIcon.hide()
	$ConnectedTime.hide()
	$CallFrom.text="Call\nEnded"
	$AnimationPlayer.play("HangUp")
	$calls/AnimationPlayer.stop()
	ringing=false
	
func answer():
	con_timer=0
	$ConnectedTime.text="00:00"
	$PhoneIcon.transparency=0.0
	$PhoneIcon.show()
	$CallFrom.text="Connected"
	$AnimationPlayer.play("Connected")
	$ConnectedTime.show()
	ringing=false
	call_playing=true
	
func voicemail(to_name,call_name):
	ringing=true
	$CallFrom.text="New\nVoicemail"
	$CallFrom.show()
	$PhoneIcon.hide()
	$Name.text=to_name
	on_call=call_name
	$AnimationPlayer.play("NewVoicemail")
	$ConnectedTime.hide()
	await get_tree().create_timer(4.0).timeout
	if visible:
		answer()
		play_call(on_call)

func connected():
	con_timer+=1
	var time_h = con_timer / 60
	var time_s = con_timer % 60
	if time_s < 10:
		time_s = "0"+str(time_s)
	$ConnectedTime.text = "0"+str(time_h)+":"+str(time_s)
