extends CharacterBody2D

var sprite_list: Dictionary = {
	'sprite_1': preload("res://Assets/PixelClique/BaristaGirl/BaristaGirlMovement&Gestures.png"),
	'sprite_2': preload("res://Assets/PixelClique/BeretGirl/BeretGirlMovement&Gestures.png"),
	'sprite_3': preload("res://Assets/PixelClique/EmoGirl/EmoGirlMovement.png"),
	'sprite_4': preload("res://Assets/PixelClique/GymGirl/GymGirlMovement&Gestures.png")
}

@onready var platform_area: CollisionShape2D = %CollisionShape2D
@onready var warning_area: Area2D = $WarningArea
@onready var danger_area: Area2D = $DangerArea
@onready var direction_cooldown_timer: Timer = $DirectionCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


var speed: int = 100
var direction: Vector2
var isStillOnDangerArea: bool = false
var isPickedUp: bool = false
var contaminationInterval: int = 1
var timeElepsed: float = 0.0

var platformAreaX
var platformAreaY


func _ready() -> void:
	randomize()
	_change_direction()
	sprite_2d.texture = sprite_list.values().pick_random()

func _process(delta: float) -> void:
	_move(delta)
	_animate_sprite()
	
	timeElepsed += delta

	if timeElepsed >= contaminationInterval:
		if isStillOnDangerArea: 
			GameManager.addContaminationProgress()
			
func _move(delta: float) -> void:
	if Input.is_action_pressed("left_click") and isPickedUp:
		position = get_global_mouse_position()
	else:
		# Clamp to boundary
		position.x = clamp(position.x, 0, platformAreaX)
		position.y = clamp(position.y, 0, platformAreaY)
		
		# Change direction if hitting edge
		if position.x <= 0 or position.x >= platformAreaX or \
		   position.y <= 0 or position.y >= platformAreaY:
			_change_direction()
		
		position += direction * speed * delta
		
func _change_direction() -> void:
	platformAreaX = platform_area.shape.get_rect().size.x
	platformAreaY = platform_area.shape.get_rect().size.y
	direction = Vector2(randi_range(-platformAreaX, platformAreaX), randi_range(-platformAreaY, platformAreaY)).normalized()
	direction_cooldown_timer.start()
	
func _animate_sprite() -> void:
	if direction:
		animation_player.play("run")
		
	if direction.x < 0:
		sprite_2d.flip_h = false
	elif direction.x > 0:
		sprite_2d.flip_h = true

func _on_warning_area_area_entered(area: Area2D) -> void:
	print('warning')

func _on_danger_area_area_entered(area: Area2D) -> void:
	print('danger')
	isStillOnDangerArea = true
	

func _on_danger_area_area_exited(area: Area2D) -> void:
	print('danger exited')
	isStillOnDangerArea = false

func _on_direction_cooldown_timer_timeout() -> void:
	_change_direction()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		isPickedUp = true
	
	if event.is_action_released("left_click"):
		isPickedUp = false
