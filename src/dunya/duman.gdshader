// Duman sütunu: kameraya dönük büyük dörtgen; yukarı akan gürültü, tabanda dar, yukarıda genişleyip incelir.
// Altı yangının ışığıyla turuncuya boyanır. KapiManzarasi.duman kullanır. Tasarım: design/gdd/kapi-manzarasi.md
shader_type spatial;
render_mode blend_mix, unshaded, depth_draw_never, cull_disabled;

uniform sampler2D gurultu : repeat_enable, filter_linear;
uniform vec3 renk : source_color = vec3(0.12, 0.12, 0.14);
uniform vec3 kor : source_color = vec3(0.9, 0.35, 0.08);
uniform float koyuluk = 0.75;
uniform float hiz = 0.05;
uniform float tohum = 0.0;
uniform float egim = 0.35;

void vertex() {
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)) * length(MODEL_MATRIX[0].xyz), 0.0),
		vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
		vec4(normalize(INV_VIEW_MATRIX[2].xyz * vec3(1.0, 0.0, 1.0)) * length(MODEL_MATRIX[2].xyz), 0.0),
		MODEL_MATRIX[3]);
}

void fragment() {
	float y = 1.0 - UV.y;
	float t = TIME * hiz;
	vec2 uv = UV;
	uv.x -= y * y * egim;                      // rüzgâr: yukarı çıktıkça yana yatar
	float n1 = texture(gurultu, vec2(uv.x * 1.2 + tohum, UV.y * 1.4 + t)).r;
	float n2 = texture(gurultu, vec2(uv.x * 2.6 - tohum, UV.y * 2.8 + t * 1.7)).r;
	float n = n1 * 0.65 + n2 * 0.35;
	float en = mix(0.08, 0.42, smoothstep(0.0, 1.0, y));
	float d = abs(uv.x - 0.5) / en;
	float a = (1.0 - smoothstep(0.3, 1.0, d + (0.5 - n) * 0.9));
	a *= smoothstep(0.0, 0.12, y) * (1.0 - smoothstep(0.6, 1.0, y));
	vec3 c = mix(kor, renk, smoothstep(0.0, 0.3, y));
	ALBEDO = c;
	ALPHA = clamp(a * koyuluk, 0.0, 1.0);
}
