extends Node2D

export var trans_colour : Color
export var trans_timer = 120
export var block_size = 40
export var larger_block_size = 5

export var blanked = true
var display_array = []
var blocks_x
var blocks_y
var in_transition = false
var transition_line = 0

enum {REVEALING, HIDING, NOTHING}
enum {EVEN, UNEVEN, RANDOM, DBLINWARD, DBLOUTWARD, RNDLINE, BLKOPP, BLKOPPSIDE, BLKSAME, BLKSAMESIDE, VERTALT, BLKDIAG, VERTALT2, SMLDIAG, BIGDIAG, SMLINTERVAL, BIGINTERVAL, ALTBOX, ALTBOXALT, ALTBOX2, ALTBOXALT2, ALTBOX3, ALTBOXALT3, BOXSHRINK, BOXGROW, BOXALT, BOXALT4}
var state = NOTHING
var vary_array = []
var dissolve_type = EVEN

var larger_block_trans_ticker = 0
var larger_block_x
var larger_block_y

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var vpsize = get_viewport().size
	blocks_x = int(vpsize.x / block_size)
	if (int(vpsize.x) % block_size) > 0:
		blocks_x = blocks_x + 1

	blocks_y = int(vpsize.y / block_size)
	if (int(vpsize.y) % block_size) > 0:
		blocks_y = blocks_y + 1
	
	for xs in blocks_x:
		vary_array.append(0)
		for xy in blocks_y:
			if blanked:
				display_array.append(true)
			else:
				display_array.append(false)
			
	larger_block_trans_ticker = int(blocks_y / larger_block_size)
	larger_block_x = int(blocks_x / larger_block_size)
	larger_block_y = int(blocks_y / larger_block_size)
	
#	bigger_blocks_y = 4
#	bigger_blocks_x = blocks_x / (blocks_y / bigger_blocks_y)
	
#	print(blocks_x, ",", blocks_y)
#	print(bigger_blocks_x, ",", bigger_blocks_y)
#	print (larger_block_x, "  ,  ",  larger_block_y,  "   ,   ", blocks_x, " , ", blocks_y, ", ", display_array.size())

func flip_block(x, y, width, height):
	#print(x + (y * width), "  ,  ", x, "  ,  ", y, "  ,  ", width)	
	if x >= 0 and x < width:
		if y>=0 and y < height:
			display_array[x + (y * width)] = not display_array[x + (y * width)]

func set_block (x, y, width, height, switch_to):
	#print(x + (y * width), "  ,  ", x, "  ,  ", y, "  ,  ", width)	
	if x >= 0 and x < width:
		if y>=0 and y < height:
			display_array[x + (y * width)] = switch_to
	
func _draw():
	if blanked:
		for xs in blocks_x:
			for xy in blocks_y:
				if display_array[xs + (xy * blocks_x)]:
					var rect = Rect2(Vector2(xs * block_size, xy * block_size) , Vector2(block_size, block_size))
					draw_rect(rect, trans_colour, true)

