# shader_registry.gd (autoload, or a Resource you preload)
extends Node

var all_shaders: Array[ShaderMaterial] = [
	preload("res://ASSETS/shaders/blurdim_mat.tres"),
	preload("res://ASSETS/shaders/blurdim_mat2.tres"),
	preload("res://ASSETS/shaders/color_circle.tres"),
	preload("res://ASSETS/shaders/about_backdrop.tres"),
	preload("res://ASSETS/shaders/start_pixel.tres")
]
