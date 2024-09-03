extends Node2D

@onready var start_position = global_position
@onready var target_position = global_position
@export  var  wander_range : int = 128
@onready var timer: Timer = $Timer
func updata_target_positon():
	var target_vertor = Vector2(randi_range( -wander_range, wander_range),randi_range(-wander_range, wander_range))
	target_position = start_position + target_vertor
func _on_timer_timeout() -> void:
	updata_target_positon()
	
func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)
	
