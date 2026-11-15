## HAR-03: mevcut haraç bandında tek kutu heyet ve aynı ödeme/ret API'leri.
class_name TekfurHeyetiPaneli
extends RefCounted
## Köyün var olan bant yüzeyini genişletir; ikinci HUD/modal açmaz.
static func kur(e: Control, v: VBoxContainer) -> void:
	var y: KoyYonetimi = e._y
	var h := HBoxContainer.new()
	v.add_child(h)
	var boy := float(TekfurHaracHeyeti.AYAR.yer_tutucu_boyutu)
	h.add_child(Kabuk.yer_tutucu("TekfurHeyetiYerTutucu",String(TekfurHaracHeyeti.AYAR.yer_tutucu_renk),Vector2(boy,boy)))
	var etiket: Label = e._etiket(h,TekfurHaracHeyeti.metin(TekfurHaracHeyeti.olay(y).tekfur_harac),Tema.KUCUK_PX)
	etiket.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	etiket.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	etiket.add_theme_color_override("font_color",Hud.UYARI)
	var tuslar := HBoxContainer.new()
	v.add_child(tuslar)
	var ode: Button = e._dugme(TranslationServer.translate("koy.harac.ode"),tuslar)
	ode.name = "TekfurHaracOde"
	ode.disabled = y.akce < y.a.harac_akce or y.kaynaklar.miktar("bugday") < y.a.harac_gida
	ode.pressed.connect(func() -> void:
		if y.harac_ode():
			Ses.cal(&"sfx_kese")
			e._yenile()
	)
	var red: Button = e._dugme(TranslationServer.translate("koy.harac.reddet"),tuslar)
	red.name = "TekfurHaracReddet"
	red.pressed.connect(func() -> void:
		y.harac_reddet()
		Ses.cal(&"sfx_saldiri",-6.0)
		e._yenile()
	)
