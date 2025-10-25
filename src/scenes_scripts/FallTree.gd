extends Sprite2D

var leaf_level = 0
@onready var pile_parent = $PileParent
var collected = false

func _ready() -> void:
	randomize()
	if randf() > 0.5:
		scale = Vector2(-1, 1)
	leaf_level = randi() % pile_parent.get_child_count()
	update_pile()

func _on_leaf_piling_timer_timeout() -> void:
	leaf_level += 1
	update_pile()

func update_pile():
	#if leaf_level < pile_parent.get_child_count(): 
		#pile_parent.get_child(leaf_level).show()
	$LeafPileStaticBody2D.position = Vector2(0, 124.0) if leaf_level else Vector2(0, 1000)
	for child in pile_parent.get_children():
		child.visible = child.get_index() < leaf_level

func collect():
	collected = true
	leaf_level = 0
	update_pile()
