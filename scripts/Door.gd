extends Node3D

@onready var hinge: HingeJoint3D = $HingeJoint3D
@onready var door: PhysicsBody3D = $PhysicsDoor

var door_force: float = 0.8

func _physics_process(_delta: float) -> void:
	var door_angle: float = door.global_rotation_degrees.y
	
	if abs(door_angle) > 5:
		hinge.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, -1 * door_angle/abs(door_angle) * door_force )
	else:
		hinge.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, 0 )
	
