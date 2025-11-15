extends CanvasLayer



func show_overlay():
	visible = true
	$Control/TextureRect.show()
	$Control/TextureRect2.hide()


func hide_overlay():
	$Control/TextureRect.hide()
	$Control/TextureRect2.show()
	await get_tree().create_timer(1.5).timeout
	visible = false
	
