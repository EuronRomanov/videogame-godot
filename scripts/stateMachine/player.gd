extends CharacterBody2D

@export_category("Movement Settings")
@export var run_speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 980.0

enum PlayerState {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	ATTACKING
}

var current_state: PlayerState = PlayerState.IDLE
var last_direction: int = 1  

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# ✅ Solo inicialización, sin conectar señales
	change_state(PlayerState.IDLE)

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Input (excepto durante ataque)
	if current_state != PlayerState.ATTACKING:
		handle_input()
		
	move_and_slide()
	update_state_based_on_physics()
	update_animation()

func update_state_based_on_physics():
	if current_state == PlayerState.ATTACKING:
		return
		
	if not is_on_floor():
		if velocity.y < 0:
			change_state(PlayerState.JUMPING)
		else:
			change_state(PlayerState.FALLING)
	else:
		if current_state in [PlayerState.JUMPING, PlayerState.FALLING]:
			# Aterrizó
			if abs(velocity.x) > 0:
				change_state(PlayerState.RUNNING)
			else:
				change_state(PlayerState.IDLE)
		elif current_state in [PlayerState.IDLE, PlayerState.RUNNING]:
			# En suelo
			if abs(velocity.x) > 0:
				change_state(PlayerState.RUNNING)
			else:
				change_state(PlayerState.IDLE)

func handle_input():
	var horizontal_input = 0
	
	if Input.is_action_pressed("move_right"):
		horizontal_input += 1
		last_direction = 1
		
	if Input.is_action_pressed("move_left"):
		horizontal_input -= 1
		last_direction = -1
		
	velocity.x = horizontal_input * run_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and current_state != PlayerState.ATTACKING:
		velocity.y = jump_velocity
		change_state(PlayerState.JUMPING)
		
	if Input.is_action_just_pressed("stop"):
		velocity.x = 0
		if is_on_floor() and current_state != PlayerState.ATTACKING:
			change_state(PlayerState.IDLE)
			
	if Input.is_action_just_pressed("attack") and is_on_floor() and current_state != PlayerState.ATTACKING:
		change_state(PlayerState.ATTACKING)
		velocity.x = 0

func update_animation():
	match current_state:
		PlayerState.ATTACKING:
			animated_sprite.play("attack")
		PlayerState.JUMPING:
			animated_sprite.play("jump")
		PlayerState.FALLING:
			animated_sprite.play("jump")
		PlayerState.RUNNING:
			if last_direction == 1:
				animated_sprite.play("run_right")
			else:
				animated_sprite.play("run_left")
		PlayerState.IDLE:
			animated_sprite.play("idle")

func change_state(new_state: PlayerState):
	if current_state == new_state:
		return
	
	current_state = new_state

func state_to_string(state: PlayerState) -> String:
	match state:
		PlayerState.IDLE: return "IDLE"
		PlayerState.RUNNING: return "RUNNING"
		PlayerState.JUMPING: return "JUMPING"
		PlayerState.FALLING: return "FALLING"
		PlayerState.ATTACKING: return "ATTACKING"
		_: return "UNKNOWN"

# ✅ NOMBRE CORREGIDO - igual al que conectaste visualmente
func _on_animation_finished() -> void:
	if current_state == PlayerState.ATTACKING:
		if is_on_floor():
			if abs(velocity.x) > 0:
				change_state(PlayerState.RUNNING)
			else:
				change_state(PlayerState.IDLE)
		else:
			if velocity.y < 0:
				change_state(PlayerState.JUMPING)
			else:
				change_state(PlayerState.FALLING)
