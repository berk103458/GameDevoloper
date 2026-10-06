// Köy arazisi: çim / toprak / çamur, maske dokusuyla karıştırılır (R = toprak/yol, G = çamur).
// Dokular kodda üretilen dikişsiz gürültüdür; maske köy yerleşiminden boyanır (Arazi.gd).
shader_type spatial;
render_mode diffuse_burley, specular_schlick_ggx;

uniform sampler2D maske : filter_linear, repeat_disable;
uniform sampler2D cim_doku : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D toprak_doku : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D camur_doku : source_color, filter_linear_mipmap, repeat_enable;
uniform sampler2D yukseklik : filter_linear, repeat_enable;
uniform float doku_olcek = 0.12;
uniform float arazi_boyu = 160.0;
uniform float tepe_yuksekligi = 2.2;
// Bu yarıçapın içi düz kalır (köy alanı).
uniform float duz_yaricap = 30.0;
uniform float kenar_yumusaklik = 6.0;

varying vec3 dunya_konum;

void vertex() {
	vec3 d = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float r = length(d.xz);
	float t = smoothstep(duz_yaricap, duz_yaricap + 25.0, r);
	float h = texture(yukseklik, d.xz / 70.0).r;
	VERTEX.y += (h - 0.35) * tepe_yuksekligi * t + t * t * 1.5;
	dunya_konum = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 uv_dunya = dunya_konum.xz * doku_olcek;
	vec2 uv_maske = dunya_konum.xz / arazi_boyu + 0.5;
	vec4 m = texture(maske, uv_maske);
	// Kenar kırılması: maske sınırını gürültüyle bozar, düz daire görünmez.
	float kir = texture(yukseklik, dunya_konum.xz * 0.35).r - 0.5;
	float toprak_payi = smoothstep(0.35, 0.65, m.r + kir * 0.35);
	float camur_payi = smoothstep(0.4, 0.7, m.g + kir * 0.3);
	vec3 cim = texture(cim_doku, uv_dunya).rgb;
	vec3 cim_iri = texture(cim_doku, uv_dunya * 0.13).rgb;
	cim = mix(cim, cim_iri, 0.45);
	vec3 toprak = texture(toprak_doku, uv_dunya * 1.4).rgb;
	vec3 camur = texture(camur_doku, uv_dunya * 1.1).rgb;
	vec3 renk = mix(cim, toprak, toprak_payi);
	renk = mix(renk, camur, camur_payi);
	ALBEDO = renk;
	ROUGHNESS = mix(0.95, 0.55, camur_payi);
	SPECULAR = mix(0.2, 0.45, camur_payi);
}
