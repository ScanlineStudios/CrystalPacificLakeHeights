extends StaticBody

onready var tween = $Tween

# directionthe door opens. 
export var direction: int = 1

var open: bool = false
var in_animation: bool = false
var open_speed: float = 0.5

func interact():
		
	
	if !in_animation:
		tween.interpolate_property(self, "rotation_degrees", Vector3(rotation_degrees.x, rotation_degrees.y, rotation_degrees.z), Vector3(rotation_degrees.x, rotation_degrees.y+90*direction, rotation_degrees.z), open_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		direction = direction * -1
	
	in_animation = true
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	open = !open
	in_animation = false

