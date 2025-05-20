extends Camera2D

# Movement speed of the camera
@export var speed := 400.0

func _process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_axis('Left', 'Right')
	input_vector.y = Input.get_axis('Up', 'Down')
	
	input_vector = input_vector.normalized()
	
	# Move the camera position
	global_position += input_vector * speed * delta

	# Clamp the camera within limits
	global_position.x = clamp(global_position.x, limit_left + 320, limit_right - 320)
	global_position.y = clamp(global_position.y, limit_top + 180, limit_bottom - 180)
