extends Node
class TestAna extends Ana:
	func _ready() -> void:
		ayarlar=Ayarlar.new("user://unused_isg02.cfg")
		katalog=Katalog.new(); katalog.yukle()
		oturum=Oturum.new(katalog,2002)
		kayit=GuvenliKayit.new("user://isg02_%d.json" % OS.get_process_id())
		theme=Tema.olustur(ayarlar)
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata+=1
		push_error(ad)
func _ready() -> void: call_deferred("_calistir")
func _calistir() -> void:
	get_tree().create_timer(90).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new(); add_child(ana)
	var y := ana.oturum.yonetim
	y.a=y.a.duplicate(true); y.a.ambar_taban_kapasite=10000
	y.kaynaklar=Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000,"tas":1000,"kereste":1000})
	y.akce=1000
	for tur in ["odunluk","kulube"]:
		dene(_kur(y,tur),"Gerçek yapı kuruldu: "+tur)
	var k := y.kabul({"ad":"Geçici işçi"})
	ana._koye_git()
	var ekran := ana._ekran as KoyEkrani
	await get_tree().process_frame
	var gurultu: NoiseTexture2D=ekran.sahne3b.arazi._zemin_mat.get_shader_parameter("gurultu")
	if gurultu.get_image()==null: await gurultu.changed
	KoyluKarti.ac(ekran,k.id)
	var sekmeler := _sekme(ekran._ust_kart)
	dene(sekmeler!=null and sekmeler.get_tab_count()==2,"Mevcut kartta yapı ve geçici iş sekmesi")
	if sekmeler!=null: sekmeler.current_tab=1
	var su_hedefi := _hedef(ekran._ust_kart,"su_tasima")
	dene(su_hedefi!=null and not su_hedefi.disabled,"Gerçek kurulabilir konutla su işi kartta açık")
	var hedef := _hedef(ekran._ust_kart,"dal_toplama")
	var kulp := _kulp(ekran._ust_kart)
	dene(hedef!=null and kulp!=null and not hedef.disabled,"Mevcut kulp ve uygun iş hedefi")
	if hedef!=null and kulp!=null:
		kulp.force_drag({},Label.new())
		var veri: Variant=kulp._get_drag_data(Vector2.ZERO)
		dene(ekran._ust_kart.visible,"Geçici iş hedefi sürüklerken kaybolmaz")
		dene(hedef._can_drop_data(Vector2.ZERO,veri),"Gerçek kulp verisi kabul edilir")
		var yanlis: Dictionary=veri.duplicate(true); yanlis.oturum=-1
		dene(not hedef._can_drop_data(Vector2.ZERO,yanlis),"Başka oturum ataması reddedilir")
		hedef._drop_data(Vector2.ZERO,veri)
		dene(GeciciIsler.secili(k)=="dal_toplama" and k.is_yeri==GeciciIsler.IS_YERI,"Gerçek kart sürükle-bırak ataması")
	var birak := InputEventMouseButton.new()
	birak.button_index=MOUSE_BUTTON_LEFT; birak.pressed=false
	get_viewport().push_input(birak)
	await get_tree().process_frame
	dene(ekran._is_adi(k).contains("Çalı") and not ekran._is_adi(k).contains("dal_toplama"),"İş adı metin tablosundan insan metni")
	var once := JSON.stringify(ana.oturum.kaydet())
	KoyluKarti.ac(ekran,k.id)
	dene(JSON.stringify(ana.oturum.kaydet())==once,"Sekmeyi açmak üretim/atama ilerletmez")
	var ikinci := _hedef(ekran._ust_kart,"su_tasima")
	dene(ikinci!=null and ikinci.disabled,"İkinci geçici iş düğmesi kapalı")
	GeciciIsler.birak(y,k)
	KoyluKarti.ac(ekran,k.id)
	var su_dugmesi := _hedef(ekran._ust_kart,"su_tasima")
	if su_dugmesi!=null: su_dugmesi.pressed.emit()
	dene(GeciciIsler.secili(k)=="su_tasima","Klavye/düğme alternatifi doğru su işini atar")
	ana.kayit.sil(); ana.queue_free()
	await get_tree().process_frame
	print("GEÇİCİ İŞ KARTI: GEÇTİ" if hata==0 else "GEÇİCİ İŞ KARTI: KALDI")
	await Ses.cik(hata)
func _hedef(n: Node,id: String) -> KoyGeciciIslerPaneli.IsHedefi:
	if n is KoyGeciciIslerPaneli.IsHedefi and n.is_id==id: return n
	for c in n.get_children():
		var h := _hedef(c,id)
		if h!=null: return h
	return null
func _sekme(n: Node) -> TabContainer:
	if n is TabContainer: return n
	for c in n.get_children():
		var h := _sekme(c)
		if h!=null: return h
	return null
func _kulp(n: Node) -> KoyluSuruklemeKulpu:
	if n is KoyluSuruklemeKulpu: return n
	for c in n.get_children():
		var h := _kulp(c)
		if h!=null: return h
	return null

func _kur(y: KoyYonetimi,tur: String) -> bool:
	for cy in y.izgara.boyut.y:
		for cx in y.izgara.boyut.x:
			var yer := Vector2i(cx,cy)
			if y.yerlesim(tur,yer).olur:
				var r := y.bina_kur(tur,yer)
				if r.olur:
					y.bina(r.id).insa_kalan=0
					return true
	return false
