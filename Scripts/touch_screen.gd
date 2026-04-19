class_name TouchScreen extends Sprite3D

@export var cam: Camera3D
@export var phone: Phone

func _process(_dt) -> void:
	var world_mouse_pos = GetWorldMousePos()
	if world_mouse_pos != Vector3.ZERO:
		var x_offset: float = world_mouse_pos.x - %TopLeft.global_position.x
		world_mouse_pos.x -= x_offset
		var y_offset: float = world_mouse_pos.distance_to(%TopLeft.global_position)
		phone.MovePoint(Vector2(x_offset, y_offset) * 4800)
	phone.HoverPhone(world_mouse_pos != Vector3.ZERO)

func GetWorldMousePos() -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(mouse_pos)
	var to = from + cam.project_ray_normal(mouse_pos) * 99
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	if result:
		return result.position
	else:
		return Vector3.ZERO
