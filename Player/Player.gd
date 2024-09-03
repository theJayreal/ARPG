extends CharacterBody2D
@export var MAX_SPEED =  100
@export var ACCELERATION =400
@export var FRICTION = 400
@export var RollSpeed = 1.5
const   PlayerHurtSound = preload("res://Player/play_hurt_sound.tscn")
enum{
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var stats =PlayerStats
var roll_vector = Vector2.DOWN
var Velocity =Vector2.ZERO
var input_vector = Vector2.ZERO
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animationstate = animation_tree.get("parameters/playback")   
@onready var sword_hitbox: Area2D = $HitPivot/SwordHitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer


func _ready() -> void:
	stats.no_health.connect(queue_free)           #玩家没有血量就消失
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector
	
func _process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	
	

func move_state(delta):                              # 人物移动代码
	
	input_vector.x = Input.get_action_strength('right')-Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength('down')-Input.get_action_strength("up")
	input_vector = input_vector.normalized()               #保持速度一致
	if (input_vector != Vector2.ZERO):
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position",input_vector)
		animation_tree.set("parameters/Run/blend_position",input_vector)
		animation_tree.set("parameters/Attack/blend_position",input_vector)
		animation_tree.set("parameters/Roll/blend_position",input_vector)
		animationstate.travel("Run")
		Velocity = Velocity.move_toward(input_vector*MAX_SPEED,ACCELERATION)*delta
	else:
		Velocity = Velocity.move_toward(Vector2.ZERO,FRICTION*delta*MAX_SPEED)
		animationstate.travel("Idle")
	move()
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
func attack_state(delta):
	Velocity = Vector2.ZERO
	animationstate.travel("Attack")
	
func move():
	move_and_collide(Velocity)
	
	
func roll_state(delta):
	Velocity = roll_vector*RollSpeed   
	animationstate.travel("Roll")
	move()
func roll_animation_finish():
	Velocity = Velocity*0.4
	state = MOVE
	
func attack_animation_finished():
	state = MOVE	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect() 
	var playerHurtSounds = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSounds)
	


func _on_hurtbox_invincibility_start() -> void:
	blink_animation_player.play("Start")


func _on_hurtbox_invincibility_ended() -> void:
	blink_animation_player.play("Stop")
