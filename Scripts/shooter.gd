extends Sprite2D

@export var launcher : Marker2D
@export var bullet_scene : PackedScene
@export var shooter_animations : AnimationPlayer
@export var cooldown : float = 0.2
@export var default_bullet_speed : float = 100

var in_cooldown : bool
var bullet_speed : float

var max_points = 10.0

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
		pos += vel * delta * 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	print("speed: ", speed)
	bullet_speed = default_bullet_speed

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("interact"):
		self.scale.x += 0.2
		self.scale.y = 0.8
		bullet_speed = default_bullet_speed * (self.scale.x * 5)
	if Input.is_action_just_released("interact"):
		shoot(bullet_speed)
		self.scale.x = 1
		self.scale.y = 1
	#if Input.is_action_just_pressed("interact"):
		#shooter_animations.play("shoot")
		#if not in_cooldown:
			#shoot()
			#start_cooldown()

func start_cooldown():
	in_cooldown = true
	await get_tree().create_timer(cooldown).timeout
	in_cooldown = false
