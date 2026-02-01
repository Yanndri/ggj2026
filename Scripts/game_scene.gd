extends Node2D

func _ready() -> void:
	GameManager.connect("game_over", func(): %GameOver.visible = true)
	%GameOver.visible = false
	%MainMenu.visible = true
	%UI.visible = false
	%settings.visible = true
	
	GameManager.score = 0

func start():
	%NpcSpawnerArea.start()
	%GameOver.visible = false
	%MainMenu.visible = false
	%UI.visible = true

func restart():
	get_tree().reload_current_scene() 

func _on_restart_pressed() -> void:
	restart()

func _on_new_game_pressed() -> void:
	start()
