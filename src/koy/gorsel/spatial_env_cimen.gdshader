// Rüzgârlı çimen tutamları (görsel tasarım md, madde 2): tek MultiMesh, gölge düşürmez. Tutam, splat maskesinde
// patika, yapı ya da tarla olan yerde (KoyArazisi maskesi) boyu sıfırlanarak gizlenir: yapı kurulunca yalnız maske
// değişir, örnekler yeniden dizilmez.
// Hedef: Forward+. Bütçe: tutam başı 5 üçgen, köşe başı 1 maske örneği, parça başı doku yok; ~6000 tutam. Kök (UV.y = 0) yerde sabit, uç (UV.y = 1) rüzgârla salınır.
shader_type spatial;
uniform float kar_ortusu : hint_range(0.0, 1.0) = 0.0;
render_mode cull_disabled, diffuse_burley;

group_uniforms maske;
uniform sampler2D maske_splat : hint_default_black, filter_linear;
uniform vec4 maske_alani = vec4(-48.0, -48.0, 96.0, 0.0);
group_uniforms renk;
uniform vec3 dip_renk : source_color = vec3(0.3, 0.36, 0.17);
uniform vec3 uc_renk : source_color = vec3(0.72, 0.74, 0.42);
uniform vec3 kuru_renk : source_color = vec3(0.72, 0.62, 0.4);
uniform float kuruluk : hint_range(0.0, 1.0) = 0.15;
group_uniforms;
// Tutam ucunun rüzgârla en çok kayması (m).
uniform float ruzgar = 0.18;

varying float uc;
varying float renk_k;

void vertex() {
	vec3 kok = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	vec4 m = texture(maske_splat, (kok.xz - maske_alani.xy) / maske_alani.z);
	float gizle = max(smoothstep(0.25, 0.5, m.r), smoothstep(0.3, 0.6, m.a));
	VERTEX *= 1.0 - gizle;
	uc = UV.y;
	renk_k = fract(sin(dot(kok.xz, vec2(12.9898, 78.233))) * 43758.5453);
	float dalga = sin(TIME * 1.7 + kok.x * 0.35 + kok.z * 0.22) + 0.4 * sin(TIME * 3.1 + kok.z * 0.9);
	VERTEX.x += dalga * ruzgar * UV.y * UV.y;
	VERTEX.z += dalga * ruzgar * 0.4 * UV.y * UV.y;
}

void fragment() {
	vec3 yesil = mix(dip_renk, uc_renk, uc);
	vec3 kuru = mix(dip_renk * 1.2, kuru_renk, uc);
	ALBEDO = mix(yesil, kuru, clamp(kuruluk + (renk_k - 0.5) * 0.5, 0.0, 1.0));
	ALBEDO = mix(ALBEDO, vec3(0.88, 0.93, 0.98), kar_ortusu);
	ROUGHNESS = 0.9;
	SPECULAR = 0.25;
	BACKLIGHT = vec3(0.25, 0.3, 0.15);
}
