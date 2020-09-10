extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", self, "_on_button_down")

func _on_button_down():
	if not $Devs.visible:
		$Devs.show()
		$Memoria.show()
		get_node("../MarginContainer/VBoxMain/CenterLogo").hide()
		get_node("../MarginContainer/VBoxMain/HBoxContainer").hide()
	else:
		$Devs.hide()
		$Memoria.hide()
		get_node("../MarginContainer/VBoxMain/CenterLogo").show()
		get_node("../MarginContainer/VBoxMain/HBoxContainer").show()