func _process(_delta):
	if not state == NOTHING:
		if dissolve_type in [EVEN, UNEVEN]:
			process_vert_swipe()
		elif dissolve_type == RANDOM:
			process_random_dissolve()
		elif dissolve_type == DBLINWARD:
			process_double_swipe_inward()
		elif dissolve_type == DBLOUTWARD:
			process_double_swipe_outward()
		elif dissolve_type == RNDLINE:
			process_random_line()
		elif dissolve_type == BLKOPP:
			process_smaller_squares_opposing_directions()
		elif dissolve_type == BLKOPPSIDE:
			process_smaller_squares_opposing_sideways_directions()	
		elif dissolve_type == BLKSAME:
			process_smaller_squares_same_directions()	
		elif dissolve_type == BLKSAMESIDE:
			process_smaller_squares_same_sideways_directions()	
		elif dissolve_type == VERTALT:
			process_vert_swipe_alternating()	
		elif dissolve_type == BLKDIAG:
			process_smaller_squares_diag()	
		elif dissolve_type == VERTALT2:
			process_vert_swipe_alternating_dbl()	
		elif dissolve_type == SMLDIAG:
			process_small_diag_swipe()	
		elif dissolve_type == BIGDIAG:
			process_big_diag_swipe()	
		elif dissolve_type == SMLINTERVAL:
			#process_small_interval()	
			process_vert_swipe()
		elif dissolve_type == BIGINTERVAL:
			#process_big_interval()	
			process_vert_swipe()
		elif dissolve_type == ALTBOX:
			process_alternating_boxes()
		elif dissolve_type == ALTBOXALT:
			process_alternating_alt_boxes()
		elif dissolve_type == ALTBOX2:
			process_alternating_boxes_2()
		elif dissolve_type == ALTBOXALT2:
			process_alternating_alt_boxes_2()			
		elif dissolve_type == ALTBOX3:
			process_alternating_boxes_3()
		elif dissolve_type == ALTBOXALT3:
			process_alternating_alt_boxes_3()			
		elif dissolve_type == BOXSHRINK:
			process_box_shrink()			
		elif dissolve_type == BOXGROW:
			process_box_grow()			
		elif dissolve_type == BOXALT:
			process_box_shrink_grow()			
		elif dissolve_type == BOXALT4:
			process_box_cycle_4()			
		update()
#	elif state == HIDING:
#		if dissolve_type in [EVEN, UNEVEN]:
#			process_vert_swipe()
#		elif dissolve_type == RANDOM:
#			process_random_dissolve()
#		elif dissolve_type == DBLINWARD:
#			process_double_swipe_inward()
#		elif dissolve_type == DBLOUTWARD:
#			process_double_swipe_outward()
#		elif dissolve_type == RNDLINE:
#			process_random_line()
#		update()

func small_box_vertical(lx, ly, step):
	if step < larger_block_size:
		print (step)
		for lb in larger_block_size:
			if state == REVEALING:
				set_block(lb + (lx * larger_block_size), step + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(lb + (lx * larger_block_size), step + (ly * larger_block_size), blocks_x, blocks_y, true)

func small_box_horizontal(lx, ly, step):
	if step < larger_block_size:
		for lb in larger_block_size:
			if state == REVEALING:
				set_block(step + (lx * larger_block_size), lb + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(step + (lx * larger_block_size), lb + (ly * larger_block_size), blocks_x, blocks_y, true)

func small_box_horizontal_alt(lx, ly, step):
	var toggle = true
	for lb in larger_block_size:
		var temp_y = lb + (ly * larger_block_size)
		var temp_x
		if toggle:
			temp_x = step + (lx * larger_block_size)
		else:
			temp_x = ((larger_block_size - step) - 1)  + (lx * larger_block_size)
		toggle = not toggle
		if state == REVEALING:
			set_block(temp_x, temp_y, blocks_x, blocks_y, false)
		else:
			set_block(temp_x, temp_y, blocks_x, blocks_y, true)
			
func small_box_vertical_alt(lx, ly, step):
	var toggle = true
	for lb in larger_block_size:
		var temp_y
		if toggle:
			temp_y = step + (ly * larger_block_size)
		else:
			temp_y = ((larger_block_size - step) - 1)  + (ly * larger_block_size)
		toggle = not toggle
		if state == REVEALING:
			set_block(lb+ (lx * larger_block_size), temp_y, blocks_x, blocks_y, false)
		else:
			set_block(lb+ (lx * larger_block_size), temp_y, blocks_x, blocks_y, true)		


func small_box_shrink(lx, ly, step):
	var toggle = true
	var start_x = step
	var start_y = step
	var temp_x = start_x
	var temp_y = start_y
#	if start_x < larger_block_size:
	if start_x <= (larger_block_size / 2):
		for lb in (larger_block_size - step):
			temp_y = start_y
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_y = larger_block_size - (start_y + 1)
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_x = temp_x + 1
		
		temp_y = start_y
		for lb in (larger_block_size - step):
			temp_x = start_x
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_x = larger_block_size - (start_x + 1)
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_y = temp_y + 1
			
func small_box_grow(lx, ly, step):
	var toggle = true
	var start_x = (larger_block_size / 2) - step
	var start_y = (larger_block_size / 2) - step

	var steps_to_take = (step * 2) + 1
	if larger_block_size % 2 == 0:
		start_x = start_x - 1
		start_y = start_y - 1	
		steps_to_take = steps_to_take + 1	
		
	var temp_x = start_x
	var temp_y = start_y		
		
	if start_x >= 0:
		for lb in steps_to_take:
			temp_y = start_y
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_y = larger_block_size - (start_y + 1)
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)			
			temp_x = temp_x + 1
		temp_y = start_y
		for lb in steps_to_take:
			temp_x = start_x
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_x = larger_block_size - (start_x + 1)
			if state == REVEALING:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, false)
			else:
				set_block(temp_x + (lx * larger_block_size), temp_y + (ly * larger_block_size), blocks_x, blocks_y, true)		
			temp_y = temp_y + 1

