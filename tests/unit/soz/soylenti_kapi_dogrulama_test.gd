extends SceneTree
## SOY-10: doğru ağ kaydı zarsız yüzleşir, yanlış kayıt tansiyonu +1 yapar, kayıt yoksa satır görünmez.
## Yol kapı adaptöründeki beyan defteri düğmesinden geçer.

const Kapi := preload("res://src/arayuz/chr_kapi_adaptoru.gd")
const Dogrulama := preload("res://src/kapi/soylenti_dogrulama.gd")


func _init() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var hatalar: Array[String] = []
	_metin_gomulu_mu(hatalar)
	if await _dogru(hatalar) != true:
		hatalar.append("doğru kayıt testi yarıda kaldı")
	if await _yanlis(hatalar) != true:
		hatalar.append("yanlış kayıt testi yarıda kaldı")
	if await _yok(hatalar) != true:
		hatalar.append("kayıtsız testi yarıda kaldı")
	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return
	print("SOY-10 GECTI")
	quit(0)


func _metin_gomulu_mu(hatalar: Array[String]) -> void:
	var yollar := [
		"res://src/kapi/soylenti_dogrulama.gd",
		"res://src/soz/celiski.gd",
		"res://src/arayuz/kapi/beyan_defteri_paneli.gd",
		"res://src/arayuz/chr_kapi_adaptoru.gd",
	]
	for yol in yollar:
		var kod := FileAccess.get_file_as_string(yol)
		if kod.contains("Köyde başka duydum") or kod.contains("köyde başka duydum"):
			hatalar.append("oyuncu metni koda gömüldü: %s" % yol)


func _oturum(tohum: int) -> Oturum:
	var kat := Katalog.new()
	kat.yukle()
	return Oturum.new(kat, tohum)


func _gelen(o: Oturum) -> Gelen:
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	return g


func _ekran(o: Oturum, hatalar: Array[String]) -> Control:
	var kod := GDScript.new()
	kod.source_code = "extends Control\nvar oturum\n"
	if kod.reload() != OK:
		hatalar.append("kapı kabuğu derlenemedi")
		return null
	var ekran := Control.new()
	ekran.set_script(kod)
	ekran.set("oturum", o)
	root.add_child(ekran)
	return ekran


func _panel(o: Oturum, gelen: Gelen, hatalar: Array[String]) -> BeyanDefteriPaneli:
	var ekran := _ekran(o, hatalar)
	if ekran == null:
		return null
	var eylemler := VBoxContainer.new()
	ekran.add_child(eylemler)
	var dugme := Kapi.beyan_defteri_dugmesi(ekran, gelen, eylemler) as Button
	if dugme == null or dugme.name != "BeyanDefteriDugmesi":
		hatalar.append("beyan defteri düğmesi kapı adaptöründen gelmedi")
		return null
	dugme.pressed.emit()
	await process_frame
	return ekran.get_node_or_null("BeyanDefteriPaneli") as BeyanDefteriPaneli


func _soylenti_dugmesi(panel: BeyanDefteriPaneli) -> Button:
	if panel == null:
		return null
	var bulunan := panel.find_children("Kayit_soylenti_*", "Button", true, false)
	if bulunan.is_empty():
		return null
	return bulunan[0] as Button


func _dogru(hatalar: Array[String]) -> bool:
	var o := _oturum(910)
	var gelen := _gelen(o)
	var sorgu := gelen.chr_sorgusu()
	if sorgu == null:
		hatalar.append("chr_001 sorgusu yok")
		return true
	var olay := "kapi_haksiz_ret_2_chr_001"
	var ag := SoylentiKoprusu.ag(o) as SoylentiAgi
	var eklenen: Dictionary = ag.soylenti_ekle(olay, "haksiz_ret", "1", true, {"gece": 2})
	if not bool(eklenen.get("olur", false)) or not bool(ag.ag_kayitlari[olay].get("dogru", false)):
		hatalar.append("doğru ağ kaydı açılmadı: %s" % str(eklenen))
		return true
	var kim := String(Dogrulama.kayit_kimligi(olay))
	sorgu.celiski_durumu.celiski_ekle("beyan_00", kim, "3.1", "zayif")
	var once := int(sorgu.tansiyon)
	var zar_once: Dictionary = sorgu.son_zar.duplicate(true)
	var panel := await _panel(o, gelen, hatalar)
	var dugme := _soylenti_dugmesi(panel)
	var ifade := GuvenliMetin.metin(Dogrulama.IFADE_ANAHTARI)
	if dugme == null or ifade.begins_with(GuvenliMetin.YOK) or not dugme.text.contains(ifade):
		hatalar.append("doğru kayıtta köyde başka duydum satırı yok")
		return true
	panel.kayit_sec_kimlikle("beyan_00")
	panel.kayit_sec_kimlikle(kim)
	var sonuc := panel.goster_bas()
	if not bool(sonuc.get("basarili", false)) or not bool(sonuc.get("yuzlesme_acildi", false)):
		hatalar.append("doğru kayıt yüzleşme dalına gitmedi: %s" % str(sonuc))
	if bool(sonuc.get("zayif_zar", true)) or String(sonuc.get("guc", "")) != "guclu":
		hatalar.append("zayıf çift zarsız geçmedi: %s" % str(sonuc))
	if int(sonuc.get("kanit_degistirici", -1)) != 0 or sorgu.dugum_id != &"3.1":
		hatalar.append("dal 3.1 açılmadı: dugum=%s sonuc=%s" % [String(sorgu.dugum_id), str(sonuc)])
	if int(sorgu.tansiyon) != once or int(sorgu.celiski_durumu.tansiyon) != 0:
		hatalar.append("doğru kayıtta tansiyon arttı: sorgu=%d celiski=%d" % [int(sorgu.tansiyon), int(sorgu.celiski_durumu.tansiyon)])
	if sorgu.son_zar != zar_once:
		hatalar.append("doğru kayıtta zar atıldı: %s" % str(sorgu.son_zar))
	panel.queue_free()
	await process_frame
	return true


