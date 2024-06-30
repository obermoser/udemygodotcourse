extends RayCast3D

var is_hitting:=false

func check_interaction()->void:
	if is_colliding():
		var collider := get_collider()
		if !collider is Interactable:
			return
		
		if Input.is_action_just_pressed("interact"):
			collider.start_interaction()
		
		if !is_hitting:
			is_hitting = true
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.InteractionPrompt, collider.prompt)
	elif is_hitting:
		is_hitting = false
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.InteractionPrompt)
