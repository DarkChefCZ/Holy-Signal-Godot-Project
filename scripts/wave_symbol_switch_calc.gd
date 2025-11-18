extends Node

signal on_symbol
signal off_symbol

func execute(percentage: float, switchName: String):
	var name_of_symbol = switchName.replace("zero_one_switch_", "")
	
	if percentage > 0.9:
		emit_signal("on_symbol", name_of_symbol)
	else:
		emit_signal("off_symbol", name_of_symbol)
