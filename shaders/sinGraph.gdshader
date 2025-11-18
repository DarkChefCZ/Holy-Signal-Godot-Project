shader_type canvas_item;

uniform float time;
uniform float amplitude : hint_range(0.1, 0.9) = 0.3;
uniform float frequency : hint_range(0.1, 9.9) = 3.3;
uniform float thickness = 0.001;
uniform vec4 line_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    float y = sin(UV.x * frequency * 6.283 + time) * amplitude + 0.5;

    float dist = abs(UV.y - y);

    if (dist < thickness) {
        COLOR = line_color;
    } else {
        COLOR = vec4(0.0,0.0,0.0,0.0); // transparent background
    }
}
