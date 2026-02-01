extends Node

signal on_contamination_progress_update(progress: int)
signal game_over
signal score_changed(score : int)

var score : int :
	set(value):
		score = value
		emit_signal("score_changed", score)

var is_game_over : bool :
	set(value):
		is_game_over = value
		if is_game_over:
			emit_signal("game_over")

var contaminationProgress: float :
	set(value):
		if value > 100: 
			is_game_over = true
			return
		contaminationProgress = value
		emit_signal("on_contamination_progress_update", contaminationProgress)
