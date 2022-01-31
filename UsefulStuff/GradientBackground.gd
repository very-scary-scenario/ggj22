extends Node2D

export var colour1 : Color
export var colour2 : Color
export var block_size = 40

var diff_r
var diff_g
var diff_b
var blocks_x
var blocks_y

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 0
	position.y = 0
	var vpsize = get_viewport().size
	blocks_x = int(vpsize.x / block_size)
	if (int(vpsize.x) % block_size) > 0:
		blocks_x = blocks_x + 1

	blocks_y = int(vpsize.y / block_size)
	if (int(vpsize.y) % block_size) > 0:
		blocks_y = blocks_y + 1
		
	diff_r = (colour1.r - colour2.r) / blocks_y
	diff_g = (colour1.g - colour2.g) / blocks_y
	diff_b = (colour1.b - colour2.b) / blocks_y
#	print(colour1.r, " , ", colour1.g, " , ", colour1.b)
#	print(colour2.r, " , ", colour2.g, " , ", colour2.b)
#	print(diff_r, " , ", diff_g, " , ", diff_b)
	
func _draw():
	var curr_color = colour2
	for xy in blocks_y:
		for xs in blocks_x:
			var rect = Rect2(Vector2(xs * block_size, xy * block_size) , Vector2(block_size, block_size))
			draw_rect(rect, curr_color, true)
		curr_color = Color(curr_color.r + diff_r, curr_color.g + diff_g, curr_color.b + diff_b, 1)
