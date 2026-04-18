class_name Cam extends Camera3D

@onready var default_angles: Vector2 = Vector2(rotation.y, rotation.x) # hor & ver

func _process(_dt) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var screen_size: Vector2 = get_viewport().size

	var mouse_offset: Vector2 = Vector2((mouse_pos.x / screen_size.x) * 2.0 - 1.0, (mouse_pos.y / screen_size.y) * 2.0 - 1.0)
	if mouse_offset.length() > 1.0:
		mouse_offset = mouse_offset.normalized()
	
	rotation.y = default_angles.x + (mouse_offset.x * -0.05)
	rotation.x = default_angles.y + (mouse_offset.y * -0.05)
	