func _yanlis(hatalar: Array[String]) -> bool:
	var o := _oturum(911)
	var gelen := _gelen(o)
	var sorgu := gelen.chr_sorgusu()
	if sorgu == null:
		hatalar.append("chr_001 sorgusu yok (yanlış)")
		return true
	var olay := "kapi_haksiz_ret_3_chr_001"
	var ag := SoylentiKoprusu.ag(o) as SoylentiAgi
	var eklenen: Dictionary = ag.soylenti_ekle(olay, "haksiz_ret", "2", false, {"gece": 3})
	if not bool(eklenen.get("olur", false)) or bool(ag.ag_kayitlari[olay].get("dogru", true)):
		hatalar.append("yanlış ağ kaydı dogru=false değil: %s" % str(eklenen))
		return true
	var kim := String(Dogrulama.kayit_kimligi(olay))
	var once := int(sorgu.tansiyon)
	var motor := o.soz_kaydi.motor
	var guven := motor.guven
	var sabir := motor.sabir
	var panel := await _panel(o, gelen, hatalar)
	var dugme := _soylenti_dugmesi(panel)
	if dugme == null:
		hatalar.append("yanlış kayıtta köyde başka duydum satırı yok")
		return true
	panel.kayit_sec_kimlikle("beyan_00")
	panel.kayit_sec_kimlikle(kim)
	var sonuc := panel.goster_bas()
	if bool(sonuc.get("basarili", true)) or bool(sonuc.get("yuzlesme_acildi", false)):
		hatalar.append("yanlış kayıtta yüzleşme açıldı: %s" % str(sonuc))
	if sorgu.dugum_id != &"00":
		hatalar.append("yanlış kayıt düğümü değiştirdi: %s" % String(sorgu.dugum_id))
	if int(sorgu.tansiyon) != once + 1:
		hatalar.append("tansiyon +1 değil: önce=%d sonra=%d" % [once, int(sorgu.tansiyon)])
	if int(sorgu.celiski_durumu.tansiyon) != 1 or int(sorgu.celiski_durumu.yanlis_sayisi) != 0:
		hatalar.append("yanlış sayıldı ya da tansiyon birikmedi: %s" % str(sonuc))
	if motor.guven != guven or motor.sabir != sabir:
		hatalar.append("muhafız yanılınca güven/sabır değişti: g=%d s=%d" % [motor.guven, motor.sabir])
	if bool(sonuc.get("zayif_zar", true)):
		hatalar.append("yanlış kayıtta zar istendi")
	panel.queue_free()
	await process_frame
	return true


func _yok(hatalar: Array[String]) -> bool:
	var o := _oturum(912)
	var gelen := _gelen(o)
	var panel := await _panel(o, gelen, hatalar)
	if _soylenti_dugmesi(panel) != null:
		hatalar.append("ağ yokken köyde başka duydum göründü")
	if o.has_meta(SoylentiKoprusu.META):
		hatalar.append("defter açılınca söylenti ağı kuruldu")
	if panel != null:
		panel.queue_free()
		await process_frame
	var ag := SoylentiKoprusu.ag(o) as SoylentiAgi
	ag.soylenti_ekle("kapi_haksiz_ret_4_yolcu_baska", "haksiz_ret", "9", true, {"gece": 4})
	var panel2 := await _panel(o, gelen, hatalar)
	if _soylenti_dugmesi(panel2) != null:
		hatalar.append("başka kişinin kaydı köyde başka duydum diye göründü")
	if panel2 != null:
		panel2.queue_free()
	await process_frame
	return true
