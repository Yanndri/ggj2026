class_name TweenUtility

static func custom_loop(owner : Node, property : String, value1 : float, value2 : float,  duration1 : float, duration2 : float):
	var tween = owner.create_tween()
	tween.set_loops()  # infinite loop
	
	#bob down
	tween.tween_property(owner, property, value1, duration1)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	#the '\' allows for newline, so that it's more readable
	
	#bob up
	tween.tween_property(owner, property, value2, duration2).\
	set_trans(Tween.TRANS_SINE).\
	set_ease(Tween.EASE_IN_OUT)

static func bob_up_and_down(owner : Node, bob_force : float, up_duration : float, down_duration : float):
	var tween = owner.create_tween()
	tween.set_loops()  # infinite loop
	
	#bob down
	tween.tween_property(owner, "position:y", owner.position.y + bob_force, down_duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	#the '\' allows for newline, so that it's more readable
	
	#bob up
	tween.tween_property(owner, "position:y", owner.position.y - bob_force, up_duration).\
	set_trans(Tween.TRANS_SINE).\
	set_ease(Tween.EASE_IN_OUT)

#Change the transparency of a node
static func fade_in_or_out(owner : Node, _start_value : float, final_value : float,  transition_duration : float):
	var tween = owner.create_tween()
	
	tween.tween_property(owner, "modulate:a", final_value, transition_duration)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_IN_OUT)
	#the '\' allows for newline, so that it's more readable
	
	return await tween.finished #This emits true when the tween is finished

static func damage_overlay(owner : Node, start_value : float, final_value : float,  duration : float):
	owner.visible = true
	
	await fade_in_or_out(owner, start_value, final_value, 0.2) #fade in to view
	
	await owner.get_tree().create_timer(duration).timeout
	
	await fade_in_or_out(owner, final_value, start_value, 0.3) #fade out to view
	
	owner.visible = false
