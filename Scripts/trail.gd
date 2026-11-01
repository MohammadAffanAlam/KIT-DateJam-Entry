extends Line2D

var length = 5
var point

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = Vector2(0, 0)
	global_rotation = 0
	point = get_parent().global_position
	add_point(point)
	
	while get_point_count() > length:
		remove_point(0)
