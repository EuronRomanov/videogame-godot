extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cinematic/intro_cinematic.tscn") # Replace with function body.


func _on_btn_controles_pressed() -> void:
	pass # Replace with function body.


func _on_btn_salir_pressed() -> void:
	get_tree().quit() # Replace with function body.
