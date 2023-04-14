extends CharacterBody3D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var playerLocation: Vector3 
var player
@onready var visibilityNotifier = $VisibleOnScreenNotifier3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Assumes Player node is at same level in scene tree. TODO make more general
	player = get_node("../Player") # get_tree().get_root().find_child("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (!visibilityNotifier.is_on_screen()):
		# find player node
		playerLocation = player.global_transform.origin
		look_at(playerLocation, Vector3.UP)
		# Statue does not look up or down
		global_rotation.x = 0

