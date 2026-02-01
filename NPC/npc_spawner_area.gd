extends Node2D

@export var spawn_area: Array[CollisionShape2D]
@export var roaming_area : CollisionShape2D
@export_range(1, 10) var spawn_timer: int = 2
@onready var NPC: PackedScene = preload("res://NPC/NPC.tscn")

var shape 
var center 
var random_x 
var random_y

# Called when the node enters the scene tree for the first time.
func start() -> void:
	%NPCSpawnTimer.start()
	if not spawn_area or not roaming_area:
		return
	
	for i in range(5, 10, 2):
		spawn_npc()

func spawn_npc() -> void:
	randomize()
	
	var chosen_spawn_area : CollisionShape2D = spawn_area.get(randi_range(0, spawn_area.size()-1))
	shape = chosen_spawn_area.shape.extents
	center = chosen_spawn_area.global_position
	
	random_x = randf_range(center.x - shape.x, center.x + shape.x)
	random_y = randf_range(center.y - shape.y, center.y + shape.y)
	
	if not random_x and not random_y: 
		return
	
	var npc = NPC.instantiate()
	npc.platform_area = roaming_area
	npc.global_position = Vector2(random_x, random_y)
	add_child(npc)
	
func _on_npc_spawn_timer_timeout() -> void:
	spawn_npc()
