extends Camera2D

onready var level = get_parent().get_parent()

func _ready():
	limit_top = level.get_node("Limits/TopLeft").position.y
	limit_left = level.get_node("Limits/TopLeft").position.x
	limit_bottom = level.get_node("Limits/BottomRight").position.y
	limit_right = level.get_node("Limits/BottomRight").position.x
