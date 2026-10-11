extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var karakter := Dunya3B.karakter("chr_001")
	root.add_child(karakter)
	var klip_sayisi: int = karakter._oynatici.get_animation_list().size()
	var aktif := MeshInstance3D.new()
	aktif.mesh = BoxMesh.new()
	aktif.material_override = StandardMaterial3D.new()
	Pbr._onbellek["test_aktif"] = aktif.material_override
	root.add_child(aktif)
	var zayif := _yalniz_cache()
	var beklenen := {"sanat": Sanat._onbellek.size(), "malzeme": Pbr._onbellek.size(), "model": Dunya3B._onbellek.size(), "klip": KarakterModel._klip_onbellek.size(), "sekil": DurusDuzeltici._sekil_onbellek.size()}
	var bilgi := DusukBellekProfili.memory_free()
	_kontrol(bilgi.size() == 5 and bilgi == beklenen, "Beş önbelleğin tam sözleşmesi ve temizleme öncesi sayıları")
	_kontrol(Sanat._onbellek.is_empty() and DurusDuzeltici._sekil_onbellek.is_empty() and KapiManzarasi._gurultu == null, "Görsel/şekil/gürültü referansları da bırakılır")
	_kontrol(bilgi["malzeme"] >= 2 and bilgi["model"] > 0, "Gerçek cache girişleri raporlanır")
	_kontrol(zayif.get_ref() == null, "Yalnız cachein tuttuğu Resource bırakılır")
	_kontrol(is_instance_valid(aktif.material_override) and karakter._oynatici.get_animation_list().size() == klip_sayisi, "Aktif sahnenin malzeme/animasyonları korunur")
	_kontrol(Pbr._onbellek.is_empty() and Dunya3B._onbellek.is_empty() and KarakterModel._klip_onbellek.is_empty(), "Statik referanslar temizlenir")
	karakter.duygu("normal")
	await process_frame
	var yeni := Dunya3B.karakter("chr_001")
	root.add_child(yeni)
	_kontrol(is_instance_valid(yeni._oynatici) and not Dunya3B._onbellek.is_empty(), "Temizlik sonrası model yeniden yüklenebilir")
	var ayar := Ayarlar.new()
	ayar.degerler[&"grafik_profili"] = &"dusuk"
	var adapt := GrafikProfiliAdaptoru.new()
	adapt.ayarlar = ayar
	adapt.hedef = yeni
	yeni.add_child(adapt)
	_kontrol(Dunya3B._onbellek.is_empty(), "Düşük profil yeni sahne cachelerini bırakır")
	_kontrol(DusukBellekProfili.memory_free()["model"] == 0, "Tekrarlı temizlik güvenlidir")
	karakter.free()
	yeni.free()
	aktif.free()
	print("DÜŞÜK BELLEK: GEÇTİ" if hata == 0 else "DÜŞÜK BELLEK: KALDI")
	quit(hata)
func _yalniz_cache() -> WeakRef:
	var r := StandardMaterial3D.new()
	Pbr._onbellek["test_bosta"] = r
	return weakref(r)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
