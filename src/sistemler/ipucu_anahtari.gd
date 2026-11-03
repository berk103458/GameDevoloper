## AYR-12: İpucu ve kademeli HUD anahtarları. Sıfırlama `ogretici.gorulen` listesini temizler.
extends RefCounted


static func gosterilir_mi(a: Ayarlar, kayit: IpucuKaydi, ipucu_id: String) -> bool:
	if a == null or kayit == null or not bool(a.al(&"ipuclari")):
		return false
	return not kayit.goruldu_mu(ipucu_id)


static func sifirla(kayit: IpucuKaydi) -> void:
	if kayit != null:
		kayit.sifirla()
