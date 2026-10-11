## TEK-07: debug kaynağı aynı KRI-04 su kullanıcıları, zar ve vaka sınırını kullanır.
extends SceneTree
var kat: Katalog
var hata := 0
var kontrol := 0

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	for tohum in range(1, 21):
		_su_ve_rng(tohum)
		_hekim_su_icer(tohum)
	_rezerv_gecesi()
	print("TEK-07 KUYU ENJEKTÖRÜ HEKİM: GEÇTİ (%d kontrol)" % kontrol if hata == 0 else "TEK-07 KUYU ENJEKTÖRÜ HEKİM: KALDI")
	quit(hata)

func hazir(tohum: int, n: int = 12) -> Oturum:
	var o := Oturum.new(kat, tohum)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	for i in n: y.kabul({"ad": "Su kullanıcısı %d" % i})
	var bina: KoyBinasi
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if bina == null and y.yerlesim("sifahane", h).olur:
				bina = y.bina(y.bina_kur("sifahane", h).id)
				bina.insa_kalan = 0
	var hekim := y.kabul({"ad": "Hekim", "zanaat_turu": "CERRAH", "stat": 8})
	dene(bina != null and y.ata(hekim.id, bina.id) and HekimIlac.etkin(y), "Hazır Şifahanede yetkin hekim")
	return o

func _su_ve_rng(tohum: int) -> void:
	var o := hazir(tohum)
	var y := o.yonetim
	var hekim: Koylu = y.koylular.back()
	var rng := y._rng.state
	dene(KrizEnjektoru.tetikle(o, "kuyu").ok, "Enjektör gerçek kuyu kaynağını kurar")
	dene(y._rng.state == rng and y.koylular.all(func(k: Koylu) -> bool: return not SaglikYoneticisi.hasta(k) and not k.bayrak_var("hasta")), "Enjeksiyon toplu hastalık/hasar veya zar üretmez")
	var geri := hazir(tohum)
	dene(KrizEnjektoru.tetikle(geri, "kuyu").ok, "Aynı tohumda ikinci enjektör")
	var dogal := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	KuyuKirliligi.temizle(dogal.yonetim)
	KuyuKirliligi.kirlet(dogal.yonetim)
	var su := {"taze": 6 * maxi(1, SuDengesi.gerek(y) / y.nufus())}
	var zar := RandomNumberGenerator.new()
	zar.state = rng
	var beklenen: Array[int] = []
	for k in KuyuKirliligi.icenler(y, su):
		if beklenen.size() == SaglikYoneticisi.AZAMI_YENI: break
		if zar.randi_range(1, 100) <= int(SaglikYoneticisi.AYAR.tifo.risk): beklenen.append(k.id)
	KrizEnjektoru.gece(y, [])
	KuyuKirliligi.gece(y, su, [])
	KrizEnjektoru.gece(geri.yonetim, [])
	KuyuKirliligi.gece(geri.yonetim, su, [])
	KuyuKirliligi.gece(dogal.yonetim, su, [])
	var bulunan: Array = y.koylular.filter(func(k: Koylu) -> bool: return SaglikYoneticisi.hasta(k)).map(func(k: Koylu) -> int: return k.id)
	dene(bulunan == beklenen and y._rng.state == zar.state, "KRI-04 olasılığı/köy RNG'si ve iki vaka sınırı")
	dene(y.kaydet() == geri.yonetim.kaydet(), "Aynı tohum/kayıt aynı sonuç ve RNG")
	for i in y.koylular.size():
		dene(y.koylular[i].enfeksiyon == dogal.yonetim.koylular[i].enfeksiyon and y.koylular[i].saglik == dogal.yonetim.koylular[i].saglik, "Debug ve doğal KRI-04 aynı kişisel sonuç")
	dene(y._rng.state == dogal.yonetim._rng.state, "Debug ikinci zehir zarı çekmez")
	for k in y.koylular.slice(6):
		dene(not SaglikYoneticisi.hasta(k) and not k.bayrak_var("hasta") and k.saglik == 100, "Taze su içmeyende hastalık/hasar yok")
	dene(not SaglikYoneticisi.hasta(hekim) and HekimIlac.etkin(y), "Su içmeyen sağlıklı hekim etkin kalır")
	var once := y.kaydet()
	KuyuKirliligi.gece(y, su, [])
	dene(y.kaydet() == once, "Aynı gece ikinci vaka/RNG yok")

func _hekim_su_icer(tohum: int) -> void:
	var o := hazir(tohum, 0)
	var y := o.yonetim
	var hekim: Koylu = y.koylular.back()
	dene(KrizEnjektoru.tetikle(o, "kuyu").ok, "Hekim de taze su kullanıcısı olabilir")
	KrizEnjektoru.gece(y, [])
	KuyuKirliligi.gece(y, {"taze": SuDengesi.gerek(y)}, [])
	dene(HekimIlac.etkin(y) == not SaglikYoneticisi.hasta(hekim), "Su içen hekimde yalnız gerçek hastalık hizmeti kapatır")

func _rezerv_gecesi() -> void:
	var o := hazir(207, 2)
	var y := o.yonetim
	y.kaynaklar.ekle("su", SuDengesi.gerek(y) * 4)
	dene(KrizEnjektoru.tetikle(o, "kuyu").ok, "Rezervli köye enjektör uygulanır")
	for i in 3:
		# Günlük taze akış önceden ayrılmış; gece yalnız depodaki suyu tüketir.
		var su := SuDengesi.durum(y)
		su.gun = y.gun
		su.adet = int(SuDengesi.AYAR.kuyu_gunluk)
		y.set_meta(SuDengesi.META, su)
		var rapor := y.gece()
		dene(int(rapor.su.taze) == 0, "Gerçek gece taze kuyu suyu içilmedi")
		dene(y.koylular.all(func(k: Koylu) -> bool: return not SaglikYoneticisi.hasta(k) and not k.bayrak_var("hasta")), "Gerçek gece rezerv kullanıcılarına hasta vermez")
		dene(HekimIlac.etkin(y), "Gerçek gece sağlıklı hekim etkin")
	dene(KrizEnjektoru.kalan(y) == 0 and not KuyuKirliligi.kirli(y), "Üç gece sonunda debug ve gerçek kuyu süresi biter")

func dene(ok: bool, mesaj: String) -> void:
	kontrol += 1
	if not ok:
		hata += 1
		push_error(mesaj)
