extends CharacterBody2D

@export var run_speed := 300.0
@export var jump_velocity := -400.0
@export var gravity := 980.0

enum PlayerState {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	ATTACKING
}

var current_state: PlayerState = PlayerState.IDLE
var last_direction := 1
var input_dir := 0.0
var current_anim := ""

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	set_state(PlayerState.IDLE)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if current_state == PlayerState.ATTACKING:
		move_and_slide()
		return

	handle_input()
	update_state_based_on_physics()
	move_and_slide()


# =====================
# INPUT
# =====================
func handle_input():
	input_dir = Input.get_axis("move_left", "move_right")

	if input_dir != 0:
		last_direction = 1 if input_dir > 0 else -1

	velocity.x = input_dir * run_speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		set_state(PlayerState.JUMPING)

	if Input.is_action_just_pressed("attack") and is_on_floor():
		velocity.x = 0
		set_state(PlayerState.ATTACKING)


# =====================
# FSM
# =====================
func update_state_based_on_physics():
	if not is_on_floor():
		if velocity.y < 0:
			set_state(PlayerState.JUMPING)
		else:
			set_state(PlayerState.FALLING)
	else:
		if input_dir != 0:
			set_state(PlayerState.RUNNING)
		else:
			set_state(PlayerState.IDLE)


func set_state(new_state: PlayerState):
	if current_state == new_state:
		return

	current_state = new_state

	match current_state:
		PlayerState.IDLE:
			play_anim("idle")

		PlayerState.RUNNING:
			play_anim("run_right" if last_direction == 1 else "run_left")

		PlayerState.JUMPING, PlayerState.FALLING:
			play_anim("jump")

		PlayerState.ATTACKING:
			play_anim("attack")


# =====================
# ANIMACIONES
# =====================
func play_anim(anim_name: String):
	if current_anim == anim_name:
		return

	current_anim = anim_name
	animated_sprite.play(anim_name)


# =====================
# SEÑAL FIN DE ANIMACIÓN
# =====================
func _on_animated_sprite_2d_animation_finished() -> void:
	if current_state != PlayerState.ATTACKING:
		return

	if not is_on_floor():
		set_state(PlayerState.FALLING)
	elif input_dir != 0:
		set_state(PlayerState.RUNNING)
	else:
		set_state(PlayerState.IDLE)