func process_box_shrink():
#	var toggle = true
	var temp_trans = transition_line % 4
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for lx in larger_block_x + 1:
				for ly in larger_block_y + 1:
					small_box_shrink(lx, ly, (transition_line / 4))
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
		
func process_box_grow():
#	var toggle = true
	var temp_trans = transition_line % 4
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for lx in larger_block_x + 1:
				for ly in larger_block_y + 1:
					small_box_grow(lx, ly, (transition_line / 4))
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
		
func process_box_shrink_grow():
	var toggle = true
	var temp_trans = transition_line % 4
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for ly in larger_block_y + 1:
				for lx in larger_block_x + 1:
					if toggle:
						small_box_shrink(lx, ly, (transition_line / 4))
					else:
						small_box_grow(lx, ly, (transition_line / 4))
					toggle = not toggle
#				toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_box_cycle_4():
	var cycle = 0
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for ly in larger_block_y + 1:
				for lx in larger_block_x + 1:
					if cycle == 0:
						small_box_shrink(lx, ly, (transition_line / 4))
					elif cycle == 1:
						small_box_horizontal(lx, ly, (transition_line / 2))
					elif cycle == 2:
						small_box_grow(lx, ly, (transition_line / 4))
					elif cycle == 3:
						small_box_vertical(lx, ly, (transition_line / 2))
					cycle = cycle + 1
					if cycle == 4:
						cycle = 0
#				toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_alternating_boxes():
	var toggle = true
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for lx in larger_block_x + 1:
				for ly in larger_block_y + 1:
					if toggle:
						small_box_horizontal(lx, ly, (transition_line / 2))
					else:
						small_box_vertical(lx, ly, (transition_line / 2))
					toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_alternating_alt_boxes():
	var toggle = true
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for lx in larger_block_x + 1:
				for ly in larger_block_y + 1:
					if toggle:
						small_box_horizontal_alt(lx, ly, (transition_line / 2))
					else:
						small_box_vertical_alt(lx, ly, (transition_line / 2))
					toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_alternating_boxes_2():
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for lx in larger_block_x + 1:
				var toggle = true				
				for ly in larger_block_y + 1:
					if toggle:
						small_box_horizontal(lx, ly, (transition_line / 2))
					else:
						small_box_vertical(lx, ly, (transition_line / 2))
					toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_alternating_alt_boxes_2():
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for lx in larger_block_x + 1:
				var toggle = true				
				for ly in larger_block_y + 1:
					if toggle:
						small_box_horizontal_alt(lx, ly, (transition_line / 2))
					else:
						small_box_vertical_alt(lx, ly, (transition_line / 2))
					toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
		
