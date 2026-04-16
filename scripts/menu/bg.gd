
extends TextureRect

@export var texture_size := Vector2(5000, 5000)
@export var zoom := 2.5

func _ready():
	randomize()

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_SCALE

	var atlas = AtlasTexture.new()
	atlas.atlas = preload("res://Ruff_Rogue-main/3_Graphics/Dungeon/Background.png")

	var screen_size = get_viewport_rect().size

	var view_size = screen_size * zoom

	var max_x = max(0, texture_size.x - view_size.x)
	var max_y = max(0, texture_size.y - view_size.y)

	var offset = Vector2(
		randi_range(0, int(max_x)),
		randi_range(0, int(max_y))
	)

	atlas.region = Rect2(offset, view_size)

	texture = atlas
