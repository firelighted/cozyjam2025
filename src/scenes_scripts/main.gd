extends Node


@export var tree_prefab : PackedScene = load("res://src/scenes_scripts/falltree.tscn")
@export var treeparent_path : NodePath = "TreeParent"

var trees 
func _ready() -> void:
	trees = get_node(treeparent_path).get_children()