func process_alternating_boxes_3():
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for ly in larger_block_y + 1:
				var toggle = true				
				for lx in larger_block_x + 1:
					if toggle:
						small_box_horizontal(lx, ly, (transition_line / 2))
					else:
						small_box_vertical(lx, ly, (transition_line / 2))
					toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_alternating_alt_boxes_3():
	var temp_trans = transition_line % 2
	if temp_trans == 0:
		if transition_line <= blocks_y:
			for ly in larger_block_y + 1:
				var toggle = true				
				for lx in larger_block_x + 1:
					if toggle:
						small_box_horizontal_alt(lx, ly, (transition_line / 2))
					else:
						small_box_vertical_alt(lx, ly, (transition_line / 2))
					toggle = not toggle
					
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_smaller_squares_diag():
	var temp_trans = int(transition_line % (larger_block_trans_ticker ))
	var temp_line = int(transition_line / (larger_block_trans_ticker / 2))
	var temp_col = int(transition_line / (larger_block_trans_ticker / 2))
	if temp_trans == 0 and temp_line < larger_block_size * 2:
		for ly in larger_block_y + 1:
			#temp_col = larger_block_size - temp_col
			for lx in larger_block_x + 1:
				for lb in larger_block_size + 1:
					temp_col = int(transition_line / (larger_block_trans_ticker / 2)) + 1
					for lq in larger_block_size + 1:
						if lb < temp_col + 1:					
	#						var temp_y = (ly * larger_block_size) + temp_line
							var temp_y = (ly * larger_block_size) + lq
							var temp_x = (lx * larger_block_size) + lb
							if state == REVEALING:
								set_block (temp_x, temp_y, blocks_x, blocks_y, false)
							else:
								set_block (temp_x, temp_y, blocks_x, blocks_y, true)
						temp_col = temp_col - 1
				#temp_col = temp_col - 1	
				
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
		
func process_small_diag_swipe():
	var temp_trans = int(transition_line % 2)
	if transition_line <= blocks_y:
		if temp_trans == 0:
			var switch_count = (blocks_y / 2) - (transition_line / 2)
			if switch_count < 0:
				switch_count = switch_count + (blocks_y / 2)
			for ly in blocks_y + 1:
				var switch_ticker = blocks_y / 2
				for lx in blocks_x + 1:
					if switch_ticker == switch_count:
						if state == REVEALING:
							set_block(lx, ly, blocks_x, blocks_y, false)
						else:
							set_block(lx, ly, blocks_x, blocks_y, true)
					switch_ticker = switch_ticker - 1
					if switch_ticker == 0:
						switch_ticker = blocks_y / 2
				switch_count = switch_count - 1
				if switch_count == 0:
					switch_count = switch_count + (blocks_y / 2)
	
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
	pass
	
func process_big_diag_swipe():
	var temp_trans = 0
	if transition_line <= blocks_y:
		if temp_trans == 0:
			var switch_count = blocks_y - transition_line
			if switch_count < 0:
				switch_count = switch_count + blocks_y
			for ly in blocks_y + 1:
				var switch_ticker = blocks_y
				for lx in blocks_x + 1:
					if switch_ticker == switch_count:
						if state == REVEALING:
							set_block(lx, ly, blocks_x, blocks_y, false)
						else:
							set_block(lx, ly, blocks_x, blocks_y, true)
					switch_ticker = switch_ticker - 1
					if switch_ticker == 0:
						switch_ticker = blocks_y
				switch_count = switch_count - 1
				if switch_count == 0:
					switch_count = switch_count + blocks_y
	
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
	pass
	
func process_big_interval():
	var temp_trans = transition_line
	if temp_trans == 1:
		var switch_count = (blocks_y) - (transition_line)
		if switch_count < 0:
			switch_count = switch_count + (blocks_y)
		var switch_ticker = transition_line
		for i in display_array.size():
			if switch_ticker == switch_count:
				if state == REVEALING:
					display_array[i] = false
				else:
					display_array[i] = true			
			switch_ticker = switch_ticker - 1
			if switch_ticker == 0:
				switch_ticker = transition_line
	
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
	pass
	
func process_small_interval():
	var temp_trans = int(transition_line % 2)
	if temp_trans == 1:
		var switch_count = (blocks_y / 2) - (transition_line / 2)
		if switch_count < 0:
			switch_count = switch_count + (blocks_y / 2)
		var switch_ticker = transition_line / 2
		for i in display_array.size():
			if switch_ticker == switch_count:
				if state == REVEALING:
					display_array[i] = false
				else:
					display_array[i] = true			
			switch_ticker = switch_ticker - 1
			if switch_ticker == 0:
				switch_ticker = transition_line / 2
	
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
	pass
						
