class_name Cam extends Camera3D

@onready var default_height: float = position.y

@onready var default_angles: Vector2 = Vector2(rotation.y, rotation.x) # hor & ver

var offset_angles: Vector2

func _ready() -> void:
	offset_angles.y = deg_to_rad(-55)
	SetWalking(true)

func _process(_dt) -> void:
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var screen_size: Vector2 = get_viewport().size

	var mouse_offset: Vector2 = Vector2((mouse_pos.x / screen_size.x) * 2.0 - 1.0, (mouse_pos.y / screen_size.y) * 2.0 - 1.0)
	if mouse_offset.length() > 1.0:
		mouse_offset = mouse_offset.normalized()
	
	rotation.y = default_angles.x + offset_angles.x + (mouse_offset.x * -0.05)
	rotation.x = default_angles.y + offset_angles.y + (mouse_offset.y * -0.05)

var bob_tween: Tween
func SetWalking(walking: bool):
	if bob_tween && bob_tween.is_running():
		bob_tween.kill()
	if walking:
		bob_tween = create_tween().set_loops(-1)
		bob_tween.tween_property(self, "position:y", default_height - 0.003, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		bob_tween.tween_property(self, "position:y", default_height, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	else:
		bob_tween = create_tween().set_loops(-1)
		bob_tween.tween_property(self, "position:y", default_height - 0.002, 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		bob_tween.tween_property(self, "position:y", default_height, 0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

var look_tween: Tween

func LookTowards(target: float, speed: float) -> void:
	if look_tween && look_tween.is_running():
		look_tween.kill()
	look_tween = create_tween()
	look_tween.tween_property(self, "offset_angles:y", deg_to_rad(target), speed).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE) 
