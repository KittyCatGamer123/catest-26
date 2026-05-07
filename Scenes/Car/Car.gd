extends Node3D

# Rotates the car based on the traffic lights in front of it.
func _physics_process(delta: float) -> void:
	var vel = 0 # Velocity of the car's rotation
	var areas = $CarModel/Area3D.get_overlapping_areas() # Check the collision detection
	if areas:
		var parent: Node3D = areas[0].get_parent() 
		if parent is TrafficLight:
			var stat = parent.current_status
			
			# If light is red, don't move, else, move
			vel = 0 if stat == TrafficLight.LightStatus.RED else 1
	else:
		# Keep moving if it's not colliding with anythig
		vel = 1
	
	# Rotate body
	rotation_degrees -= Vector3(0, vel, 0)