func process_smaller_squares_opposing_directions():
	var temp_trans = int(transition_line % larger_block_trans_ticker)
	var temp_line = int(transition_line / larger_block_trans_ticker)
	if temp_trans == 0 and temp_line < larger_block_size:
		for lx in larger_block_x + 1:
			for ly in larger_block_y + 1:
				for lb in larger_block_size:
#					print(lx, " , ", ly, " , ", lb, " , ", temp_line)
					var chk_blk = lx % 2
					var temp_x = (lx * larger_block_size) + lb
					var temp_y = 0
					if chk_blk == 0:
						temp_y = ((ly * larger_block_size)) + temp_line
					else:
						temp_y = ((ly * larger_block_size)) + ((larger_block_size - temp_line) - 1)
#					print(temp_x, "  ,  ", temp_y)
					if state == REVEALING:
						set_block (temp_x, temp_y, blocks_x, blocks_y, false)
					else:
						set_block (temp_x, temp_y, blocks_x, blocks_y, true)
		
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_smaller_squares_same_directions():
	var temp_trans = int(transition_line % larger_block_trans_ticker)
	var temp_line = int(transition_line / larger_block_trans_ticker)
	if temp_trans == 0 and temp_line < larger_block_size:
		for lx in larger_block_x + 1:
			for ly in larger_block_y + 1:
				for lb in larger_block_size + 1:
#					print(lx, " , ", ly, " , ", lb, " , ", temp_line)
					var chk_blk = lx % 2
					var temp_x = (lx * larger_block_size) + lb
					var temp_y = 0
					temp_y = ((ly * larger_block_size)) + temp_line
#					print(temp_x, "  ,  ", temp_y)
					if state == REVEALING:
						set_block (temp_x, temp_y, blocks_x, blocks_y, false)
					else:
						set_block (temp_x, temp_y, blocks_x, blocks_y, true)
		
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func process_smaller_squares_same_sideways_directions():
	var temp_trans = int(transition_line % larger_block_trans_ticker)
	var temp_line = int(transition_line / larger_block_trans_ticker)
	if temp_trans == 0 and temp_line < larger_block_size:
		for ly in larger_block_y + 1:
			for lx in larger_block_x + 1:
				for lb in larger_block_size + 1:
#					print(lx, " , ", ly, " , ", lb, " , ", temp_line)
					var chk_blk = lx % 2
					var temp_y = (ly * larger_block_size) + lb
					var temp_x = (lx * larger_block_size) + temp_line
#					print(temp_x, "  ,  ", temp_y)
					if state == REVEALING:
						set_block (temp_x, temp_y, blocks_x, blocks_y, false)
					else:
						set_block (temp_x, temp_y, blocks_x, blocks_y, true)
		
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
		
func process_smaller_squares_opposing_sideways_directions():
	var temp_trans = int(transition_line % larger_block_trans_ticker)
	var temp_line = int(transition_line / larger_block_trans_ticker)
	var temp_toggle = true
	if temp_trans == 0 and temp_line < larger_block_size:
		for ly in larger_block_y + 1:
			for lx in larger_block_x + 1:
				temp_toggle = not temp_toggle
				for lb in larger_block_size:
#					print(lx, " , ", ly, " , ", lb, " , ", temp_line)
					var chk_blk = lx % 2
					var temp_y = (ly * larger_block_size) + lb
					var temp_x = 0
					if temp_toggle:
					   temp_x = (lx * larger_block_size) + temp_line
					else:
						temp_x = (lx * larger_block_size) + ((larger_block_size - temp_line) - 1)
#					print(temp_x, "  ,  ", temp_y)
					if state == REVEALING:
						set_block (temp_x, temp_y, blocks_x, blocks_y, false)
					else:
						set_block (temp_x, temp_y, blocks_x, blocks_y, true)
		
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
	
