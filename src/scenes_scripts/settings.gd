extends CanvasLayer



@export var isMusic = true

@export var isSFX = true


func _on_music_button_pressed() -> void:
	isMusic = !isMusic
	$"../BackgroundAudio".volume_db = -100 if !isMusic else 5


func _on_sfx_button_pressed() -> void:
	isSFX = !isSFX
	$"../CharacterBody2D/SFXAudio".volume_db = -100 if !isSFX else -10
	$"../CharacterBody2D/FootstepAudio".volume_db = -100 if !isSFX else 5
	$"../CharacterBody2D/LostItemSFX".volume_db = -100 if !isSFX else 0
