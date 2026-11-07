## AYR-12: İpucu ve kademeli HUD anahtarları. Sıfırlama `ogretici.gorulen` listesini temizler.
extends RefCounted


static func kademeli_mi(a: Ayarlar) -> bool:
	return a == null or a.degerler.get(&"kademeli_hud", AyarlarEk.VARSAYILAN[&"kademeli_hud"]) == true


static func gosterim_acik(a: Ayarlar) -> bool:
	return a != null and kademeli_mi(a) and a.degerler.get(&"ipuclari", AyarlarEk.VARSAYILAN[&"ipuclari"]) == true


static func gosterilir_mi(a: Ayarlar, kayit: IpucuKaydi, ipucu_id: String) -> bool:
	if kayit == null or not gosterim_acik(a):
		return false
	return not kayit.goruldu_mu(ipucu_id)


static func sifirla(kayit: IpucuKaydi) -> void:
	if kayit != null:
		kayit.sifirla()
