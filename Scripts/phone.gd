class_name Phone extends Control

@export var point: Control

var mouse_hover: bool = false

func _ready():
	MovePoint(Vector2(20,20))

func MovePoint(pos: Vector2) -> void:
	point.position = pos

func HoverPhone(hover: bool) -> void:
	mouse_hover = hover
	point.visible = hover