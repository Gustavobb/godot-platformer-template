extends Node

func _ready():
	_play_random()
	
func _play_random():
	var music = 3
	
	if music == 1: $Music01.play()
	if music == 2: $Music02.play()
	if music == 3: $Music03.play()
	
func _on_Music01_finished():
	_play_random()

func _on_Music03_finished():
	_play_random()

func _on_Music02_finished():
	_play_random()
