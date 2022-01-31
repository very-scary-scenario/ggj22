extends Node2D

export var font_name = ""
export var font_width = 0
export var font_height = 0
export var per_line = 0
export var test_texture : ImageTexture
export var center_just = true
var font_image
export var text_display = "ABCDEFG"
var rendered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	font_image = ImageTexture.new()
#	font_image.load(font_name)
	font_image = test_texture

func _process(_delta):
	update()

func _draw():
	if not rendered:
		var string_num = text_display.to_upper().to_ascii()
		#var draw_x = 0
		if center_just:
			var draw_x = - ((text_display.length() / 2) * font_width)
			#print(text_display.length())
			for c in string_num:
				var font_x = (c - 32) % per_line
				var font_y = ((c - 32) - font_x) / per_line
				font_x = font_x * font_width
				font_y = font_y * font_height
		#		node.draw_texture_rect_region(font_image, Rect2(Vector2(draw_x, 0), Vector2(draw_x + font_width, font_height)), Rect2(Vector2(font_x, font_y),Vector2(font_x + font_width, font_y + font_height)))
				self.draw_texture_rect_region(font_image, Rect2(Vector2(draw_x, 0), Vector2(font_width, font_height)), Rect2(Vector2(font_x, font_y),Vector2(font_width, font_height)), Color.white)
				draw_x = draw_x + font_width
		else:
			var draw_x = 0
			#print(text_display.length())
			for c in string_num:
				var font_x = (c - 32) % per_line
				var font_y = ((c - 32) - font_x) / per_line
				font_x = font_x * font_width
				font_y = font_y * font_height
		#		node.draw_texture_rect_region(font_image, Rect2(Vector2(draw_x, 0), Vector2(draw_x + font_width, font_height)), Rect2(Vector2(font_x, font_y),Vector2(font_x + font_width, font_y + font_height)))
				self.draw_texture_rect_region(font_image, Rect2(Vector2(draw_x, 0), Vector2(font_width, font_height)), Rect2(Vector2(font_x, font_y),Vector2(font_width, font_height)), Color.white)
				draw_x = draw_x + font_width
			
			
	rendered = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
