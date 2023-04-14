extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.007
var forceStrength = 2
var maxInteractDistance = 2.5

var isHoldingObject = false
# Held object in physics interaction
var heldObject = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $Neck
@onready var camera := $Neck/Camera3D

func _unhandled_input(event: InputEvent) -> void:
	#capture mouse movements
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85), deg_to_rad(85))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		interact()
		
	maintainInteraction()

# Apply a force to an object
func interact() -> void:
	if !isHoldingObject:
		$Neck/Camera3D/PhysicsRayCast.force_raycast_update()
		
		if $Neck/Camera3D/PhysicsRayCast.is_colliding():
			var colider = $Neck/Camera3D/PhysicsRayCast.get_collider()
			if colider.is_in_group("interactable"):
				isHoldingObject = true
				heldObject = colider
				
	else:
		isHoldingObject = false
		heldObject = null

func maintainInteraction() -> void:
	if isHoldingObject and heldObject != null:
		var forceDirection = $Neck/Camera3D/InteractPos.global_transform.origin \
			- heldObject.global_transform.origin
		forceDirection = forceDirection.normalized()
		
		heldObject.apply_central_force(forceDirection * forceStrength)
		
		var distance = heldObject.global_transform.origin.distance_to($Neck.global_transform.origin)

		if distance > maxInteractDistance:
			isHoldingObject = false
			heldObject = null
