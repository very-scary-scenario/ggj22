extends Node2D

export var BGColour : Color

var is_drawn = false
#var background_colour
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta):
		self.global_position.x = 0
		self.global_position.y = 0
		$Background.color = BGColour
		#$Background.rect.size = get_viewport().size
		$Background.set_size(get_viewport().size)
		#$Background.size.x = get_viewport().get_visible_rect().size.y
		
#	is_drawn = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#func update_colour():
#	background_colour = Color(BGColour)

func set_colour(new_colour:Color):
	BGColour = new_colour
	
