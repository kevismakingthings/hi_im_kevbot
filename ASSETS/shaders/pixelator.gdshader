shader_type canvas_item;

uniform float pixel_size : hint_range(1.0, 64.0) = 8.0;
uniform float blur_amount : hint_range(0.0, 4.0) = 1.0;

void fragment() {
	vec2 tex_px = TEXTURE_PIXEL_SIZE;           // 1.0 / texture_size
	vec2 block = pixel_size * tex_px;
	vec2 base_uv = floor(UV / block) * block + block * 0.5;

	vec4 col = vec4(0.0);
	for (float x = -1.0; x <= 1.0; x += 1.0)
		for (float y = -1.0; y <= 1.0; y += 1.0)
			col += texture(TEXTURE, base_uv + vec2(x, y) * block * blur_amount);
	COLOR = col / 9.0;
}