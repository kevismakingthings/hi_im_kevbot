// blur_dim.gdshader
shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform float blur : hint_range(0.0, 5.0) = 2.5;
uniform float dim  : hint_range(0.0, 1.0) = 0.4;
uniform vec4 dim_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec3 col = textureLod(screen_tex, SCREEN_UV, blur).rgb;
	col = mix(col, dim_color.rgb, dim);
	COLOR = vec4(col, 1.0);
}