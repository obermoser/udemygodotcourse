extends Bulletin

var prompt_text := ""

func _ready() -> void:
	$Label.text = prompt_text	

#region Prompt Text
func initialize(prompt) -> void:
	if prompt is String:
		prompt_text = prompt
#endregion
