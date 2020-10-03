extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var camera = get_parent()
onready var frequency_timer = $Frequency
onready var duration_timer = $Duration
onready var shake_tween = $ShakeTween

var amplitude = 0
var priority = 0

func start(dur = 0.1, freq = 100, ampl = 0.2, prior = 0):
	if prior >= self.priority:
		self.priority = prior
		self.amplitude = ampl
		duration_timer.wait_time = dur
		frequency_timer.wait_time = 1 / float(freq)
		duration_timer.start()
		frequency_timer.start()

		_shake()

func _shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	shake_tween.interpolate_property(camera, "offset", camera.offset, rand, frequency_timer.wait_time, TRANS, EASE)
	shake_tween.start()

func _reset():
	shake_tween.interpolate_property(camera, "offset", camera.offset, Vector2(), frequency_timer.wait_time, TRANS, EASE)
	shake_tween.start()
	
	priority = 0

func _ready():
	pass

func _on_Frequency_timeout():
	_shake()

func _on_Duration_timeout():
	_reset()
	frequency_timer.stop()
