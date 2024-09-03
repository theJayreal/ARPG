
extends CharacterBody2D
var Velocity = Vector2.ZERO
@export var ACCELERATION = 300
@export  var MAX_SPEED = 50
@export var FRICTION = 100

var knockback = Vector2.ZERO
const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@onready var soft_collision: Area2D = $SoftCollision
@onready var hurtbox: Area2D = $Hurtbox

@onready var playerDetectionZone = $PlayerDetectionZone
@onready var stats: Node = $Stats
@onready var sprite: AnimatedSprite2D = $AnimationSprite
@onready var wander_controller: Node2D = $WanderController
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}	

var state = CHASE
func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO,FRICTION*delta)
	velocity = knockback
	
	
	
	match state:
		IDLE:
			Velocity = Velocity.move_toward(Vector2.ZERO,FRICTION*delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE , WANDER])
				wander_controller.start_wander_timer(randi_range(1,3))
				
		WANDER:
			
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE , WANDER])
				wander_controller.start_wander_timer(randi_range(1,3))
				
			var direction = global_position.direction_to(wander_controller.target_position)
			velocity = velocity.move_toward(direction*MAX_SPEED,ACCELERATION*delta)
			move_and_slide()
			
		CHASE:
			var player = playerDetectionZone.player
			
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction*MAX_SPEED,ACCELERATION)
				
			else:
				state = IDLE
			sprite.flip_h = velocity.x<0
				
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	move_and_slide()
				


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()	


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	stats.health -= area.damage
	knockback = area.knockback_vector*80
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)


func _on_stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	
	
	


func _on_hurtbox_invincibility_start() -> void:
	animation_player.play("Start")


func _on_hurtbox_invincibility_ended() -> void:
	animation_player.play("Stop")
