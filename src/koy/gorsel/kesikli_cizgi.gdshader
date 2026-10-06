// İnşa önizlemesi: yarı saydam hayalet model + yatay kesikli çizgiler, yavaş akar.
shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, cull_back;

uniform vec4 renk : source_color = vec4(0.85, 0.68, 0.38, 0.35);
uniform vec4 cizgi_renk : source_color = vec4(0.95, 0.8, 0.5, 0.85);
uniform float aralik = 0.35;
uniform float kalinlik = 0.08;

varying vec3 dunya;

void vertex() {
	dunya = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float y = fract((dunya.y + TIME * 0.25) / aralik);
	float cizgi = step(1.0 - kalinlik / aralik, y);
	// Kesik: çizgi boyunca açık-kapalı.
	float kesik = step(0.5, fract((dunya.x + dunya.z) * 1.6));
	float c = cizgi * kesik;
	ALBEDO = mix(renk.rgb, cizgi_renk.rgb, c);
	ALPHA = mix(renk.a, cizgi_renk.a, c);
}
