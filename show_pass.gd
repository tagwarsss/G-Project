extends Node2D

@onready var password_field: LineEdit = $PasswordField
@onready var eye_button: TextureButton = $EyeButton

func _on_eye_button_toggled(toggled_on: bool) -> void:
	password_field.secret = not toggled_on
