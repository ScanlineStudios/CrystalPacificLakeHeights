extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var SPEED: float = 3.0


func _physics_process(delta: float) -> void:
	var current_location: Vector3 = global_transform.origin
	var next_location: Vector3 = nav_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()


func update_target_location(target_location: Vector3) -> void:
	nav_agent.set_target_position(target_location)
