extends CharacterBody2D

@onready var platform_area: CollisionShape2D = $"../Area2D/CollisionShape2D"
@onready var warning_area: Area2D = $WarningArea
@onready var danger_area: Area2D = $DangerArea
@onready var direction_cooldown_timer: Timer = $DirectionCooldownTimer
@onready var danger_entered_timer: Timer = $DangerEnteredTimer


var speed: int = 100
var direction: Vector2
var isStillOnDangerArea: bool = false
var isHovered: bool = false
var contaminationInterval: int = 1
var timeElepsed: float = 0.0

var platformAreaX
var platformAreaY


func _ready() -> void:
	randomize()
	_change_direction()
	platformAreaX = platform_area.get_viewport_rect().size.x
	platformAreaY = platform_area.get_viewport_rect().size.y
	print([platformAreaX,platformAreaY ])

func _process(delta: float) -> void:
	if Input.is_action_pressed("left_click") and isHovered:
		position = get_global_mouse_position()
	
	position += direction * speed * delta
	
	# Clamp to boundary
	position.x = clamp(position.x, 0, platformAreaX)
	position.y = clamp(position.y, 0, platformAreaY)
	
	# Change direction if hitting edge
	if position.x <= 0 or position.x >= platformAreaX or \
	   position.y <= 0 or position.y >= platformAreaY:
		_change_direction()
	
	position += direction * speed * delta
	timeElepsed += delta
	
	#print(position, platform_area.get_viewport_rect().size)
	
	if timeElepsed >= contaminationInterval:
		if isStillOnDangerArea: 
			GameManager.addContaminationProgress()
		
func _change_direction() -> void:
	platformAreaX = platform_area.get_viewport_rect().size.x
	platformAreaY = platform_area.get_viewport_rect().size.y
	direction = Vector2(randi_range(-platformAreaX, platformAreaX), randi_range(-platformAreaY, platformAreaY)).normalized()
	direction_cooldown_timer.start()

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
