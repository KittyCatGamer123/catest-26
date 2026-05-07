extends CSGCylinder3D
class_name TrafficLight

enum LightStatus { 
	RED, AMBER, GREEN
}

const StatusOrdering: Array[LightStatus] = [
	LightStatus.GREEN, LightStatus.AMBER, LightStatus.RED
]

const StatusColours: Dictionary[LightStatus, Color] = {
	LightStatus.RED: Color("f54b42"),
	LightStatus.AMBER: Color("#f59942"),
	LightStatus.GREEN: Color("#42f560")
}

var program_scene: ProgramScene
var current_status: LightStatus

@export var emission_light: SpotLight3D

func _ready() -> void:
	# Pick a random starting colour for the light
	var starting_status: LightStatus = [ LightStatus.RED, LightStatus.AMBER, LightStatus.GREEN ].pick_random()
	set_status(starting_status)
	status_loop()

func set_status(status: LightStatus) -> void:
	# Create a copy of the current mesh material to make it unique and then override it
	var mat: StandardMaterial3D = material.duplicate()
	mat.albedo_color = StatusColours[current_status]
	material = mat
	
	# Now change the status so that we can tween the colours all nice and pretty
	current_status = status
	get_tree().create_tween().tween_property(mat, "albedo_color", StatusColours[current_status], 0.5)
	get_tree().create_tween().tween_property(emission_light, "light_color", StatusColours[current_status], 0.5)
	
	if program_scene != null:
		# Send a psudo-singal to the Program scene to tell it to update its text
		program_scene._on_traffic_status_changed()

# Gets the next status in the traffic light colour ordering
func next_status() -> void:
	var position_in_ordering: int = StatusOrdering.find(current_status)
	
	# If the next one is out of range, go back to the start
	if (position_in_ordering + 1) >= len(StatusOrdering):
		set_status(StatusOrdering[0])
	else:
		set_status(StatusOrdering[position_in_ordering + 1])

# Recursive function for indefinitely changing the traffic light's colour
func status_loop():
	var interval = randf_range(3, 8)
	await get_tree().create_timer(interval).timeout
	next_status()
	status_loop()
