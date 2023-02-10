extends KinematicBody


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var playerLocation: Vector3 
var player
onready var visibilityNotifier = $VisibilityNotifier
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Assumers Player node is at same level in scene tree. TODO make more general
	player = get_node("../Player") # get_tree().get_root().find_node("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!visibilityNotifier.is_on_screen()):
		# find player node
		playerLocation = player.global_transform.origin
		look_at(playerLocation, Vector3.UP)
		# Statue does not look up or down
		global_rotation.x = 0

