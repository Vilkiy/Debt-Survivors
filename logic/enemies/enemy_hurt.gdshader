shader_type canvas_item;

uniform float flash_speed : hint_range(1.0, 20.0) = 8.0;

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    
	
    float pulse = (sin(TIME * flash_speed) + 1.0) / 2.0;
    
	
    COLOR.rgb = mix(original.rgb, vec3(1.0, 0.0, 0.0), pulse);
    COLOR.a = original.a;
}