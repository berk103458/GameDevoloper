## İlk çeki hayvanı alımı mevcut kervana bağlıdır; Celep takvimi TUC-02'de genişletilir.
class_name CekiHayvaniPaneli
extends RefCounted
## Gerçek pazar kartına alım düğmelerini ve güncel sefer özetini bağlar.
static func ekle(ekran: KoyEkrani, ust: Control) -> void:
	var y := ekran.oturum.yonetim
	var l := y.lojistik
	var s := l.sefer(y)
	ekran._etiket(ust, "Çeki hayvanları: %d / %d · Sefer yükü %d · Süre %.1f gece" % [l.sayi(), l.kapasite(y), s.kapasite, s.sure], Tema.KUCUK_PX)
	for tur in CekiLojistigi.FIYAT:
		var ad: String = "Öküz" if tur == "okuz" else "İnek"
		var d := ekran._dugme("%s al · %d akçe" % [ad, CekiLojistigi.FIYAT[tur]], ust)
		d.disabled = not l.alinabilir(y, tur)
		d.tooltip_text = "Hazır ahırda boş yer ve kervan günü gerekir. Bir ahır %d hayvan barındırır." % int(CekiLojistigi.AYAR.ahir_yer)
		d.pressed.connect(func() -> void:
			if l.al(y, tur):
				ekran._kart_kapat()
				ekran._pazar_ac()
				ekran.hud.guncelle()
		)
