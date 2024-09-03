extends Area2D

const HitEffect = preload("res://Effects/hit_effect.tscn")
@onready var timer: Timer = $Timer
@export var show_hit = true
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var invincible = false : set = set_invincible
signal invincibility_start
signal invincibility_ended
func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_start")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)




func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	
	effect.global_position = global_position


func _on_timer_timeout() -> void:
	self.invincible = false


func _on_invincibility_start() -> void:
	collision_shape_2d.set_deferred("disabled" , true)


func _on_invincibility_ended() -> void:
	collision_shape_2d.disabled = false


func _on_area_entered(area: Area2D) -> void:
	if show_hit:
		create_hit_effect()
	
