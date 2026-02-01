extends RichTextEffect

const HALFPI = PI / 2.0
const SPACE = ord(" ")

func get_color(s) -> Color:
	if s is Color:
		return s
	elif s[0] == '#':
		return Color(s)
	else:
		return Color(s)

# Consistent seed value for randomized animations
func get_rand(char_fx: CharFXTransform) -> float:
	return fmod(get_rand_unclamped(char_fx), 1.0)

func get_rand_unclamped(char_fx: CharFXTransform) -> float:
	return char_fx.character * 33.33 + char_fx.absolute_index * 4545.5454

func get_rand_time(char_fx: CharFXTransform, time_scale := 1.0) -> float:
	return char_fx.character * 33.33 \
		+ char_fx.absolute_index * 4545.5454 \
		+ char_fx.elapsed_time * time_scale

# Replacement for get_tween_data().get_t()
# Returns a normalized [0..1] value based on elapsed_time and duration
func get_t(char_fx: CharFXTransform, duration := 1.0) -> float:
	var t = char_fx.elapsed_time / duration
	return clamp(t, 0.0, 1.0)
