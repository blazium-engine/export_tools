@tool
class_name CheckerStyleBox
extends StyleBox

var needs_update: bool = true

@export var visible: bool = true:
	set(value):
		if value != visible:
			visible = value
			update()

@export_range(1, 64) var checker_size: int = 64:
	set(value):
		if value != checker_size:
			checker_size = value
			update()

@export_color_no_alpha var checker_light_color: Color = Color(0.8, 0.8, 0.8):
	set(value):
		value.a = 1.0
		if value != checker_light_color:
			checker_light_color = value
			update()

@export_color_no_alpha var checker_dark_color: Color = Color(0.4, 0.4, 0.4):
	set(value):
		value.a = 1.0
		if value != checker_dark_color:
			checker_dark_color = value
			update()

@export_range(1, 16) var scale: int = 1:
	set(value):
		if value != scale:
			scale = value
			update()

@export_group("Grow")

@export_range(0, 16) var grow_left: int = 0:
	set(value):
		if value != grow_left:
			grow_left = value
			update()

@export_range(0, 16) var grow_top: int = 0:
	set(value):
		if value != grow_top:
			grow_top = value
			update()

@export_range(0, 16) var grow_right: int = 0:
	set(value):
		if value != grow_right:
			grow_right = value
			update()

@export_range(0, 16) var grow_bottom: int = 0:
	set(value):
		if value != grow_bottom:
			grow_bottom = value
			update()

var texture : ImageTexture


func set_grow_all(value: int) -> void:
	grow_left = value
	grow_top = value
	grow_right = value
	grow_bottom = value


func update() -> void:
	if not needs_update:
		needs_update = true
		emit_changed()


func color_to_html(color: Color) -> String:
	var c: String = color.to_html(false)
	if c[0] == c[1] and c[2] == c[3] and c[4] == c[5]:
		c = c[0] + c[2] + c[4]
	return "#" + c


func _draw(rid: RID, rect: Rect2) -> void:
	if not visible:
		needs_update = false
		return
	# Generate texture.
	if needs_update:
		var svg: String = "<svg width=\"%s\" height=\"%s\" xmlns=\"http://www.w3.org/2000/svg\">" % [checker_size * 2, checker_size * 2]
		svg += "<rect x=\"0\" y=\"0\" width=\"%s\" height=\"%s\" fill=\"%s\"/>" % [checker_size, checker_size, color_to_html(checker_light_color)]
		svg += "<rect x=\"%s\" y=\"0\" width=\"%s\" height=\"%s\" fill=\"%s\"/>" % [checker_size, checker_size, checker_size, color_to_html(checker_dark_color)]
		svg += "<rect x=\"%s\" y=\"%s\" width=\"%s\" height=\"%s\" fill=\"%s\"/>" % [checker_size, checker_size, checker_size, checker_size, color_to_html(checker_light_color)]
		svg += "<rect x=\"0\" y=\"%s\" width=\"%s\" height=\"%s\" fill=\"%s\"/>" % [checker_size, checker_size, checker_size, color_to_html(checker_dark_color)]
		svg += "</svg>"
		var img: Image = Image.new()
		var _err: int = img.load_svg_from_string(svg, scale)
		texture = ImageTexture.create_from_image(img)
		needs_update = false
	RenderingServer.canvas_item_add_texture_rect(rid, _get_draw_rect(rect), texture.get_rid(), true)


func _get_draw_rect(rect: Rect2) -> Rect2:
	return rect.grow_individual(grow_left, grow_top, grow_right, grow_bottom)
