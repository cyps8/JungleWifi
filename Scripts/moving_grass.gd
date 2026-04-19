class_name MovingGrass extends Node3D

var moving: bool = true

var grasses: Array[Sprite3D] = []

@export var grass_ins: PackedScene

func _ready():
	for i in 20:
		NewGrass(true)

func _process(_dt):
	if moving:
		var to_remove: Array[Sprite3D] = []
		for grass in grasses:
			grass.position.z += _dt * 0.12
			if grass.position.z > 0.8:
				to_remove.append(grass)
				grass.queue_free()
				NewGrass()
		for grass in to_remove:
			grasses.erase(grass)

func NewGrass(start: bool = false):
	var new_grass = grass_ins.instantiate()
	add_child(new_grass)
	while abs(new_grass.position.x) < 0.1:
		var z: float = 0
		if start:
			z = randf() * 0.8
		new_grass.position = Vector3((randf() * 0.5) - 0.25, 0, z)
	grasses.append(new_grass)
