shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(0.05, 0.05, 0.2, 1.0);
uniform vec4 color_b : source_color = vec4(0.9, 0.5, 0.7, 1.0);
uniform float speed = 0.15;     // scroll speed (negative = downward)
uniform float cell_size = 4.0;  // dither dot size in screen pixels
uniform float bands = 1.0;      // how many gradient repeats across the rect

// 4x4 Bayer matrix — chunky, GBA-ish dithering
const float bayer[16] = float[16](
     0.0,  8.0,  2.0, 10.0,
    12.0,  4.0, 14.0,  6.0,
     3.0, 11.0,  1.0,  9.0,
    15.0,  7.0, 13.0,  5.0
);

void fragment() {
    // pixel-snap the coords so dither dots stay crisp
    vec2 p = floor(FRAGCOORD.xy / cell_size);
    int ix = int(mod(p.x, 4.0));
    int iy = int(mod(p.y, 4.0));
    float threshold = (bayer[iy * 4 + ix] + 0.5) / 16.0;

    // gradient value that loops + scrolls upward over time
	float g = abs(fract(UV.y * bands + TIME * speed) * 2.0 - 1.0);
	
    COLOR = mix(color_a, color_b, step(threshold, g));
}