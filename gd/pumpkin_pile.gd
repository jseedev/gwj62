extends Node3D
var on_pumpkin = null
func add_pumpkin():
	if on_pumpkin != null:
		$"../sfx_placepumpkin".play()
		on_pumpkin+=1
		get_node("Pumpkin"+str(on_pumpkin)).show()
	else:
		on_pumpkin=1
		$Pumpkin.show()