func process_random_dissolve():
	if state == REVEALING:
		var rand_array = []
		for i in display_array.size():
			if display_array[i]:
				rand_array.append(i)
		if rand_array.size() > 0:
			for x in blocks_x:
				var blank_block = randi()%rand_array.size()
				display_array[rand_array[blank_block]] = false
				rand_array.remove(blank_block)
	else:
		var rand_array = []
		for i in display_array.size():
			if not display_array[i]:
				rand_array.append(i)
		if rand_array.size() > 0:
			for x in blocks_x:
				var blank_block = randi()%rand_array.size()
				display_array[rand_array[blank_block]] = true
				rand_array.remove(blank_block)
				
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING
		
func process_vert_swipe():
	if state == REVEALING:
		for xy in blocks_x:
			var alter_point = xy + ((transition_line - vary_array[xy]) * blocks_x)
			if alter_point >= 0 and alter_point < display_array.size():
				#display_array[xy + (transition_line * blocks_x)] = false
				display_array[alter_point] = false
		transition_line = transition_line + 1
		if transition_line == blocks_y + 8:
			state = NOTHING
			blanked = false
	elif state == HIDING:
		for xy in blocks_x:
			var alter_point = xy + ((transition_line - vary_array[xy]) * blocks_x)
			if alter_point >= 0 and alter_point < display_array.size():
				display_array[alter_point] = true
		transition_line = transition_line + 1
		if transition_line == blocks_y + 8:
			state = NOTHING

func process_vert_swipe_alternating():
	var toggle = true
	if state == REVEALING:
		for xy in blocks_x:
			toggle = not toggle
			var alter_point
			if toggle:
				alter_point = xy + ((transition_line - vary_array[xy]) * blocks_x)
			else:
				alter_point = 	xy + ((blocks_y - (transition_line - vary_array[xy])) * blocks_x)
			if alter_point >= 0 and alter_point < display_array.size():
				#display_array[xy + (transition_line * blocks_x)] = false
				display_array[alter_point] = false
		transition_line = transition_line + 1
		if transition_line == blocks_y + 8:
			state = NOTHING
			blanked = false
	elif state == HIDING:
		for xy in blocks_x:
			toggle = not toggle
			var alter_point
			if toggle:
				alter_point = xy + ((transition_line - vary_array[xy]) * blocks_x)
			else:
				alter_point = 	xy + ((blocks_y - (transition_line - vary_array[xy])) * blocks_x)
			if alter_point >= 0 and alter_point < display_array.size():
				display_array[alter_point] = true
		transition_line = transition_line + 1
		if transition_line == blocks_y + 8:
			state = NOTHING
			
func process_vert_swipe_alternating_dbl():
	var toggle = true
	var toggle_count = 0
	if state == REVEALING:
		for xy in blocks_x:
			toggle_count = toggle_count + 1
			if toggle_count == 2:
				toggle = not toggle
				toggle_count = 0
			var alter_point
			if toggle:
				alter_point = xy + ((transition_line - vary_array[xy]) * blocks_x)
			else:
				alter_point = 	xy + ((blocks_y - (transition_line - vary_array[xy])) * blocks_x)
			if alter_point >= 0 and alter_point < display_array.size():
				#display_array[xy + (transition_line * blocks_x)] = false
				display_array[alter_point] = false
		transition_line = transition_line + 1
		if transition_line == blocks_y + 8:
			state = NOTHING
			blanked = false
	elif state == HIDING:
		for xy in blocks_x:
			if toggle_count == 2:
				toggle = not toggle
				toggle_count = 0
			var alter_point
			if toggle:
				alter_point = xy + ((transition_line - vary_array[xy]) * blocks_x)
			else:
				alter_point = 	xy + ((blocks_y - (transition_line - vary_array[xy])) * blocks_x)
			if alter_point >= 0 and alter_point < display_array.size():
				display_array[alter_point] = true
		transition_line = transition_line + 1
		if transition_line == blocks_y + 8:
			state = NOTHING

