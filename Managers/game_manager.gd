extends Node

signal on_contamination_progress_update(progress: int)

@export var contaminationProgress: int


func addContaminationProgress() -> void:
	contaminationProgress += 1
	on_contamination_progress_update.emit(contaminationProgress)
	print('contamination progree', contaminationProgress/100)

func getContaminationProgress() -> int:
	return contaminationProgress / 100
