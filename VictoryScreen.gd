extends CanvasLayer

var current_level = "Level1"

func _ready():
	# Если это последний уровень, скрываем кнопку "Следующий уровень"
	if current_level == "Level10":
		$NextLevelButton.hide()

func _on_next_level_pressed():
	var next_level = current_level.replace("Level", "").to_int() + 1
	var next_level_path = "res://scenes/levels/Level%d.tscn" % next_level
	
	# Разблокируем следующий уровень
	Settings.unlock_level(next_level)
	
	get_tree().paused = false
	get_tree().change_scene_to_file(next_level_path)

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
