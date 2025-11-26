extends CanvasLayer

@onready var video_player = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		jump_cinematic()
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F:
			jump_cinematic()
	if event is InputEventMouseButton and event.pressed:
		jump_cinematic()



func jump_cinematic() -> void:
	if video_player.is_playing():
		video_player.stop()
	go_to_game()

func _on_video_finished() -> void:
	go_to_game() # Replace with function body.

func go_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")
