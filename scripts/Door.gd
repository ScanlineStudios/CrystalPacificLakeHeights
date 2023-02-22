extends StaticBody

onready var tween = $Tween

var open: bool = false
var in_animation: bool = false
var open_speed: float = 0.5

func interact():
    
    if !open and !in_animation:
        tween.interpolate_property(self, "rotation_degrees", Vector3(0, rotation_degrees.y, 0), Vector3(0, rotation_degrees.y+90, 0), open_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        
    elif open and !in_animation:
        tween.interpolate_property(self, "rotation_degrees", Vector3(0, rotation_degrees.y, 0), Vector3(0, rotation_degrees.y-90, 0), open_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    
    in_animation = true
    tween.start()

func _on_Tween_tween_all_completed() -> void:
    open = !open
    in_animation = false

