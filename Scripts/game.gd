class_name Game extends Node3D

static var ins: Game

func _init():
	ins = self

var look_state: int = 1 # 1 = down, 2 = up, 3 = up & phone

@export var snake_shook: Texture
@export var toad_shook: Texture
@export var cat_shook: Texture

func SetLookState(state: int) -> void:
	if look_state == state:
		return
	match state:
		1:
			$Cam.LookTowards(-55, 1.0)
			MoveLights(0.14)
			SetPhonePivot(-30)
		2:
			$Cam.LookTowards(0, 1.0)
			if look_state == 1:
				MoveLights(0)
			SetPhonePivot(-10)
		3:
			$Cam.LookTowards(-10, 1.0)
			if look_state == 1:
				MoveLights(0)
			SetPhonePivot(10)
	look_state = state

func SetMoving(moving: bool) -> void:
	$MovingGrass.moving = moving
	$Cam.SetWalking(moving)
	Phone.ins.moving = moving

func Encounter(which: int) -> void:
	var encounter: Tween = create_tween()
	match which:
		0:
			$Snake.visible = true
			encounter.tween_property($Snake, "position:z", 0.0, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			encounter.tween_interval(0.1)
			encounter.tween_callback(func(): SnakeWobble())
			encounter.tween_callback(func(): Phone.ins.AddFlash())
			encounter.tween_callback(func(): SetLookState(3))
		1:
			$Toad.visible = true
			encounter.tween_property($Toad, "position:z", 0.05, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			encounter.tween_interval(0.1)
			encounter.tween_callback(func(): ToadHop())
			encounter.tween_callback(func(): Phone.ins.AddFlash())
			encounter.tween_callback(func(): SetLookState(3))
		2:
			$Cat.visible = true
			encounter.tween_property($Cat, "position:z", 0.1, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			encounter.tween_interval(0.1)
			encounter.tween_callback(func(): Phone.ins.AddFlash())
			encounter.tween_callback(func(): SetLookState(3))
		3:
			$Obelisk.visible = true
			encounter.tween_property($Obelisk, "position:z", 0.1, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			encounter.tween_interval(1.5)
			encounter.tween_callback(func(): SetLookState(3))
			encounter.tween_callback(func(): Phone.ins.obelisk = true)


func FlashEncounter(which: int) -> void:
	SetLookState(2)
	var encounter: Tween = create_tween()
	%PhoneFlash.visible = true
	encounter.tween_interval(0.2)
	encounter.tween_callback(func(): %PhoneFlash.visible = false)
	match which:
		0:
			snake_wobble.kill()
			$Snake.texture = snake_shook
			$Snake.material_override.albedo_texture = snake_shook
			$Snake.material_override.backlight_texture = snake_shook
			$Snake/Eye.visible = false
			$Snake/Eye2.visible = false
			encounter.tween_interval(1.5)
			encounter.tween_property($Snake, "position:z", -1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			encounter.tween_callback(func(): $Snake.visible = false)
			encounter.tween_interval(0.8)
		1:
			toad_hop.kill()
			$Toad.texture = toad_shook
			$Toad.material_override.albedo_texture = toad_shook
			$Toad.material_override.backlight_texture = toad_shook
			encounter.tween_interval(1.5)
			encounter.tween_property($Toad, "position:z", -1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			encounter.tween_callback(func(): $Toad.visible = false)
			encounter.tween_interval(0.8)
		2:
			$Cat.texture = cat_shook
			$Cat.material_override.albedo_texture = cat_shook
			$Cat.material_override.backlight_texture = cat_shook
			encounter.tween_property($Cat, "position:y", 0.25, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			encounter.tween_interval(1.0)
			encounter.tween_property($Cat, "position:z", -1.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
			encounter.tween_callback(func(): $Cat.visible = false)
			encounter.tween_interval(0.8)
	encounter.tween_callback(func(): SetLookState(1))
	encounter.tween_interval(1.8)
	encounter.tween_callback(func(): Phone.ins.JuugleMaps(true))


var snake_wobble: Tween
func SnakeWobble() -> void:
	snake_wobble = create_tween().set_loops(-1)
	snake_wobble.tween_property($Snake, "position:x", 0.15, 2.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	snake_wobble.tween_property($Snake, "position:x", -0.15, 2.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

var toad_hop: Tween
func ToadHop() -> void:
	toad_hop = create_tween().set_loops(-1)
	toad_hop.tween_property($Toad, "position:y", 0.25, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	toad_hop.tween_property($Toad, "position:y", 0.173, 0.8).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

var light_tween: Tween
func MoveLights(distance: float):
	if light_tween && light_tween.is_running():
		light_tween.kill()
	light_tween = create_tween()
	light_tween.tween_property($Spotlights, "position:z", distance, 2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

var phone_tween: Tween
func SetPhonePivot(angle: float):
	if phone_tween && phone_tween.is_running():
		phone_tween.kill()
	phone_tween = create_tween()
	phone_tween.tween_property($PhonePivot, "rotation:x", deg_to_rad(angle), 1.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
