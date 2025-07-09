@tool
class_name IconRect
extends TextureRect


func _validate_property(property: Dictionary) -> void:
    if property["name"] == "texture":
        property["usage"] = PROPERTY_USAGE_NONE
