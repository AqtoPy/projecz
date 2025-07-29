extends Node

# Настройки
var sound_enabled: bool = true
var volume: float = 0.8

# Прогресс уровней
var unlocked_levels: int = 1  # Начинаем с 1 уровня

# Разблокирует следующий уровень
func unlock_level(level_num):
	if level_num > unlocked_levels:
		unlocked_levels = level_num
		save_progress()

# Сохранение в файл
func save_progress():
	var save_data = {
		"unlocked_levels": unlocked_levels,
		"sound_enabled": sound_enabled,
		"volume": volume
	}
	var file = FileAccess.open("user://savegame.dat", FileAccess.WRITE)
	file.store_var(save_data)

# Загрузка из файла
func load_progress():
	if FileAccess.file_exists("user://savegame.dat"):
		var file = FileAccess.open("user://savegame.dat", FileAccess.READ)
		var save_data = file.get_var()
		unlocked_levels = save_data["unlocked_levels"]
		sound_enabled = save_data["sound_enabled"]
		volume = save_data["volume"]
