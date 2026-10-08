## TUC-02: mevcut çeki özeti ve Celep canlı hayvan alımı tek pazarda.
class_name CekiHayvaniPaneli
extends RefCounted
## Gerçek pazar kartına alım düğmelerini ve güncel sefer özetini bağlar.
static func ekle(ekran: KoyEkrani, ust: Control) -> void:
	var y := ekran.oturum.yonetim
	var l := y.lojistik
	var s := l.sefer(y)
	ekran._etiket(ust, "Çeki hayvanları: %d / %d · Sefer yükü %d · Süre %.1f gece" % [l.sayi(), l.kapasite(y), s.kapasite, s.sure], Tema.KUCUK_PX)
	CelepPazarAdaptoru.ekle(ekran, ust)
