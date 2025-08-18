shader_type canvas_item;

void fragment() {
    float radius = 0.5;
    vec2 center = vec2(0.5);
    float dist = distance(UV, center);
    if (dist > radius) {
        COLOR.a = 0.0; // Make outside transparent
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}
