## EKO-08: mevcut pazar kartında gerçek vergi politikası seçimi.
class_name VergiPaneli
extends RefCounted
## Vergi düğmeleri yalnız kayıtlı seçimi değiştirir; tahsilat gece modelindedir.
static func ekle(ekran: KoyEkrani, ust: Control) -> void:
	var y := ekran.oturum.yonetim
	ekran._etiket(ust, VergiPolitikasi.metin(y), Tema.KUCUK_PX)
	var satir := HBoxContainer.new()
	ust.add_child(satir)
	for oran in VergiPolitikasi.AYAR:
		var d := ekran._dugme("Vergi · " + String(VergiPolitikasi.AYAR[oran].ad), satir)
		d.disabled = y.vergi_orani == oran
		d.pressed.connect(func() -> void:
			if ekran.oturum.yonetim != y: return
			if VergiPolitikasi.sec(y, oran):
				ekran._kart_kapat()
				ekran._pazar_ac()
		)
