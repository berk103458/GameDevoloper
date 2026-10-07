## Şifahane gerçek kurulabilir hizmet yapısı. Özel görsel yerine mevcut bina görünümü kullanılır.
class_name Sifahane
extends RefCounted
static func ekler() -> Dictionary:
	return {"sifahane": {"kategori": "hizmet", "boyut": [2, 2], "maliyet": {"odun": 6, "tas": 4, "kereste": 2}, "slot": 2, "insa_gun": 2, "kurulabilir": true, "uzmanlik": "cerrah", "receteler": {}}}
static func tedavi_kapasitesi(y: KoyYonetimi, bina_id: int = -1) -> int:
	if y.isyan_kalan >= 0: return 0
	var n := 0
	for b in y.binalar:
		if bina_id >= 0 and b.id != bina_id: continue
		if b.tur != "sifahane" or not b.hazir() or KanDavasi.engel(y, b.id): continue
		for k in y.calisanlar(b.id):
			if k.zanaat_turu in [ZanaatTuru.Tur.CERRAH, ZanaatTuru.Tur.OTACI] and YasRolleri.atanabilir(k, b.tur) and CirakEgitimi.saglam(k) and not IsMemnuniyeti.isyanci(k, y) and not ZanaatKazalari.durur(k): n += 1
	return n
