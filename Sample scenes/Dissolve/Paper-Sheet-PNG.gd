extends Sprite

func _ready():
	material.set_shader_param("duration", 5)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		material.set_shader_param("start_time", OS.get_ticks_msec() / 1000.0)