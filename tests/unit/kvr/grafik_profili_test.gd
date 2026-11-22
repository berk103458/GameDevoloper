extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var ayar := Ayarlar.new("user://test_bug10_ayarlar.cfg")
	ayar.degerler[&"ekran_modu"] = &"pencere"
	var ekran := Node.new()
	root.add_child(ekran)
	var vp := SubViewport.new()
	vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_SMAA
	vp.msaa_3d = Viewport.MSAA_4X
	var smaa_olmayan := SubViewport.new()
	smaa_olmayan.msaa_3d = Viewport.MSAA_2X
	var alev := KapiManzarasi.alev(1.0)
	alev.layers = 3
	var cpu := CPUParticles3D.new()
	cpu.emitting = false
	var gpu := GPUParticles3D.new()
	gpu.emitting = true
	ekran.add_child(vp)
	ekran.add_child(smaa_olmayan)
	ekran.add_child(alev)
	ekran.add_child(cpu)
	ekran.add_child(gpu)
	var profil := GrafikProfiliAdaptoru.new()
	profil.ayarlar = ayar
	profil.hedef = ekran
	ekran.add_child(profil)
	_kontrol(alev.layers == 3 and gpu.emitting and not cpu.emitting, "Normal profil gerçek başlangıcı korur")
	_kontrol(vp.msaa_3d == Viewport.MSAA_4X, "Normal profil alt viewport MSAA ayarını korur")
	ayar.ayarla(&"grafik_profili", &"dusuk")
	_kontrol(alev.layers == 0 and not gpu.emitting and cpu.layers == 0, "Düşük profil shader ve CPU/GPU efektlerini kapatır")
	_kontrol(is_equal_approx(vp.scaling_3d_scale, 0.75) and is_equal_approx(root.scaling_3d_scale, 0.75), "Ana ve alt viewport 3B ölçeklenir")
	_kontrol(is_equal_approx(root.canvas_transform.get_scale().x, 1.0), "2B ölçek aynı kalır")
	_kontrol(vp.msaa_3d == Viewport.MSAA_DISABLED and vp.screen_space_aa == Viewport.SCREEN_SPACE_AA_SMAA, "Düşük profilde köyün SMAA etkisi kalır")
	_kontrol(smaa_olmayan.msaa_3d == Viewport.MSAA_2X, "SMAA kullanmayan görünümde MSAA korunur")
	alev.visible = false # Gündüz/gece görünürlüğü profile bağlı değildir.
	var yeni := KapiManzarasi.parcacik_alev(0.5, 1.0)
	ekran.add_child(yeni)
	await process_frame
	await process_frame
	_kontrol(yeni.layers == 0 and not yeni.emitting, "Sonradan eklenen efekt de düşük profili alır")
	ayar.ayarla(&"cozunurluk_3d", 50)
	ayar.ayarla(&"cozunurluk_3d", 12) # Geçersiz değer sessizce reddedilir.
	_kontrol(ayar.al(&"cozunurluk_3d") == 50 and is_equal_approx(vp.scaling_3d_scale, 0.5), "Bağımsız ölçek seçimi ve sınır kontrolü")
	ayar.yaz()
	var yuklenen := Ayarlar.new(ayar.yol)
	yuklenen.yukle()
	_kontrol(yuklenen.al(&"grafik_profili") == &"dusuk" and yuklenen.al(&"cozunurluk_3d") == 50, "Diskte profil ve özel ölçek korunur")
	DirAccess.remove_absolute(ayar.yol)
	ayar.ayarla(&"grafik_profili", &"normal")
	_kontrol(alev.layers == 3 and not alev.visible and gpu.emitting and not cpu.emitting and yeni.emitting, "Normal moda dönüş asıl katman/emisyonu ve güncel görünürlüğü korur")
	_kontrol(vp.msaa_3d == Viewport.MSAA_4X and vp.screen_space_aa == Viewport.SCREEN_SPACE_AA_SMAA, "Ölçek seçimi sonrası normal profil dört örnekli MSAA ayarını geri getirir")
	var panel := GrafikAyarlariPaneli.new()
	panel.ayarlar = ayar
	ekran.add_child(panel)
	panel._profil.item_selected.emit(1)
	panel._olcek.item_selected.emit(0)
	_kontrol(panel._profil.selected == 1 and panel._olcek.selected == 0, "Gerçek UI seçimi ayarlarla eşleşir")
	ayar.varsayilana_don()
	_kontrol(panel._profil.selected == 0 and panel._olcek.selected == 4 and alev.layers == 3, "Varsayılanlar UI ve sahnede canlı uygulanır")
	ekran.free()
	_kontrol(ayar.degisti.get_connections().is_empty(), "Sahne çıkışında ayar bağlantıları temizlenir")
	print("GRAFIK_PROFILI_TEST: GEÇTİ" if hata == 0 else "GRAFIK_PROFILI_TEST: HATA %d" % hata)
	quit(hata)

func _kontrol(kosul: bool, metin: String) -> void:
	if not kosul:
		hata += 1
		push_error(metin)
