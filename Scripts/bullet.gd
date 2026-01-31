extends RigidBody2D

var trail : Line2D

func _ready() -> void:
	$bullet_particles.rotation = rotation
	start_lifespan(4)

func start_lifespan(lifespan : float):
	await get_tree().create_timer(lifespan).timeout
	self.queue_free()
	
func _on_bullet_area_body_entered(body: Node2D) -> void:
	body.queue_free()
	self.queue_free()

#func _physics_process(delta: float) -> void:
	#rotation += 0.1
