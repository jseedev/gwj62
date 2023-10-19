extends MeshInstance3D
var ringing = true
var con_timer=0

func _physics_process(_delta):
	if ringing and Input.is_action_just_released("answer_phone"):
		answer()
	if visible and Input.is_action_just_pressed("ui_cancel"):
		hang_up()

func incoming_call(from_name):
	$CallFrom.text="Call From"
	$Name.text=from_name
	$AnimationPlayer.play("NewCall")
	$ConnectedTime.hide()
	ringing=true
	
func hang_up():
	$PhoneIcon.hide()
	$ConnectedTime.hide()
	$CallFrom.text="CALL\nENDED"
	$AnimationPlayer.play("HangUp")
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
