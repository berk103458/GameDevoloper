## karakterler/CHR_001–030 sayfalarından üretilen adlı karakterler (tools/icerik/karakter_sayfalari.py). Düz betik:
##   godot --headless --path . -s tests/unit/karakter_sayfalari/karakter_sayfalari_test.gd   (çıkış 0 = geçti)
extends SceneTree

const SAYI := 30
const TEHLIKELI := 7

var _hata := 0


func _init() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	var bulunan := 0
	var tehlikeli := 0
	for n in range(1, SAYI + 1):
		var id := StringName("chr_%03d" % n)
		var kv := k.karakter(id)
		if kv == null:
			_esit("karakter var %s" % id, false, true)
			continue
		bulunan += 1
		if kv.tehlikeli:
			tehlikeli += 1
		var s := k.sohbet(kv.sohbet_id)
		_esit("açılış %s" % id, tr(s.acilis(1)) != "", true)
		_esit("kök soru ≥3 %s" % id, Array(s.soru_ust).count(-1) >= 3, true)
		_esit("takip soru var %s" % id, s.soru_anahtarlari.size() > 3, true)
		_esit("soru sınırı %s" % id, kv.azami_soru, 6)
		_esit("dört karar %s" % id, kv.karar_secenekleri.size(), 4)
	_esit("30 karakter", bulunan, SAYI)
	_esit("tehlikeli sayısı", tehlikeli, TEHLIKELI)
	# Kötü niyetliyi almak Orduyu düşürür; masumu reddetmek Halkı.
	_esit("Hamza kabul Ordu düşer", k.karakter(&"chr_001").etki_kabul[3] < 0, true)
	_esit("Meryem ret Halk düşer", k.karakter(&"chr_002").etki_ret[0] < 0, true)
	# Gelen soru sınırı: kendi sınırı yoksa genel ayar.
	var g := Gelen.new()
	_esit("genel sınır", g.soru_siniri(4), 4)
	g.azami_soru = 6
	_esit("kendi sınırı", g.soru_siniri(4), 6)
	# Oturum adlı geleni sayfa verisiyle kurar.
	var o := Oturum.new(k, 5)
	o.gun = 3
	o.kadro.iste(&"chr_021", o.gun)
	var c := o._adli_gelen(&"chr_021")
	_esit("gelen sınırı", c.azami_soru, 6)
	_esit("gelen niyeti", c.tehlikeli, false)
	# El eşyaları: tablodaki her tür kurulur, el adı geçerli; sırtta yükü modelde olan CHR_011 boş.
	var esyalar = JSON.parse_string(FileAccess.get_file_as_string(Dunya3B.EL_ESYALARI))
	_esit("eşya tablosu okunur", esyalar is Dictionary, true)
	if esyalar is Dictionary:
		for ad in esyalar:
			for parca in esyalar[ad]:
				var e := ElEsyasi.olustur(String(parca[0]))
				_esit("eşya kurulur %s %s" % [ad, parca[0]], e != null, true)
				_esit("el adı %s" % ad, String(parca[1]) in ["sag", "sol"], true)
				if e != null:
					e.free()
		_esit("CHR_011 eşyasız", esyalar.has("chr_011"), false)
		_esit("CHR_002 torba", esyalar.get("chr_002", []), [["torba", "sag"]])
	_esit("bilinmeyen eşya", ElEsyasi.olustur("yok_boyle"), null)
	print("KARAKTER SAYFALARI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
