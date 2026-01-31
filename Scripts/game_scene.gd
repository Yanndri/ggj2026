extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MainMenu.visible = true

func _on_new_game_pressed() -> void:
	%MainMenu.visible = false
