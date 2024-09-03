extends Node

@export var max_health = 1 : set = set_max_health
@onready var health = max_health : set = set_health

signal  no_health
signal health_change(value)
signal max_health_change(value)

func set_max_health(value):
	max_health = value

	emit_signal("max_health_change")


func set_health(value):
	health = value
	emit_signal("health_change",health)
	if health <= 0:
		emit_signal("no_health")
