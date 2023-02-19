extends KinematicBody

var speed = 10

var gravity = 9.8
var jump = 7

var cameraAcceleration = 50
var sensitivity = .1

var snap

var direction = Vector3()
var velocity = Vector3()
var gravityVector = Vector3()
var movement = Vector3()

onready var head = $Head
onready var camera = $Head/Camera

func _input(event) -> void:
    if event is InputEventMouseMotion:
        rotate_y(deg2rad(-event.relative.x * sensitivity))
        head.rotate_x(deg2rad(-event.relative.y * sensitivity))
        
        head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta: float) -> void:
    direction = Vector3.ZERO
    var horizontalRotation = global_transform.basis.get_euler().y
    var forwardInput = Input.get_action_strength("moveBack") - Input.get_action_strength("moveForward")
    var rightwardInput = Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft")
    direction = Vector3(rightwardInput, 0, forwardInput).rotated(Vector3.UP, horizontalRotation).normalized()
    
    if is_on_floor():
        snap = -get_floor_normal()
        gravityVector = Vector3.ZERO
    else:
        snap = Vector3.DOWN
        gravityVector += Vector3.DOWN * gravity * delta
        
    # jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        snap = Vector3.ZERO
        gravityVector = Vector3.UP * jump

    velocity = velocity.linear_interpolate(direction * speed, delta)
    movement = velocity + gravityVector
    
    move_and_slide_with_snap(movement, snap, Vector3.UP)

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    pass