func process_double_swipe_inward():
	if transition_line % 2 == 0:
		var temp_line = int(transition_line / 2)
		if state == REVEALING:
			for xy in blocks_x:
				var alter_point = xy + ((temp_line - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = false
			for xy in blocks_x:
				var alter_point = xy + (((blocks_y - temp_line) - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = false
			transition_line = transition_line + 1
			if transition_line == blocks_y + 8:
				state = NOTHING
				blanked = false
		elif state == HIDING:
			for xy in blocks_x:
				var alter_point = xy + ((temp_line - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					display_array[alter_point] = true
			for xy in blocks_x:
				var alter_point = xy + (((blocks_y - temp_line) - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = true					
			transition_line = transition_line + 1
			if transition_line == blocks_y + 8:
				state = NOTHING	
	else:
		transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true			
		state = NOTHING

func process_double_swipe_outward():
	if transition_line % 2 == 0:
		var temp_line = int(transition_line / 2)
		if state == REVEALING:
			for xy in blocks_x:
				var alter_point = xy + (((blocks_y / 2) + temp_line - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = false
			for xy in blocks_x:
				var alter_point = xy + ((((blocks_y / 2) - temp_line) - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = false
			transition_line = transition_line + 1
			if transition_line == blocks_y + 8:
				state = NOTHING
				blanked = false
		elif state == HIDING:
			for xy in blocks_x:
				var alter_point = xy + (((blocks_y / 2) + temp_line - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = true
			for xy in blocks_x:
				var alter_point = xy + ((((blocks_y / 2) - temp_line) - vary_array[xy]) * blocks_x)
				if alter_point >= 0 and alter_point < display_array.size():
					#display_array[xy + (transition_line * blocks_x)] = false
					display_array[alter_point] = true					
			transition_line = transition_line + 1
			if transition_line == blocks_y + 8:
				state = NOTHING	
	else:
		transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true			
		state = NOTHING

func process_random_line():
	if state == REVEALING:
		var rand_array = []
		for i in blocks_y:
			if display_array[i * blocks_x]:
				rand_array.append(i)
		if rand_array.size() > 0:
			var blank_pick = randi()%rand_array.size()
			var blank_line = rand_array[blank_pick]
			for x in blocks_x:
				display_array[x + (blank_line * blocks_x)] = false
	else:
		var rand_array = []
		for i in blocks_y:
			if not display_array[i * blocks_x]:
				rand_array.append(i)
		if rand_array.size() > 0:
			var blank_pick = randi()%rand_array.size()
			var blank_line = rand_array[blank_pick]
			for x in blocks_x:
				display_array[x + (blank_line * blocks_x)] = true
								
	transition_line = transition_line + 1
	if transition_line == blocks_y + 8:
		if state == REVEALING:
			blanked = false
		else:
			blanked = true
		state = NOTHING

func start_reveal(transition):
	dissolve_type = transition
	if state == NOTHING:
		for i in vary_array.size():
			vary_array[i] = 0
		in_transition = true
		transition_line = 0
		state = REVEALING

func start_blanking(transition):
	dissolve_type = transition
	if state == NOTHING:
		for i in vary_array.size():
			vary_array[i] = 0
		in_transition = true
		transition_line = 0
		state = HIDING
		blanked = true
		

func start_reveal_uneven():
	dissolve_type = UNEVEN	
	if state == NOTHING:
		for i in vary_array.size():
			vary_array[i] = randi()%3 + 1
		in_transition = true
		transition_line = 0
		state = REVEALING
	
func start_blanking_uneven():
	dissolve_type = UNEVEN	
	if state == NOTHING:
		for i in vary_array.size():
			vary_array[i] = randi()%3 + 1
		in_transition = true
		transition_line = 0
		state = HIDING
		blanked = true
		
func toggle_blanked(transition_type):
	if state == NOTHING:
#		print("Toggling")		
		if blanked:
			start_reveal(transition_type)
		else:
			start_blanking(transition_type)

func toggle_blanked_random():
	if state == NOTHING:
		var picker = randi()%22
#		print("Transition : ", picker)
		if blanked:
			start_reveal(picker)
		else:
			start_blanking(picker)
			
func in_progress():
	if state == NOTHING:
		return false
	else:
		return true
