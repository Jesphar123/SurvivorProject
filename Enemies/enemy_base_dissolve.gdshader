shader_type canvas_item;

uniform bool hit;
uniform bool dying;
uniform float dissolve_speed: hint_range(0.0, 1.0) = 1.0;

uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0, 0.1);

float random_coord(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,96.233))) * 43758.5453);
	}

void fragment() {
	vec2 texture_resolution = 1.0 / TEXTURE_PIXEL_SIZE;
	vec2 pixel_within_texture = floor(UV * texture_resolution);
	vec4 texture_color = texture(TEXTURE, UV);

	if (dying){
		COLOR = texture_color * step(random_coord(pixel_within_texture), dissolve_speed);
		}

	if (hit){
		COLOR = mix(texture_color, flash_color, flash_value);
		COLOR.a = texture_color.a;
	}
	}
