## Ziyaret başına debug kilidi; kaynak JSON / kalıcı panik kuralı değişmez.
class_name DiyalogDeneyi
extends RefCounted
const META := &"debug_tansiyon_kilidi"

static func tansiyon(s: RefCounted, deger: int) -> int:
	return int(s.get_meta(META)) if s.has_meta(META) else clampi(deger, 0, 10)

static func kilitle(s: RefCounted, deger: int) -> Dictionary:
	if s == null or deger not in [-1, 2, 5, 9]:
		return {"ok": false, "neden": "Aktif CHR sorgusu ve doğal/2/5/9 değeri gerekli."}
	if deger == -1:
		if s.has_meta(META): s.remove_meta(META)
	else:
		s.set_meta(META, deger)
		s.tansiyon = deger
		# Var olan panik yönlendirmesi/ziyaret flagi kullanılır, kilit geri alınmaz.
		s._dugume_git(s.dugum_id)
		s.tansiyon_degisti.emit(s.tansiyon)
	return {"ok": true, "kilit": deger, "tansiyon": s.tansiyon}

static func uygun(ana: Node) -> bool:
	return NpcCagirma.uygun(ana) and ana.get("_ust") == null and ana.get("_ekran").get("_gelen") != null and not ana.get("_ekran").has_node("ChrInceleme")

static func uygula(ana: Node, beklenen: Gelen, deger: int) -> Dictionary:
	if not uygun(ana) or ana.get("_ekran").get("_gelen") != beklenen:
		return {"ok": false, "neden": "Sorgu değişti veya modal açık; eski kilit uygulanmadı."}
	var s := beklenen.chr_sorgusu()
	var r := kilitle(s, deger)
	if r["ok"]:
		var e: Node = ana.get("_ekran")
		e.call("_karar_goster" if e.get("evre") == &"karar" else "_sohbet_goster")
	return r

static func adim(ana: Node, beklenen: Gelen, denenen: Dictionary = {}) -> Dictionary:
	if not uygun(ana) or ana.get("_ekran").get("_gelen") != beklenen:
		return {"ok": false, "neden": "Sorgu değişti veya hazır değil; otomatik akış durdu."}
	var e: Node = ana.get("_ekran")
	if e.get("evre") == &"karar": return {"ok": true, "bitti": true, "neden": "Karar ekranı; kabul/ret oyuncuya bırakıldı."}
	var s := beklenen.chr_sorgusu()
	if s != null:
		var d: Dictionary = s.karakter.diyalog_dugumu(s.dugum_id)
		var secenekler: Array = d.get("secenekler", [])
		var indeks := -1
		for i in secenekler.size():
			if s.secenek_acik(secenekler[i], i) and not denenen.has("%s:%d" % [s.dugum_id, i]):
				indeks = i
				break
		if indeks < 0 and not secenekler.is_empty():
			return {"ok": false, "neden": "Denenmemiş açık seçenek yok; döngü/ipuçları için otomatik akış durdu."}
		var adim_id := "%s:%d" % [s.dugum_id, indeks]
		if denenen.has(adim_id): return {"ok": false, "neden": "Diyalog döngüsü; aynı geçiş tekrar seçilmedi."}
		var kapsayici: Node = e.get("_secenekler")
		for p in kapsayici.get_children():
			if p.is_queued_for_deletion(): continue
			if p.get_script() != preload("res://src/arayuz/chr_diyalog_paneli.gd"): continue
			var b: Button = p.get_node_or_null("Secenek%d" % indeks) if indeks >= 0 else p.get_child(p.get_child_count() - 1) as Button
			if b == null or b.disabled: return {"ok": false, "neden": "Diyalog düğmesi hazır değil."}
			denenen[adim_id] = true
			b.pressed.emit()
			return {"ok": true, "bitti": e.get("evre") == &"karar", "neden": "Gerçek CHR diyalog düğmesi ilerletildi."}
		return {"ok": false, "neden": "CHR paneli bulunamadı."}
	# Eski soru akışı: üst sorusu açık ilk soruyu normal ekrandan sorar.
	var sorulan: Array = e.get("_sorulan")
	for i in beklenen.sorular.size():
		var ust: int = beklenen.soru_ust[i] if i < beklenen.soru_ust.size() else -1
		if i not in sorulan and (ust < 0 or ust in sorulan):
			e.call("_soru_sor", i)
			return {"ok": true, "bitti": e.get("evre") == &"karar", "neden": "Gerçek eski kapı sorusu soruldu."}
	e.call("_karar_goster")
	return {"ok": true, "bitti": true, "neden": "Sorular bitti; karar ekranı açıldı."}
