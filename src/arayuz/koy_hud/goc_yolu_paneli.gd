## HAR-05: mevcut pazar kartına tek yol temizliği eylemi; ikinci HUD yok.
class_name GocYoluPaneli
extends RefCounted
## Mevcut durum ve gerçek model eylemi; kart yenilenirken tek çağrı.
static func ekle(e: Control,kok: VBoxContainer) -> void:
	var o: Oturum=e.oturum
	var l: Label=e._etiket(kok,GocYoluGuvenligi.tip(o),Tema.KUCUK_PX)
	l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	var d: Button=e._dugme(String(GocYoluGuvenligi.AYAR.dugme),kok)
	d.name="goc_yolu_temizle"
	d.disabled=not GocYoluGuvenligi.uygun(o)
	d.pressed.connect(func() -> void:
		var r:=GocYoluGuvenligi.temizle(o)
		if r.ok:
			e._kart_kapat()
			e._pazar_ac()
			e.hud.guncelle()
	)
