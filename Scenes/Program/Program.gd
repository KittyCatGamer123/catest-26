extends Node3D
class_name ProgramScene

# Spawn Origin: Centre point that rotates the spawn position to make a perfect circle
# Spawn Point: The position in which where the traffic lights will spawn
@export var spawn_origin: Node3D
@export var spawn_point: Node3D

# Variables for traffic light instancing and keeping track of the them in the scene
var traffic_scene = preload("res://Scenes/TrafficLight/TrafficLight.tscn")
var active_traffic_lights: Array[TrafficLight] = []
@export var active_lights_label: RichTextLabel

func _ready() -> void:
	spawn_origin.rotation_degrees = Vector3(0,0,0)
	
	for n in range(0, 360, 36):
		# Rotate the origin point by 36 degrees and spawn a new traffic light
		spawn_origin.rotation_degrees = Vector3(0, n, 0)
		
		var ts: TrafficLight = traffic_scene.instantiate()
		ts.program_scene = self
		add_child(ts)
		ts.global_position = spawn_point.global_position
		
		active_traffic_lights.append(ts)


func _on_traffic_status_changed():
	# Keep track of all the statuses of lights when called
	var values: Dictionary[TrafficLight.LightStatus, int] = {
		TrafficLight.LightStatus.RED: 0,
		TrafficLight.LightStatus.AMBER: 0,
		TrafficLight.LightStatus.GREEN: 0
	}
	
	for tl in active_traffic_lights:
		values[tl.current_status] += 1
	
	# Update the text displaying all the traffic light status
	active_lights_label.text =  "[color=#f54b42]Red[/color]        %s\n" % values[TrafficLight.LightStatus.RED]
	active_lights_label.text += "[color=#f59942]Amber[/color]   %s\n" % values[TrafficLight.LightStatus.AMBER]
	active_lights_label.text += "[color=#42f560]Green[/color]    %s" % values[TrafficLight.LightStatus.GREEN]
