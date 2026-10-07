extends SceneTree
var hata := 0
func _initialize() -> void:
	var g := Gelen.new()
	g.id = &"chr_001"
	g.adli = true
	var s: ChrSorgusu = g.chr_sorgusu()
	var kaynak := s.karakter.diyalog_dugumleri.duplicate(true)
	_kontrol(DiyalogDeneyi.kilitle(s, 2)["ok"], "2 kilidi kurulur")
	s.tansiyon = 10
	s._dugume_git(s.dugum_id)
	_kontrol(s.tansiyon == 2 and not s.bayraklar["Flag_Kilitlendi"], "Seçim öncesi kilit transient panik oluşturmaz")
	_kontrol(s.secenek_sec(0) and s.tansiyon == 2 and not s.bayraklar["Flag_Kilitlendi"], "Gerçek seçenek delta ve yönlendirmesi 2 kilidine uyar")
	DiyalogDeneyi.kilitle(s, 5)
	s.tansiyon = 0
	_kontrol(s.tansiyon == 5, "5 kilidi azaltmayı da sınırlar")
	DiyalogDeneyi.kilitle(s, 9)
	_kontrol(s.tansiyon == 9 and s.bayraklar["Flag_Kilitlendi"] and not s.karar_acik(&"kabul"), "9 gerçek kalıcı panik ve kabul kilidi doğurur")
	DiyalogDeneyi.kilitle(s, 2)
	_kontrol(s.tansiyon == 2 and s.bayraklar["Flag_Kilitlendi"], "Tansiyon düşürme panik flagini geri almaz")
	DiyalogDeneyi.kilitle(s, -1)
	s.tansiyon = 7
	_kontrol(s.tansiyon == 7 and not s.has_meta(DiyalogDeneyi.META), "Kilidi çözünce doğal setter döner")
	_kontrol(s.karakter.diyalog_dugumleri == kaynak and not DiyalogDeneyi.kilitle(s, 4)["ok"] and not DiyalogDeneyi.kilitle(null, 2)["ok"], "Kaynak/JSON korunur, geçersiz kilit reddedilir")
	print("DİYALOG DENEYİ: GEÇTİ" if hata == 0 else "DİYALOG DENEYİ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
