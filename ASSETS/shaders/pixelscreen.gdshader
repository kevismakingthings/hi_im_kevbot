shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float pixel_size : hint_range(1.0, 32.0) = 6.0;
uniform float blur_lod   : hint_range(0.0, 6.0) = 2.5;
uniform vec2  rect_size  = vec2(200.0, 30.0);
// corner radii in px, clockwise from top-left: (TL, TR, BR, BL)
uniform vec4  corners = vec4(16.0, 24.0, 8.0, 16.0);
uniform float edge_width : hint_range(1.0, 32.0) = 8.0;   // dither band thickness (px)

const float bayer[16] = float[16](
     0.0,  8.0,  2.0, 10.0,
    12.0,  4.0, 14.0,  6.0,
     3.0, 11.0,  1.0,  9.0,
    15.0,  7.0, 13.0,  5.0
);

float bayer4(vec2 cell) {
    int x = int(mod(cell.x, 4.0));
    int y = int(mod(cell.y, 4.0));
    return (bayer[y * 4 + x] + 0.5) / 16.0;
}

float pick_radius(vec2 p, vec4 c) {
    float top    = (p.x < 0.0) ? c.x : c.y;   // TL vs TR
    float bottom = (p.x < 0.0) ? c.w : c.z;   // BL vs BR
    return (p.y < 0.0) ? top : bottom;        // +y is down in UV space
}

float sd_rounded_box(vec2 p, vec2 half_size, vec4 c) {
    float r = pick_radius(p, c);
    r = min(r, min(half_size.x, half_size.y));  // guard against oversized radius
    vec2 q = abs(p) - half_size + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, vec2(0.0))) - r;
}

void fragment() {
    // pixel blur (screen space)
    vec2 grid = SCREEN_PIXEL_SIZE * pixel_size;
    vec2 suv  = (floor(SCREEN_UV / grid) + 0.5) * grid;
    vec3 col  = textureLod(screen_tex, suv, blur_lod).rgb;

    // rounded-rect SDF snapped to the same pixel grid (node space)
    vec2 cell = floor(UV * rect_size / pixel_size);           // chunk index
    vec2 p    = (cell + 0.5) * pixel_size - rect_size * 0.5;  // chunk center, centered origin
    float d   = sd_rounded_box(p, rect_size * 0.5, corners);

    // dithered edge: coverage ramps across edge_width, Bayer decides on/off per chunk
    float cov  = clamp(0.5 - d / edge_width, 0.0, 1.0);
    float mask = step(bayer4(cell), cov);

    COLOR = vec4(col, mask);
}