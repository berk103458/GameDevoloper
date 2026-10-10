extends SceneTree
const NIHAI = preload("res://src/sistemler/nihai_son.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	for secim in [0, 1]:
		var o := Oturum.new(kat, 1414)
		for i in 6:
			var k := o.yonetim.kabul({"ad": "Levent %d" % i})
			k.saglik = 100
			if secim == 1 and i < 2:
				k.is_yeri = KoyYonetimi.MUHAFIZ
				k.zanaat_turu = ZanaatTuru.Tur.CIFTCI
				k.moral = 0
		o.gun = 8
		var olaylar: Array[Dictionary] = []
		SancakAskerTalebi.gece(o, {"gun": 7, "olaylar": olaylar})
		dene(o.olay_uygula(SancakAskerTalebi.olay(o), secim).ok, "Gerçek gönderim seçeneği %d" % secim)
		o.yonetim.asayis_riski = 60
		dene(NIHAI.son(o, &"zafer") == "beyin_uc_koyu", "Gönderim Bey sonunu açar")
		o.gun = 20
		SancakAskerTalebi.gece(o, {"gun": 19, "olaylar": olaylar})
		dene(o.sancak_asker_talebi.secim == -1 and o.sancak_asker_talebi.gonderilen.is_empty(), "Yeni ferman geçici seçimi temizler")
		for reddet in [false, true]:
			if reddet: dene(o.olay_uygula(SancakAskerTalebi.olay(o), 2).ok, "Sonraki ferman reddi")
			var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
			dene(NIHAI.son(geri, &"zafer") == "beyin_uc_koyu", "Yeni/ret ferman sonrası JSON devam geçmişi korur")
			var once := JSON.stringify(geri.kaydet())
			NIHAI.son(geri, &"zafer")
			dene(JSON.stringify(geri.kaydet()) == once, "Final salt okunur")
	# Eksik/uydurulmuş makbuz Bey başarısı değildir.
	var legacy := {"gun": 8, "son_gece": 8, "secim": 0, "bekliyor": false, "gonderilen": [1, 2]}
	dene(SancakAskerTalebi.oku(legacy).levent_gonderildi, "Kanıtlı legacy gönderim")
	legacy.secim = 1
	dene(SancakAskerTalebi.oku(legacy).levent_gonderildi, "Kanıtlı legacy isyancı gönderim")
	for ids in [[], [1], [1, 1], [-1, 2]]:
		legacy.gonderilen = ids
		dene(not SancakAskerTalebi.oku(legacy).levent_gonderildi, "Eksik kişi makbuzu başarı uydurmaz")
	legacy.gonderilen = [1, 2]
	for secim in [-1, 2]:
		legacy.secim = secim
		dene(not SancakAskerTalebi.oku(legacy).levent_gonderildi, "Kanıtsız geçmiş uydurulmaz")
	for v in [null, {}, {"levent_gonderildi": "true"}, {"levent_gonderildi": 1}]:
		dene(not SancakAskerTalebi.oku(v).levent_gonderildi, "Bozuk/eksik kalıcı alan kapalı")
	print("LEVENT GONDERIM GECMISI: GEÇTİ" if hata == 0 else "LEVENT GONDERIM GECMISI: KALDI")
	quit(hata)
