extends Node
class_name Stopwatch

var time:float = 0.0
var stopped:bool = false

func _physics_process(delta):
	if stopped:
		return
	else:
		time += delta

func time_to_string() -> String:
	var sec = fmod(time, 60)
	var min = time / 60
	var format = '%02d : %02d'
	var result = format % [min, sec]

	return result
