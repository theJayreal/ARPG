extends Node2D
const  GrassEffect = preload("res://Effects/grass_effect.tscn")
func create_grass_effect():
	
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_hurtbox_area_entered(area: Area2D) -> void:
	create_grass_effect()
	queue_free()
