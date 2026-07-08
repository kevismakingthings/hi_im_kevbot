shader_type canvas_item;

// Capsule progress bar via SDF.
// Apply to a ColorRect sized to the bar's bounding box (same convention as
// your other SDF/rounded-rect shaders — not applied directly to a Panel).

group_uniforms Fill;
uniform float value : hint_range(0.0, 1.0) = 0.5;
uniform vec4 fill_color : source_color = vec4(0.3, 0.8, 1.0, 1.0);
uniform vec4 bg_color : source_color = vec4(0.1, 0.1, 0.14, 1.0);
group_uniforms;

group_uniforms Border;
uniform float border_width = 2.0;
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
group_uniforms;

group_uniforms Edge;
// 0 = hard cutoff, 1 = Bayer-dithered edge
uniform bool use_dither = false;
uniform sampler2D bayer_tex : filter_nearest, repeat_enable;
uniform float dither_scale = 1.0;
group_uniforms;

// Must be set from GDScript to match the ColorRect's actual pixel size,
// e.g.: material.set_shader_parameter("rect_size", size)
uniform vec2 rect_size = vec2(200.0, 30.0);

// Signed distance to a capsule (rounded rect where radius == half-height),
// centered at origin, box half-extents `half_size`.
float sdf_capsule(vec2 p, vec2 half_size) {
	float radius = half_size.y; // capsule cap radius = half the bar's height
	vec2 inner_half = vec2(max(half_size.x - radius, 0.0), 0.0);
	vec2 d = abs(p) - inner_half;
	return length(max(d, 0.0)) - radius;
}

float edge_mask(float dist, vec2 uv_px) {
	if (use_dither) {
		float bayer = texture(bayer_tex, uv_px * dither_scale / vec2(textureSize(bayer_tex, 0))).r;
		// dist < 0 inside shape; dither over ~1px band
		return step(dist, (bayer - 0.5));
	} else {
		return step(dist, 0.0);
	}
}

void fragment() {
	vec2 half_size = rect_size * 0.5;
	vec2 p = (UV - 0.5) * rect_size; // pixel-space, centered

	// --- Background capsule ---
	float bg_dist = sdf_capsule(p, half_size);
	float bg_mask = edge_mask(bg_dist, UV * rect_size);

	// --- Border (background capsule inset by border_width) ---
	float border_dist = sdf_capsule(p, half_size - vec2(border_width));
	float border_mask = edge_mask(border_dist, UV * rect_size);

	// --- Fill capsule ---
	// Fill grows from the left edge. Its half-width shrinks with `value`,
	// and its center shifts left so the left cap stays flush against the
	// background's left cap at all times.
	float fill_half_w = half_size.x * value;
	// clamp so radius (half_size.y) never exceeds fill_half_w, avoiding
	// a degenerate capsule when value is very small
	fill_half_w = max(fill_half_w, half_size.y);
	vec2 fill_half_size = vec2(fill_half_w, half_size.y);
	vec2 fill_p = p + vec2(half_size.x - fill_half_w, 0.0);
	float fill_dist = sdf_capsule(fill_p, fill_half_size);
	float fill_mask = edge_mask(fill_dist, UV * rect_size);
	// Hide fill entirely at value <= 0
	fill_mask *= step(0.001, value);

	vec4 color = bg_color;
	color = mix(color, fill_color, border_mask);
	// fill draws on top of border/background where inside its own capsule


	COLOR = color * bg_mask; // clip everything to the outer capsule silhouette
}
