extends MeshInstance3D
var ringing = true
var con_timer=0
var on_call = null

func _physics_process(_delta):
	if ringing and Input.is_action_just_released("answer_phone"):
		answer()
		play_call(on_call)
	if visible and Input.is_action_just_pressed("ui_cancel"):
		hang_up()

func play_call(call_name):
	$calls/AnimationPlayer.play(call_name)

func outgoing_call(to_name,call_name):
	$CallFrom.text="Calling"
	$CallFrom.show()
	$Name.text=to_name
	on_call=call_name
	$AnimationPlayer.play("OutgoingCall")
	$ConnectedTime.hide()
	await get_tree().create_timer(8.0).timeout
	answer()
	play_call(on_call)
	
func incoming_call(from_name,call_name):
	$PhoneIcon.show()
	$CallFrom.text="Call From"
	$Name.text=from_name
	$AnimationPlayer.play("NewCall")
	$ConnectedTime.hide()
	ringing=true
	on_call=call_name
	
func hang_up():
	$PhoneIcon.hide()
	$ConnectedTime.hide()
	$CallFrom.text="CALL\nENDED"
	$AnimationPlayer.play("HangUp")
	$calls/AnimationPlayer.stop()
	ringing=false
	
func answer():
	con_timer=0
	$PhoneIcon.show()
	$CallFrom.text="Connected"
	$AnimationPlayer.play("Connected")
	$ConnectedTime.show()
	ringing=false

func connected():
	con_timer+=1
	var time_h = con_timer / 60
	var time_s = con_timer % 60
	if time_s < 10:
		time_s = "0"+str(time_s)
	$ConnectedTime.text = "0"+str(time_h)+":"+str(time_s)
