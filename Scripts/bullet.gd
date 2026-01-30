extends RigidBody2D

@export var speed : float = 2000

func _ready() -> void:
	#velocity = Vector2.RIGHT.rotated(rotation) * SPEED
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed

	start_lifespan(2)

func start_lifespan(lifespan : float):
	await get_tree().create_timer(lifespan).timeout
	self.queue_free()
func _on_bullet_area_body_entered(body: Node2D) -> void:
	
	body.queue_free()
	self.queue_free()

func _physics_process(delta: float) -> void:
	rotation += 1
