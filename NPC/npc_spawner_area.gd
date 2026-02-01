extends Node2D

@export var spawn_area: CollisionShape2D 
@export_range(1, 10) var spawn_timer: int = 2
@onready var NPC: PackedScene = preload("res://NPC/NPC.tscn")

var shape 
var center 
var random_x 
var random_y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if not spawn_area:
		return
	
	for i in range(5, 10, 2):
		spawn_npc()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func spawn_npc() -> void:
	randomize()
	
	shape = spawn_area.shape.extents
	center = spawn_area.global_position
	random_x = randf_range(center.x - shape.x, center.x + shape.x)
	random_y = randf_range(center.y - shape.y, center.y + shape.y)
	
	if not random_x and not random_y: 
		return
	
	var npc = NPC.instantiate()
	npc.platform_area = spawn_area
	npc.global_position = Vector2(random_x+50, random_y+50)
	add_child(npc)
	
func _on_npc_spawn_timer_timeout() -> void:
	spawn_npc()
