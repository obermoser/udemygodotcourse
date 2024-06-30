extends Bulletin

var prompt_text := ""

func _ready() -> void:
	$Label.text = prompt_text	


func initialize(prompt) -> void:
	if prompt is String:
		prompt_text = prompt
