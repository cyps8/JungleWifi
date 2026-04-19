class_name Phone extends Control

static var ins: Phone

func _init():
	ins = self

@export var point: Control

@export var signal_colour: Color

var mouse_hover: bool = false

var moving: bool = false
var move_cd: float = 0

func _ready():
	%StartButton.visible = true
	%JungleWifi.visible = false
	%Password.visible = false
	%JuugleMaps.visible = false
	%Flash.visible = false
	%Win.visible = false
	MovePoint(Vector2(20,20))

func MovePoint(pos: Vector2) -> void:
	point.position = pos

func HoverPhone(hover: bool) -> void:
	mouse_hover = hover
	point.visible = hover

func _process(_dt) -> void:
	if mouse_hover && Input.is_action_just_pressed("Click"):
		Tap()
	if moving:
		move_cd -= _dt
		if move_cd < 0:
			move_cd = 0.1
			if %Path.size.y == 73:
				%Path.size.y = 88
				%Path.position.y = 167
			else:
				%Path.size.y -= 1
				%Path.position.y += 1

func Tap() -> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Button")
	for button in buttons:
		if button.visible:
			if point.global_position.x > button.global_position.x && point.global_position.y > button.global_position.y && point.global_position.x < button.global_position.x + button.size.x && point.global_position.y < button.global_position.y + button.size.y:
				if button is Button:
					button.pressed.emit()
				elif button is LineEdit:
					button.grab_focus()

var on_encounter: int = 0

func JuugleMaps(open: bool):
	%JuugleMaps.visible = open
	var juugle_sequence: Tween = create_tween()
	juugle_sequence.tween_interval(0.5)
	juugle_sequence.tween_callback(func(): Game.ins.SetMoving(true))
	juugle_sequence.tween_interval(3.5)
	juugle_sequence.tween_callback(func(): %Warning.visible = true)
	juugle_sequence.tween_interval(0.2)
	juugle_sequence.tween_callback(func(): Game.ins.SetMoving(false))
	juugle_sequence.tween_interval(1.0)
	juugle_sequence.tween_callback(func(): Game.ins.SetLookState(2))
	juugle_sequence.tween_interval(1.5)
	juugle_sequence.tween_callback(func(): %JuugleMaps.visible = false)
	juugle_sequence.tween_callback(func(): Game.ins.Encounter(on_encounter))

func AddFlash() -> void:
	%Flash.visible = true
	%Warning.visible = false

func FlashPressed() -> void:
	%Flash.visible = false
	Game.ins.FlashEncounter(on_encounter)
	on_encounter += 1

func StartPressed():
	%StartButton.visible = false

	FlashNoSignal()
	var intro_sequence: Tween = create_tween()
	intro_sequence.tween_interval(3)
	intro_sequence.tween_callback(func(): Game.ins.SetLookState(2))
	intro_sequence.tween_callback(func(): Game.ins.SetMoving(false))
	intro_sequence.tween_interval(3)
	intro_sequence.tween_callback(func(): %JungleWifi.visible = true)
	intro_sequence.tween_interval(1)
	intro_sequence.tween_callback(func(): Game.ins.SetLookState(3))
	
func FlashNoSignal():
	var flash: Tween = create_tween()
	flash.tween_callback(func(): %NoSignal.visible = true)
	flash.tween_interval(0.6)
	flash.tween_callback(func(): %NoSignal.visible = false)
	flash.tween_interval(0.4)
	flash.tween_callback(func(): %NoSignal.visible = true)
	flash.tween_interval(0.6)
	flash.tween_callback(func(): %NoSignal.visible = false)
	flash.tween_interval(0.4)
	flash.tween_callback(func(): %NoSignal.visible = true)
	flash.tween_interval(0.6)
	flash.tween_callback(func(): %NoSignal.visible = false)

func Win():
	obelisk = false
	%Password.visible = true
	var password_wrong: Tween = create_tween()
	password_wrong.tween_interval(1.0)
	password_wrong.tween_callback(func(): TryPassword())
	password_wrong.tween_interval(1.5)
	password_wrong.tween_callback(func(): %Correct.visible = true)
	password_wrong.tween_interval(2.2)
	password_wrong.tween_callback(func(): %Correct.visible = false)
	password_wrong.tween_callback(func(): %Enter.text = "")
	password_wrong.tween_callback(func(): %Password.visible = false)
	password_wrong.tween_interval(1.2)
	password_wrong.tween_callback(func(): %Win.visible = true)

var can_password: bool = true
var obelisk: bool = false
func JungleWifiPressed():
	if !can_password:
		if obelisk:
			Win()
		return
	can_password = false
	%Password.visible = true
	var password_wrong: Tween = create_tween()
	password_wrong.tween_interval(1.0)
	password_wrong.tween_callback(func(): TryPassword())
	password_wrong.tween_interval(1.5)
	password_wrong.tween_callback(func(): %Wrong.visible = true)
	password_wrong.tween_interval(2.2)
	password_wrong.tween_callback(func(): %Wrong.visible = false)
	password_wrong.tween_callback(func(): %Enter.text = "")
	password_wrong.tween_callback(func(): %Password.visible = false)
	password_wrong.tween_interval(1.2)
	password_wrong.tween_callback(func(): Game.ins.SetLookState(1))
	password_wrong.tween_interval(0.5)
	password_wrong.tween_callback(func(): JuugleMaps(true))

func TryPassword() -> void:
	var try_password: Tween = create_tween().set_loops(10)
	try_password.tween_interval(0.1)
	try_password.tween_callback(func(): %Enter.text = %Enter.text + "1")
	
func Quit() -> void:
	get_tree().quit()
