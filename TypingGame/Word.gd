extends Node2D

export var word_to_type = "@TESTING"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_word_position = 0
var word_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$BaseWord.text_display = word_to_type
	$background_border.rect_global_position.x = $BaseWord.global_position.x - 4
	$background_border.rect_global_position.y = $BaseWord.global_position.y - 4
	$background_border.rect_size = Vector2((word_to_type.length() * 8) + 8, 16)
		
	$background.rect_global_position.x = $BaseWord.global_position.x - 2
	$background.rect_global_position.y = $BaseWord.global_position.y - 2
	$background.rect_size = Vector2((word_to_type.length() * 8) + 4, 12)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BaseWord.text_display = word_to_type
	$background_border.rect_global_position.x = $BaseWord.global_position.x - 4
	$background_border.rect_global_position.y = $BaseWord.global_position.y - 4
	$background_border.rect_size = Vector2((word_to_type.length() * 8) + 8, 16)
		
	$background.rect_global_position.x = $BaseWord.global_position.x - 2
	$background.rect_global_position.y = $BaseWord.global_position.y - 2
	$background.rect_size = Vector2((word_to_type.length() * 8) + 4, 12)

func _unhandled_input(event: InputEvent) -> void:
	if word_active:
		if event is InputEventKey and event.is_pressed() and not event.is_echo():
			var typed_event = event as InputEventKey
			var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()
			#print("Typed %s" % key_typed)
			
			if (PoolByteArray([typed_event.unicode])[0]) > 0:
		
				var check_character = word_to_type.substr(current_word_position, 1)
				if key_typed.to_upper() == check_character.to_upper():
					current_word_position += 1
				else:
#					current_word_position = 0
					visible = false
					if get_tree().get_nodes_in_group("BATTLE_SCENE").size() > 0:
						get_tree().get_nodes_in_group("BATTLE_SCENE")[0].attack_successful = 2
						
	#			print (current_word_position)
				$OvertypeWord.text_display = word_to_type.substr(0, current_word_position)

				if current_word_position == word_to_type.length():
					#call_deferred("remove_item")
					visible = false
					if get_tree().get_nodes_in_group("BATTLE_SCENE").size() > 0:
						get_tree().get_nodes_in_group("BATTLE_SCENE")[0].attack_successful = 1
					
func reset_word(new_word):
	current_word_position = 0
	$OvertypeWord.text_display = ""
	word_to_type = new_word
	
func remove_item():
	get_parent().remove_child(self)
