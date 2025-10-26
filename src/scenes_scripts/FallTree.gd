extends Sprite2D

var leaf_level = 0
@onready var pile_parent = $PileParent

@export var trees_tres: Array[AtlasTexture] = [
	load("res://assets/tree1.tres"),
	load("res://assets/tree2.tres"),
	load("res://assets/tree3.tres"),
	load("res://assets/tree4.tres"),
	load("res://assets/tree5.tres"),
	load("res://assets/tree6.tres"),
	load("res://assets/tree7.tres"),
	load("res://assets/tree8.tres"),
	load("res://assets/tree9.tres"),
	load("res://assets/tree10.tres"),
	load("res://assets/tree11.tres"),
	load("res://assets/tree12.tres"),
	load("res://assets/tree13.tres"),
	load("res://assets/tree14.tres"),
	load("res://assets/tree15.tres"),
	load("res://assets/tree16.tres"),
]

@export var piles_tres: Array[AtlasTexture] = [
	load("res://assets/pile0.tres"),
	load("res://assets/pile1.tres"),
	load("res://assets/pile2.tres"),
	load("res://assets/pile3.tres"),
	load("res://assets/pile4.tres"),
	load("res://assets/pile5.tres"),
	load("res://assets/pile6.tres"),
	load("res://assets/pile7.tres"),
	load("res://assets/pile8.tres"),
	load("res://assets/pile9.tres"),
]

func _ready() -> void:
	randomize()
	if randf() > 0.5:
		scale = Vector2(-1, 1)
	texture = trees_tres[randi_range(0, trees_tres.size()-1)]
	leaf_level = randi() % pile_parent.get_child_count()
	for child in pile_parent.get_children():
		child.texture = piles_tres[randi_range(0, piles_tres.size()-1)]
	update_pile()

func _on_leaf_piling_timer_timeout() -> void:
	leaf_level += 1
	update_pile()

func update_pile():
	$LeafPileStaticBody2D.position = Vector2(0, 124.0) if leaf_level else Vector2(0, 1000)
	for child in pile_parent.get_children():
		child.visible = child.get_index() < leaf_level

func collect():
	leaf_level = 0
	update_pile()
