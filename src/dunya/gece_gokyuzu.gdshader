// Gece gokyuzu: ay isigi altinda lacivert 13. yuzyil Anadolu gecesi (ana menu).
shader_type sky;

group_uniforms gokyuzu;
uniform vec3 ufuk_rengi : source_color = vec3(0.106, 0.153, 0.251); // ~#1b2740, hafif puslu ufuk
uniform vec3 tepe_rengi : source_color = vec3(0.027, 0.043, 0.086); // ~#070b16, tepe noktasi
group_uniforms;

group_uniforms yildizlar;
uniform float yildiz_yogunlugu : hint_range(0.0, 2.0) = 1.0; // 0 = yildiz yok
group_uniforms;

group_uniforms bulutlar;
uniform float bulut_yogunlugu : hint_range(0.0, 2.0) = 1.0;
uniform vec3 bulut_rengi : source_color = vec3(0.102, 0.133, 0.2); // ~#1a2233
group_uniforms;

group_uniforms ay;
uniform vec3 ay_yonu = vec3(-0.55, 0.42, -0.72); // aya dogru yon (normalize edilir)
uniform float ay_boyut : hint_range(0.005, 0.2) = 0.035; // aci yaricapi (radyan)
group_uniforms;

// --- Yardimci fonksiyonlar ---
vec3 hash33(vec3 p) {
	p = fract(p * vec3(0.1031, 0.1030, 0.0973));
	p += dot(p, p.yxz + 33.33);
	return fract((p.xxy + p.yxx) * p.zyx);
}

float hash21(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash21(i);
	float b = hash21(i + vec2(1.0, 0.0));
	float c = hash21(i + vec2(0.0, 1.0));
	float d = hash21(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < 5; i++) {
		v += a * vnoise(p);
		p = p * 2.03 + vec2(17.1, 9.2);
		a *= 0.5;
	}
	return v;
}

// Tek katman yildiz: her hucrede jitter'li tek nokta, mesafeyle yumusak daire.
float yildiz_katmani(vec3 dir, float olcek, float esik, float yaricap, float tohum) {
	vec3 p = dir * olcek + tohum;
	vec3 cell = floor(p);
	vec3 f = fract(p);
	vec3 h = hash33(cell);
	if (h.x > esik) return 0.0;
	vec3 nokta = 0.25 + 0.5 * hash33(cell + 7.7); // hucre kenarina tasmasin
	float d = length(f - nokta);
	float parlak = 0.35 + 0.65 * h.y * h.y; // yildiz basina parlaklik farki
	float titreme = 1.0 + 0.15 * sin(TIME * (0.6 + h.z * 1.2) + h.y * 40.0); // yavas, kucuk titreme
	float s = 1.0 - smoothstep(0.0, yaricap, d);
	return s * s * parlak * titreme;
}

void sky() {
	vec3 dir = normalize(EYEDIR);
	float y = dir.y;
	vec3 ay = normalize(ay_yonu);

	// --- Gradyan ---
	vec3 col;
	if (y < 0.0) {
		col = ufuk_rengi * 0.6; // yer zaten ortuyor
	} else {
		float t = pow(y, 0.55);
		col = mix(ufuk_rengi, tepe_rengi, t);
	}

	float cosAy = dot(dir, ay);

	// --- Bulut yogunlugu (yildizlari kapatmak icin once hesaplanir) ---
	float bulut = 0.0;
	float kenar = 0.0;
	if (y > 0.0) {
		vec2 q = dir.xz / (y + 0.15);
		vec2 kayma = vec2(TIME * 0.004, TIME * 0.0015); // cok yavas surunme
		vec2 pq = q * vec2(0.9, 1.8) + kayma;
		pq += 0.35 * vec2(fbm(pq * 1.7 + 3.0), fbm(pq * 1.7 - 5.0)); // ince dalgalanma
		float n = fbm(pq * 1.6);
		// 5-35 derece yukseklik bandi
		float bant = smoothstep(0.05, 0.14, y) * (1.0 - smoothstep(0.34, 0.62, y));
		bulut = smoothstep(0.46, 0.78, n) * bant * bulut_yogunlugu;
		bulut = clamp(bulut, 0.0, 1.0);
		kenar = clamp(bulut * (1.0 - bulut) * 4.0, 0.0, 1.0); // bulutun ince kenar bolgesi
	}

	// --- Yildizlar ---
	float ufuk_solma = smoothstep(0.14, 0.4, y); // ~8 derece altinda yok
	float yogun_artis = 0.55 + 0.45 * smoothstep(0.2, 0.9, y); // tepeye dogru daha sik
	float yildiz = 0.0;
	yildiz += yildiz_katmani(dir, 55.0, 0.16 * yildiz_yogunlugu * yogun_artis, 0.16, 0.0);
	yildiz += 0.8 * yildiz_katmani(dir, 120.0, 0.18 * yildiz_yogunlugu * yogun_artis, 0.2, 31.0);
	yildiz *= ufuk_solma * 2.0;
	yildiz *= 1.0 - bulut * 0.95; // bulut arkasindaki yildizlar sonuk
	col += vec3(0.85, 0.9, 1.0) * yildiz;

	// --- Ay halesi (genis soluk + siki parlak) ---
	float ang = acos(clamp(cosAy, -1.0, 1.0));
	vec3 hale_renk = vec3(0.65, 0.78, 1.0);
	float genis = exp(-ang * 4.5) * 0.22;
	float siki = exp(-ang / (ay_boyut * 2.2)) * 0.45;
	col += hale_renk * (genis + siki) * (y > -0.1 ? 1.0 : 0.0);

	// --- Bulutlar ---
	vec3 bulut_col = bulut_rengi;
	// ay isigiyla hafif aydinlanma
	float ay_yakin = exp(-ang * 3.0);
	bulut_col += vec3(0.22, 0.27, 0.36) * ay_yakin * 0.8;
	// gumus kenar: ay yonune yakin bulut kenarlari
	float gumus = kenar * exp(-ang * 5.0);
	bulut_col += vec3(0.75, 0.85, 1.0) * gumus * 1.1;
	col = mix(col, bulut_col, bulut * 0.85);

	// --- Ay diski ---
	if (cosAy > 0.0 && ang < ay_boyut * 1.5) {
		vec3 up = abs(ay.y) < 0.99 ? vec3(0.0, 1.0, 0.0) : vec3(1.0, 0.0, 0.0);
		vec3 tx = normalize(cross(up, ay));
		vec3 ty = cross(ay, tx);
		vec2 uv = vec2(dot(dir, tx), dot(dir, ty)) / ay_boyut;
		float r = length(uv);
		float kenar_aa = 1.0 - smoothstep(1.0 - 0.06, 1.0, r); // antialias kenar
		float z = sqrt(max(1.0 - r * r, 0.0));
		float limb = 0.55 + 0.45 * pow(z, 0.5); // kenarda koyulasma
		// krater lekeleri
		float k = fbm(uv * 3.2 + 4.0);
		float k2 = vnoise(uv * 9.0 + 11.0);
		float leke = 1.0 - 0.28 * smoothstep(0.5, 0.75, k) - 0.10 * k2;
		vec3 disk = vec3(0.914, 0.925, 0.937) * 5.0 * limb * leke;
		// bulut ayin onunden gecerse hafif kapatsin
		disk *= 1.0 - bulut * 0.2;
		col = mix(col, disk, kenar_aa);
	}

	COLOR = col;
}
