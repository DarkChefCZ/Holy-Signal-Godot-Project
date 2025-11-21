extends Node3D

@export var StreamPlayer: AudioStreamPlayer3D

@export var HoverSFX: AudioStreamWAV
@export var ClickSFX: AudioStreamWAV




func _on_play_button_mouse_entered() -> void:
	if StreamPlayer.playing == true:
		StreamPlayer.playing = false
	
	StreamPlayer.stream = HoverSFX
	StreamPlayer.playing = true


func _on_play_button_button_down() -> void:
	if StreamPlayer.playing == true:
		StreamPlayer.playing = false
	
	StreamPlayer.stream = ClickSFX
	StreamPlayer.playing = true


func _on_quit_button_mouse_entered() -> void:
	if StreamPlayer.playing == true:
		StreamPlayer.playing = false
	
	StreamPlayer.stream = HoverSFX
	StreamPlayer.playing = true


func _on_quit_button_button_down() -> void:
	if StreamPlayer.playing == true:
		StreamPlayer.playing = false
	
	StreamPlayer.stream = ClickSFX
	StreamPlayer.playing = true
