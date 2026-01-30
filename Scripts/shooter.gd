extends Sprite2D

@export var launcher : Marker2D
@export var bullet_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate_shooter(5)

func rotate_shooter(duration : float):
	TweenUtility.custom_loop(self, "rotation_degrees", -70, 70, duration, duration)

func shoot():
	# In the launcher script
	var bullet = bullet_scene.instantiate()
	bullet.global_position = launcher.global_position
	bullet.rotation = global_rotation
	get_tree().current_scene.add_child(bullet)

	# Pass the launcher's facing direction
	bullet.linear_velocity = -transform.y * bullet.speed

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		shoot()
