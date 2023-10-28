@tool
extends Node3D
class_name PumpkinZones

##Number of pumpkin patches to spawn at a time.
@export var number_of_spawns = 3

@onready var spawn_points = get_children() #Array of child PumpkinSpawn
var spawned = [] #currently spawned pumpkins.

func _ready():
	#$"../outdoorsambiance".play()
	if Engine.is_editor_hint():
		#code for editor
		if get_children().size() == 0:
			var new_point = PumpkinSpawn.new()
			new_point.name = "PumpkinSpawn"
			add_child(new_point) #create a pumpkin spawn point.
			new_point.set_owner(get_tree().get_edited_scene_root()) #show in the editor.
	else:
		spawn_pumpkins()

func spawn_pumpkins(how_many=null):
	if how_many == null:
		how_many=number_of_spawns
	var pspawned = 0
	if spawn_points.size() > 0:
		for x in range(0,how_many):
			var random_i = randi() % spawn_points.size() #random index
			var spawn_point = spawn_points[random_i] #random spawn position
			spawn_points.remove_at(random_i) #remove it from the spawnable zones for now.
			spawned.append(spawn_point)
			spawn_point.get_child(0).enable() #unhide it.
			pspawned+=1
			if spawn_points.size() == 0:
				#out of places to spawn
				break
	print("Spawned "+str(pspawned)+" ("+str(spawned.size())+")")

#reset all the spawn points back to hidden
func reset_spawns():
	spawn_points = get_children()
	for point in spawn_points:
		point.get_child(0).disable()
