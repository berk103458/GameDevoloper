## OGR-39: Eşin akşam öğretisi, Oturum.aksam_sohbeti_hazirla üzerinden.
extends SceneTree

const KANCA = preload("res://src/debug/ilk_saat_kancasi.gd")
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI = preload("res://src/sistemler/kapi_acilis_olayi.gd")

var _hata := 0


func _init() -> void:
	_gun1_kullanilmamis()
	_arac_kullanilan_kayit()
	_heybe_kullanildiysa_heybe_dali_yok()
	_gun4_dal_yok()
	_olu_es_ve_meclis_sohbeti_acmaz()
	if _hata > 0:
		push_error("OGR-39 KALDI: %d" % _hata)
		quit(1)
		return
	print("OGR-39 GECTI")
	quit(0)


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OGR-39: " + mesaj)


func _katalog() -> Katalog:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		_kontrol(false, "Katalog yüklenmedi")
	return kat


func _oturum(kat: Katalog, gun_no: int) -> Oturum:
	AksamSohbeti.sifirla()
	var o := Oturum.new(kat, 3939)
	ACILIS.kur(o)
	o.bayraklar[KAPI.BITTI] = true
	o.gun = gun_no
	o.aksam_sohbeti_ekle("aileyi_bolmek", 1)
	return o


func _yukle(kat: Katalog, o: Oturum) -> Oturum:
	var ham: Variant = JSON.parse_string(JSON.stringify(o.kaydet()))
	_kontrol(ham is Dictionary, "Kayıt sözlüğü bozuldu")
	if not ham is Dictionary:
		return o
	var yuklu := Oturum.kayittan(kat, ham)
	_kontrol(yuklu != null, "Kayıt yüklenmedi")
	return yuklu if yuklu != null else o


func _gun1_kullanilmamis() -> void:
	var kat := _katalog()
	var o := _yukle(kat, _oturum(kat, 0))
	var sohbet := o.aksam_sohbeti_hazirla({})
	var anahtar := String(sohbet.get("ogreti_anahtar", ""))
	var metin := GuvenliMetin.metin(anahtar)
	_kontrol(String(sohbet.get("konu_id", "")) == "aileyi_bolmek", "Gün 1 sohbeti oyun yolundan açılmalı")
	_kontrol(int(sohbet.get("ogreti_dal", 0)) == 1, "Gün 1, araç kullanılmamışken dal açılmalı")
	_kontrol(anahtar == "es.aksam.ogreti.heybe", "Kullanılmayan ilk araç heybe olmalı")
	_kontrol(not metin.is_empty() and not metin.begins_with(GuvenliMetin.YOK) and metin != anahtar, "Metin anahtarı geçerli olmalı")
	_kontrol(metin.count(".") + metin.count("!") + metin.count("?") == 1, "Dal en çok tek cümle olmalı")
	_kontrol((sohbet.get("es_replikleri", []) as Array).has(metin) or (sohbet.get("es_replikleri", []) as Array).has(String(TranslationServer.translate(anahtar))), "Cümle akşam sohbetinin repliklerinde durmalı")


func _arac_kullanilan_kayit() -> void:
	var kat := _katalog()
	var o := _oturum(kat, 0)
	KANCA.arac(o, "heybe")
	KANCA.arac(o, "beyan")
	var yuklu := _yukle(kat, o)
	var sohbet := yuklu.aksam_sohbeti_hazirla({})
	_kontrol(not sohbet.is_empty(), "Araç kullanılan kayıtta sohbetin kendisi kapanmamalı")
	_kontrol(int(sohbet.get("ogreti_dal", -1)) == 0, "Aracı kullanan kayıtta dal 0")
	_kontrol(String(sohbet.get("ogreti_anahtar", "x")) == "", "Kullanılan araçta metin anahtarı boş kalmalı")


func _heybe_kullanildiysa_heybe_dali_yok() -> void:
	var kat := _katalog()
	var o := _oturum(kat, 0)
	KANCA.arac(o, "heybe")
	o.gun = 1
	var sohbet := o.aksam_sohbeti_hazirla({})
	_kontrol(String(sohbet.get("ogreti_anahtar", "")) == "es.aksam.ogreti.beyan", "Heybe kullanıldıysa dal heybe cümlesini seçmemeli")
	_kontrol(int(sohbet.get("ogreti_dal", 0)) == 1, "Kullanılmayan beyan dalı açık kalmalı")


func _gun4_dal_yok() -> void:
	var kat := _katalog()
	var ucuncu := _oturum(kat, 2).aksam_sohbeti_hazirla({})
	_kontrol(int(ucuncu.get("ogreti_dal", 0)) == 1, "Gün 3 dalı açık olmalı")
	var dorduncu := _oturum(kat, 3).aksam_sohbeti_hazirla({})
	_kontrol(String(dorduncu.get("konu_id", "")) == "aileyi_bolmek", "Gün 4 sohbeti açılmalı")
	_kontrol(int(dorduncu.get("ogreti_dal", -1)) == 0, "Gün 4+ dal 0")


func _olu_es_ve_meclis_sohbeti_acmaz() -> void:
	var kat := _katalog()
	var olu := _oturum(kat, 0)
	var es_id := int(ACILIS.durum(olu).get("es_id", -1))
	var es := olu.yonetim.koylu(es_id)
	_kontrol(es != null, "Açılış eşi kurulmalı")
	if es != null:
		es.saglik = 0
	_kontrol(olu.aksam_sohbeti_hazirla({}).is_empty(), "Eş ölmüşken sohbet açılmamalı")
	var meclis := _oturum(kat, 1)
	_kontrol(meclis.aksam_sohbeti_hazirla({"meclis_gecesi": true}).is_empty(), "Meclis gecesinde sohbet açılmamalı")
