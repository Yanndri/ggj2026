extends Area2D

@export var food_textures : Array[CompressedTexture2D]

func _ready() -> void:
	$Sprite2D.texture = food_textures.pick_random()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		GameManager.contaminationProgress -= 10
		self.queue_free()

#func randomize_food():
	
