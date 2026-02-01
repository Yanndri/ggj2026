extends Sprite2D

@export var launcher : Marker2D
@export var bullet_scene : PackedScene
@export var shooter_animations : AnimationPlayer
@export var cooldown : float = 0.5
@export var default_bullet_speed : float = 100

var in_cooldown : bool
var bullet_speed : float

var max_points = 10.0
var speed_multiplier := 5

var shoot_sfx := preload("res://addons/base_button/click.wav")

func _physics_process(delta: float) -> void:
	update_trajectory(delta)

func update_trajectory(delta):
	%line.clear_points()
	#%line.rotation = 
	var pos = $Launcher.global_position
	var vel = -$Launcher.global_transform.y * bullet_speed
	for i in max_points:
		%line.add_point(pos)
		
		vel.y += 980 * delta
		pos += vel * delta * speed_multiplier

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%shoot_button.button_pressed = false
	%cooldown.visible = false
	
	bullet_speed = default_bullet_speed
	rotate_shooter(3)

func rotate_shooter(duration : float):
	TweenUtility.custom_loop(self, "rotation_degrees", -70, 70, duration, duration)

func shoot(speed : float):
	# In the launcher script
	var bullet = bullet_scene.instantiate()
	bullet.global_position = launcher.global_position
	bullet.rotation = global_rotation
	get_tree().current_scene.add_child(bullet)

	# Pass the launcher's facing direction
	bullet.linear_velocity = -transform.y * speed
	bullet_speed = default_bullet_speed

func start_cooldown():
	var tween = create_tween()
	
	in_cooldown = true
	tween.tween_property(%cooldown, "value", 100, cooldown)
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false
	%cooldown.visible = false

func _on_shoot_button_button_up() -> void:
	if in_cooldown:
		return
	released_shoot()
	AudioUtility.add_sfx(self, shoot_sfx)

func holding_shoot():
	self.scale.x += 0.1
	self.scale.y = 0.8
	bullet_speed = default_bullet_speed * (self.scale.x * speed_multiplier)

func released_shoot():
	shoot(bullet_speed)
	%cooldown.value = 0
	%cooldown.visible = true
	start_cooldown()
	self.scale.x = 1
	self.scale.y = 1

func _process(_delta: float) -> void:
	if %shoot_button.button_pressed:
		holding_shoot()
