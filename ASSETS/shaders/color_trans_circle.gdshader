shader_type canvas_item;

// --- dithered base layer ---
uniform vec4 color_a : source_color = vec4(0.05, 0.05, 0.2, 1.0);
uniform vec4 color_b : source_color = vec4(0.9, 0.5, 0.7, 1.0);
uniform float radius = 0.5;
uniform float falloff = 0.05;
uniform float rings = 3.0;
uniform float speed = 0.0;
uniform float init_speed = 0.0;
uniform float cell_size = 2;
uniform float amplitude = 0.02;
uniform float freq = 0.01;
uniform float custom1_time = 0.0;
uniform float custom2_time = 0.0;

// --- smooth hue-shift overlay ---
uniform vec4 color_c : source_color = vec4(0.0, 1.0, 0.83, 1.0);
uniform vec4 color_d : source_color = vec4(1.0, 0.67, 0.0, 1.0);
uniform float rings2 = 5.0;
uniform float speed2 = 0.0;
uniform float init_speed2 = 0.0;
uniform float shift = 0.5;       // hue-shift strength

uniform float aspect = 1.0;
uniform vec2 center = vec2(0.5);

const float bayer[16] = float[16](
     0.0,  8.0,  2.0, 10.0,
    12.0,  4.0, 14.0,  6.0,
     3.0, 11.0,  1.0,  9.0,
    15.0,  7.0, 13.0,  5.0
);

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
	//float set_speed = ((sin(custom_time * freq)) * amplitude);
	float set_speed = -custom1_time;
	
	float set_speed2 = custom2_time;
	
    vec2 pp = floor(FRAGCOORD.xy / cell_size);
    int ix = int(mod(pp.x, 4.0));
    int iy = int(mod(pp.y, 4.0));
    float threshold = (bayer[iy * 4 + ix] + 0.5) / 16.0;

    vec2 d = UV - center;
    d.x *= aspect;
    float dist = length(d);

    // dithered base layer
	float g_base = abs(fract(dist * rings + (TIME * 0.3)));
    vec4 base_col = mix(color_a, color_b, step(threshold, g_base));

    // smooth overlay — triangle wave so it's seamless (no dither to hide a seam)
    float g_over = abs(fract(dist * rings2 - (set_speed2 * 2.0)) * 2.0 - 1.0);
    vec4 over_col = mix(color_c, color_d, g_over);

    float mask = smoothstep(radius - falloff, radius, dist);

    // rotate base hue by overlay hue, scaled by overlay saturation + strength
    vec3 bh = rgb2hsv(base_col.rgb);
    vec3 oh = rgb2hsv(over_col.rgb);
    bh.x = fract(bh.x + oh.x * oh.y * shift);

    COLOR = vec4(hsv2rgb(bh), base_col.w + over_col.w * (1.0 - base_col.w));
}