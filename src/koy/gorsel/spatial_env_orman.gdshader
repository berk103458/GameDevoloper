// Orman kuşağı ağaçları (görsel tasarım md, madde 2): köy kamerasının eğimiyle pişirilmiş impostor atlası
// (tools/varlik/orman_pisir.gd). Her ağaç kameraya dönük, gövde dibinden dönen bir dörtgendir; gölge geçişinde
// ışığa döner, böylece ağaç biçimli gölge düşer. Örnek başı veri (INSTANCE_CUSTOM): r = atlas hücresi, g = ölçek,
// b = rüzgâr evresi. Dörtgen: x ∈ [-0.5, 0.5], y ∈ [0, 1], UV üstten (0) alta (1).
// Hedef: Forward+ (Compatibility'de de çalışır). Bütçe: ağaç başı 2 üçgen, 1 doku örneği; ~300 ağaç tek çizim çağrısı.
shader_type spatial;
render_mode skip_vertex_transform, diffuse_burley, cull_disabled;

group_uniforms atlas;
uniform sampler2D atlas : source_color, filter_linear_mipmap_anisotropic;
// Hücre başına (boy m, dip_v, -, -); sıra atlas sırası (4 sütun × 2 satır).
uniform vec4 hucreler[8];
group_uniforms gorunum;
uniform vec3 ton : source_color = vec3(0.86, 1.0, 0.82);
// Pişmiş görüntü yumuşak ışıkta soluk kalır: doygunluk çarpanı.
uniform float doygunluk = 1.35;
uniform float ruzgar = 0.025;

void vertex() {
	int h = int(INSTANCE_CUSTOM.r + 0.5);
	float olcek = INSTANCE_CUSTOM.g;
	vec4 bilgi = hucreler[h];
	float boy = bilgi.x * olcek;
	vec3 dip = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	vec3 sag = normalize(INV_VIEW_MATRIX[0].xyz);
	vec3 ust = normalize(INV_VIEW_MATRIX[1].xyz);
	// Görüntüdeki v satırı dipten (bilgi.y - v) × boy yukarıdadır.
	float v = 1.0 - VERTEX.y;
	float yukari = (bilgi.y - v) * boy;
	float salinim = sin(TIME * 1.3 + INSTANCE_CUSTOM.b * 6.28) * ruzgar * boy * max(yukari / boy, 0.0);
	vec3 w = dip + sag * (VERTEX.x * boy + salinim) + ust * yukari;
	VERTEX = (VIEW_MATRIX * vec4(w, 1.0)).xyz;
	// Aydınlatma: kameraya dönük ile yukarı arası (taç üstten ışık alsın).
	NORMAL = normalize(mix(vec3(0.0, 0.0, 1.0), (VIEW_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz, 0.55));
	vec2 hucre = vec2(float(h % 4), float(h / 4));
	UV = (hucre + UV) / vec2(4.0, 2.0);
}

void fragment() {
	vec4 t = texture(atlas, UV);
	vec3 gri = vec3(dot(t.rgb, vec3(0.3, 0.55, 0.15)));
	ALBEDO = mix(gri, t.rgb, doygunluk) * ton;
	ALPHA = t.a;
	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ROUGHNESS = 0.95;
	SPECULAR = 0.2;
}
