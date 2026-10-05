// Alev: kameraya dönük dörtgen üstünde gürültüyle dalgalanan damla biçimi. Çekirdek beyaz-sarı, kenar turuncu-kızıl,
// uç dumanlı. Meşaleler ve uzak yangınlar kullanır (KapiManzarasi.alev). Tasarım: design/gdd/kapi-manzarasi.md
shader_type spatial;
render_mode blend_add, unshaded, depth_draw_never, cull_disabled, fog_disabled;

uniform sampler2D gurultu : repeat_enable, filter_linear;
uniform float parlaklik = 2.5;
uniform float hiz = 1.6;
uniform float tohum = 0.0;

void vertex() {
	// Y ekseninde kameraya dön (alev hep dik kalır).
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)) * length(MODEL_MATRIX[0].xyz), 0.0),
		vec4(0.0, length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
		vec4(normalize(INV_VIEW_MATRIX[2].xyz * vec3(1.0, 0.0, 1.0)) * length(MODEL_MATRIX[2].xyz), 0.0),
		MODEL_MATRIX[3]);
}

void fragment() {
	vec2 uv = UV;
	float t = TIME * hiz + tohum;
	// Yukarı akan iki katman gürültü: alev dili kıvrılır.
	float n1 = texture(gurultu, vec2(uv.x * 0.8 + tohum, uv.y * 0.9 + t * 0.9)).r;
	float n2 = texture(gurultu, vec2(uv.x * 1.7 - tohum, uv.y * 1.6 + t * 1.6)).r;
	float n = n1 * 0.6 + n2 * 0.4;
	float yukseklik = 1.0 - uv.y;               // 0 alt, 1 üst
	vec2 p = uv - vec2(0.5, 0.78);
	p.x += (n - 0.5) * 0.35 * yukseklik;         // üst kısım daha çok dalgalanır
	// Damla: altta geniş, yukarı doğru incelen.
	float en = mix(0.34, 0.04, smoothstep(0.0, 1.0, yukseklik));
	float alt = max(0.0, uv.y - 0.8) / 0.18;     // tabanda yuvarlak
	float d = length(vec2(abs(p.x) / en, alt));
	float govde = (1.0 - smoothstep(0.55, 1.0, d)) * smoothstep(0.0, 0.2, uv.y);
	govde *= smoothstep(0.0, 0.35, n + 0.25 - yukseklik * 0.55);
	float cekirdek = (1.0 - smoothstep(0.0, 0.5, d)) * smoothstep(0.55, 0.95, uv.y);
	vec3 kizil = vec3(0.9, 0.18, 0.02);
	vec3 turuncu = vec3(1.0, 0.45, 0.08);
	vec3 sari = vec3(1.0, 0.85, 0.45);
	vec3 renk = mix(kizil, turuncu, smoothstep(0.0, 0.5, govde));
	renk = mix(renk, sari, cekirdek);
	float a = clamp(govde, 0.0, 1.0);
	ALBEDO = renk * parlaklik * a;
	ALPHA = a;
}
