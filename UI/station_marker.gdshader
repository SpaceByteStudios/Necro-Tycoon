shader_type canvas_item;

uniform sampler2D mask_texture : filter_nearest;
uniform float progress : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform vec4 wheel_color : source_color;

float remap(float value, float istart, float istop, float ostart, float ostop) {
	return ostart + (ostop - ostart) * ((value - istart) / (istop - istart));
}

void fragment() {
	vec4 text = texture(TEXTURE, UV);
	vec2 uv = (UV - 0.5) * 2.0;
	uv = vec2(uv.y, -uv.x);
	
	float a = atan(uv.y, uv.x);
	
	float edge = remap(progress, 0.0, 1.0, -PI, PI);
	float step_a = 1.0 - step(edge, a);
	float mask = texture(mask_texture, UV).r;
	float masked_a = step_a * mask;
	float inv_masked_a = 1.0 - masked_a;
	
	COLOR = vec4(vec3(masked_a) * wheel_color.rgb, 1.0 * text.a) + text * inv_masked_a;
}
