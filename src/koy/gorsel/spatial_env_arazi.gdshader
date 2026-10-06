// Köy arazisi (görsel tasarım md, madde 1 ve 3): çimen, taşlı patika, çamur ve çiğnenmiş toprak / orman tabanı
// dokularını ızgaradan üretilen splat maskesine (KoyArazisi) ve eğime göre harmanlar. Köyün dışı yumuşak tepelere
// kalkar; kapıdan güneye giden toprak yol analitik çizilir. Yükseklik formülü KoyArazisi.yukseklik() ile aynıdır.
// Hedef: Forward+. Bütçe: parça başı 8 doku + 1 maske + 2 gürültü örneği (1K–2K dokular, ~30 MB VRAM).
shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;

group_uniforms dokular;
uniform sampler2D doku_cimen : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_cimen : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D doku_patika : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_patika : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D doku_camur : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_camur : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D doku_toprak : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D normal_toprak : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
group_uniforms maske;
// R: patika (yol, meydan), G: çamur, B: çiğnenmiş toprak, A: çimen yok (yapı, tarla).
uniform sampler2D maske_splat : hint_default_black, filter_linear;
uniform sampler2D gurultu : hint_default_white, filter_linear_mipmap, repeat_enable;
// Maskenin dünyadaki alanı: (sol x, üst z, genişlik m, -).
uniform vec4 maske_alani = vec4(-48.0, -48.0, 96.0, 0.0);
group_uniforms gorunum;
uniform vec3 cimen_ton : source_color = vec3(0.56, 0.7, 0.42);
uniform vec3 kuru_ton : source_color = vec3(0.78, 0.7, 0.5);
// Mevsim: 0 yeşil … 1 kuru/soluk (kış ve yaz sonu).
uniform float kuruluk : hint_range(0.0, 1.0) = 0.15;
group_uniforms arazi;
// Yükseklik: düzlük yarıçapı, tepe yarıçapı, kapı yolu x'i ve kapının z'si (KoyArazisi ile aynı).
uniform vec4 tepe = vec4(32.0, 70.0, 0.0, 25.0);
// Orman tabanının başladığı uzaklık.
uniform float orman_bas = 36.0;

varying vec3 dunya;
varying float egim;

float yukseklik(vec2 p) {
	float r = max(abs(p.x), abs(p.y));
	float k = smoothstep(tepe.x, tepe.y, r);
	float yol = smoothstep(3.0, 9.0, abs(p.x - tepe.z - sin((p.y - tepe.w) * 0.05) * 4.0));
	k *= mix(yol, 1.0, step(p.y, tepe.w));
	float n = sin(p.x * 0.045 + 1.3) * cos(p.y * 0.038 - 0.7) + sin(p.x * 0.11 + p.y * 0.07) * 0.45
		+ cos(p.y * 0.13 - p.x * 0.05) * 0.3;
	return k * (2.2 + n * 2.6);
}

void vertex() {
	vec3 w = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	w.y = yukseklik(w.xz);
	float e = 0.6;
	float hx = yukseklik(w.xz + vec2(e, 0.0)) - yukseklik(w.xz - vec2(e, 0.0));
	float hz = yukseklik(w.xz + vec2(0.0, e)) - yukseklik(w.xz - vec2(0.0, e));
	vec3 n = normalize(vec3(-hx, 2.0 * e, -hz));
	VERTEX = (inverse(MODEL_MATRIX) * vec4(w, 1.0)).xyz;
	NORMAL = normalize((inverse(MODEL_MATRIX) * vec4(n, 0.0)).xyz);
	dunya = w;
	egim = 1.0 - n.y;
}

// İki ölçekte örnekleme (karo tekrarını kırmak için) ve iri ölçekli renk dalgalanması.
vec3 iki_olcek(sampler2D d, vec2 uv, float k) {
	return mix(texture(d, uv).rgb, texture(d, uv * 0.37 + 0.21).rgb, k);
}

void fragment() {
	vec2 p = dunya.xz;
	float g1 = texture(gurultu, p * 0.013).r;
	float g2 = texture(gurultu, p * 0.071 + 0.4).r;
	vec4 m = texture(maske_splat, (p - maske_alani.xy) / maske_alani.z);
	// Kapıdan güneye giden toprak yol (maskenin dışına da uzanır).
	float yol_x = abs(p.x - tepe.z - sin((p.y - tepe.w) * 0.05) * 4.0);
	float kapi_yolu = (1.0 - smoothstep(1.3, 2.6 + g2, yol_x)) * step(tepe.w - 1.0, p.y);
	// Kenarlar gürültüyle kırılır: düz çizgili ızgara görünmesin.
	float patika = smoothstep(0.3, 0.7, max(m.r, kapi_yolu) + (g2 - 0.5) * 0.45);
	float camur = smoothstep(0.35, 0.7, m.g + (g2 - 0.5) * 0.5);
	float r = max(abs(p.x), abs(p.y));
	float orman = smoothstep(orman_bas, orman_bas + 10.0, r + (g1 - 0.5) * 12.0);
	float cignenmis = smoothstep(0.25, 0.65, m.b + (g2 - 0.5) * 0.4);
	float toprak = clamp(cignenmis + orman * 0.6 + smoothstep(0.08, 0.3, egim) * 0.7, 0.0, 1.0);

	float olcek_k = smoothstep(0.35, 0.65, g1);
	vec3 cimen = iki_olcek(doku_cimen, p / 7.0, olcek_k);
	cimen *= mix(cimen_ton, kuru_ton, clamp(kuruluk + (g1 - 0.5) * 0.5, 0.0, 1.0)) * 1.6;
	cimen *= mix(0.82, 1.12, g1);
	// Orman tabanı köy toprağından koyu ve yeşile çalar (iğne yaprak, yosun).
	vec3 toprak_r = iki_olcek(doku_toprak, p / 4.0, olcek_k) * mix(vec3(0.92, 0.88, 0.8), vec3(0.62, 0.66, 0.5), orman * (1.0 - cignenmis));
	vec3 renk = mix(cimen, toprak_r, toprak);
	renk = mix(renk, iki_olcek(doku_patika, p / 4.0, olcek_k) * vec3(0.84, 0.76, 0.66), patika);
	// Çamur dokusu kızıla çalar: yarı yarıya griye çekilip koyulaştırılır (ıslak, toprak rengi).
	vec3 camur_r = texture(doku_camur, p / 5.0).rgb;
	camur_r = mix(camur_r, vec3(dot(camur_r, vec3(0.3, 0.55, 0.15))), 0.55) * vec3(0.66, 0.62, 0.56);
	renk = mix(renk, camur_r, camur * 0.85);

	vec3 nm = texture(normal_cimen, p / 7.0).rgb;
	nm = mix(nm, texture(normal_toprak, p / 4.0).rgb, toprak);
	nm = mix(nm, texture(normal_patika, p / 4.0).rgb, patika);
	nm = mix(nm, texture(normal_camur, p / 5.0).rgb, camur);
	ALBEDO = renk;
	NORMAL_MAP = nm;
	NORMAL_MAP_DEPTH = 0.8;
	// Çamurlu yerler ıslak parlar.
	ROUGHNESS = mix(mix(0.95, 0.85, patika), 0.45, camur);
}
