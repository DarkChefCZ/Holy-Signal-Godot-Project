extends StaticBody3D

var symbols_parent_viewport: SubViewport
var symbols_children

func _ready() -> void:
	symbols_parent_viewport = find_child("SubViewportSymbol", true, true)
	symbols_children = symbols_parent_viewport.find_children("*", "TextureRect", true, false)


func _on_calculation_node_2_on_symbol(name_of_symbol: String) -> void:
	for symbol in symbols_children:
		if symbol.name == name_of_symbol and symbol.visible == false:
			symbol.visible = true


func _on_calculation_node_2_off_symbol(name_of_symbol: String) -> void:
		for symbol in symbols_children:
			if symbol.name == name_of_symbol and symbol.visible == true:
				symbol.visible = false
