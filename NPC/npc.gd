extends CharacterBody2D

@export var npc_sprite : Sprite2D

var sprite_list: Dictionary = {
	'unmasked': {
		'sprite_1': preload("res://Assets/PixelClique/BaristaGirl/BaristaGirlMovement&Gestures.png"),
		'sprite_2': preload("res://Assets/PixelClique/BeretGirl/BeretGirlMovement&Gestures.png"),
		'sprite_3': preload("res://Assets/PixelClique/EmoGirl/EmoGirlMovement.png"),
		'sprite_4': preload("res://Assets/PixelClique/GymGirl/GymGirlMovement&Gestures.png"),
	},
	'masked': {
		'sprite_1': preload("res://Assets/BaristaGirlMasked.png"),
		'sprite_2': preload("res://Assets/BeretGirlMasked.png"),
		'sprite_3': preload("res://Assets/EmoGirlMasked.png"),
		'sprite_4': preload("res://Assets/GymGirlMasked.png"),
	}
}
var sprite_key : String

var platform_area: CollisionShape2D
@onready var warning_area: Area2D = $WarningArea
@onready var danger_area: Area2D = $DangerArea
@onready var direction_cooldown_timer: Timer = $DirectionCooldownTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float = 100.0
var normal_speed : float = 100.0
var direction: Vector2
var isStillOnDangerArea: bool = false
var isContaminating: bool = false
var isPickedUp: bool = false
var contaminationInterval: int = 1
var timeElapsed: float = 0.0

var platformAreaX
var platformAreaY

var got_hit_sfx := preload("res://Art/brackeys_platformer_assets/sounds/hurt.wav")

func _ready() -> void:
	%warning.visible = false
	randomize()
	
	var random_chance := randi_range(0, 2)
	if random_chance != 0: %Delicacy.queue_free()
	
	_change_direction()
	
	var keys = sprite_list["unmasked"].keys() #select a random sprite name from unmasked
	sprite_key = keys[randi() % keys.size()]
	print("keys: ", keys, " sprite_key: ", sprite_key)
	npc_sprite.texture = sprite_list["unmasked"][sprite_key]

func _process(delta: float) -> void:
	update_scale_for_distance()
	_move(delta)
	_animate_sprite()
	
	timeElapsed += delta

	if isStillOnDangerArea:
		if timeElapsed >= contaminationInterval:
			isContaminating = true
			GameManager.contaminationProgress += 0.1
			%warning.modulate = Color.WEB_PURPLE
		else:
			isContaminating = false
			%warning.modulate = Color.FIREBRICK

func got_hit():
	AudioUtility.add_sfx(self, got_hit_sfx)
	GameManager.score += randi_range(100, 500)
	
	if get_node_or_null("%Delicacy"): 
		%Delicacy.queue_free()
		GameManager.contaminationProgress -= 10
	
	npc_sprite.texture = sprite_list['masked'][sprite_key]
	set_collision_layer_value(1, false)
	warning_area.set_deferred("monitoring", false)
	warning_area.set_deferred("monitorable", false)
	danger_area.set_deferred("monitoring", false)
	danger_area.set_deferred("monitorable", false)
	modulate.a = 0.5
	TweenUtility.fade_in_or_out(self, self.modulate.a, 0, 5)
	await get_tree().create_timer(5).timeout
	self.queue_free()

func update_scale_for_distance(): ##When closer looks bigger, farther looks smaller
	self.scale = Vector2(position.y, position.y) / 80
	speed = (scale.x * normal_speed) * 0.2 ##When far also move slower

func change_to_masked() -> void:
	for i in sprite_list['unmasked'].size():
		if npc_sprite.texture == sprite_list['unmasked']['sprite_' + str(i+1)]:
			npc_sprite.texture = sprite_list['masked']['sprite_' + str(i+1)]

func _move(delta: float) -> void:
	if Input.is_action_pressed("left_click") and isPickedUp:
		position = get_global_mouse_position()
	else:
		# Get rect in world space
		var rect = platform_area.shape.get_rect()
		var rect_pos = platform_area.global_position + rect.position
		var rect_size = rect.size

		# Clamp to boundary
		position.x = clamp(position.x, rect_pos.x, rect_pos.x + rect_size.x)
		position.y = clamp(position.y, rect_pos.y, rect_pos.y + rect_size.y)
		
		# Change direction if hitting edge
		if position.x <= rect_pos.x or position.x >= rect_pos.x + rect_size.x or \
		   position.y <= rect_pos.y or position.y >= rect_pos.y + rect_size.y:
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
		npc_sprite.flip_h = false
	elif direction.x > 0:
		npc_sprite.flip_h = true

func _on_warning_area_area_entered(_area: Area2D) -> void:
	#print('warning')
	%warning.visible = true
	%warning.modulate = Color.YELLOW

func _on_warning_area_area_exited(_area: Area2D) -> void:
	%warning.visible = false

func _on_danger_area_area_entered(_area: Area2D) -> void:
	#print('danger')
	%warning.visible = true
	isStillOnDangerArea = true
	timeElapsed = 0

func _on_danger_area_area_exited(_area: Area2D) -> void:
	print('danger exited')
	%warning.visible = false
	isStillOnDangerArea = false
	timeElapsed = 0

func _on_direction_cooldown_timer_timeout() -> void:
	_change_direction()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		isPickedUp = true
	
	if event.is_action_released("left_click"):
		isPickedUp = false

func _on_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
