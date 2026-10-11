extends SceneTree
func gelen(id: StringName) -> Gelen:
 var g := Gelen.new()
 g.adli = true
 g.id = id
 g.ad_anahtari = "Kaynak kişi"
 g.gizli_bayraklar = ["sabotajci","hasta"] if id == &"chr_002" else ["casus"]
 return g
func _initialize() -> void:
 # Kaynak tur-offset/zehir testi; alışma kapısı ayrı tehdit_takvimi_test içindedir.
 preload("res://src/sistemler/tehdit_takvimi.gd").AYAR.tehdit_baslangic_gunu = 0
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat,56)
 var g := gelen(&"chr_002")
 var sonuc := o.karar_ver(g,&"kabul")
 var y := o.yonetim
 var k := y.koylu(int(sonuc.koylu_id))
 assert(k != null and not KuyuZehirleme.durum(y).kisiler[str(k.id)].cozuldu)
 var masum := y.kabul({"ad":"Masum", "adli_id":"chr_003"})
 var ol: Array[Dictionary] = []
 var stok := y.kaynaklar.miktar("gida")
 var rng := y._rng.state
 KuyuZehirleme.gece(y,{"taze":20},ol)
 assert(k.saglik == 100 and ol.is_empty() and y._rng.state == rng)
 y.gun = 2
 KuyuZehirleme.gece(y,{"taze":20},ol)
 assert(k.saglik == 96 and masum.saglik == 96 and y.kaynaklar.miktar("gida") == stok-2 and k.moral == y.a.baslangic_moral-3)
 assert(ol.size() == 1 and not String(ol[0].anahtar).contains(k.ad) and CasusGeceTakibi.acik_izler(y).is_empty() and y._rng.state == rng)
 assert(CasusGeceTakibi.durum(y).izler[0].durum == "zehirleme")
 var once := JSON.stringify(y.kaydet())
 KuyuZehirleme.gece(y,{"taze":20},ol)
 assert(JSON.stringify(y.kaydet()) == once and ol.size() == 1)
 var z := KoyYonetimi.kayittan(kat.koy_ayarlari,kat.binalar,JSON.parse_string(JSON.stringify(y.kaydet())))
 z.gun += 1
 KuyuZehirleme.gece(z,{"taze":20},ol)
 assert(z.koylu(k.id).saglik == 96 and ol.size() == 1 and KuyuZehirleme.tip(z).contains("2 kişi"))
 # Kapıdaki gerçek tam çözüm ve yalnız yol sırrı zehri durdurur; kaynak Resource değişmez.
 for bayrak in ["Flag_Sir_Tamamen_Cozuldu","Flag_Yol_Sirri_Acik"]:
  var q := Oturum.new(kat,77)
  var a := gelen(&"chr_009")
  a.chr_sorgusu().bayraklar[bayrak] = true
  var rr := q.karar_ver(a,&"kabul")
  q.yonetim.gun = 9
  var liste: Array[Dictionary] = []
  KuyuZehirleme.gece(q.yonetim,{"taze":20},liste)
  assert(liste.is_empty() and KuyuZehirleme.durum(q.yonetim).kisiler[str(rr.koylu_id)].cozuldu)
 # Abbas, taze su olmayan gün ve önce ayrılmış rezerv: sağlık tekrarlanmaz, gerçek fiil kaydı var.
 var q := Oturum.new(kat,42)
 var rr := q.karar_ver(gelen(&"chr_009"),&"kabul")
 q.yonetim.gun = 2
 q.yonetim.kaynaklar.ekle("su",10)
 var kayit: Array[Dictionary] = []
 KuyuZehirleme.gece(q.yonetim,{"taze":0},kayit)
 assert(q.yonetim.koylu(rr.koylu_id).saglik == 100 and q.yonetim.kaynaklar.miktar("su") == 10 and kayit.size() == 1)
 assert(KuyuZehirleme.durum(q.yonetim).icenen == 0)
 # Nöbetçi gözlemi gerçek zehir fiili tutanağını açar, ikinci zarar yok.
 var m := y.kabul({"ad":"Nöbetçi","sinif":"asker"})
 assert(y.muhafiz_ata(m.id))
 var eski: float = CasusDevriyesi.AYAR.fener_taban
 var ust: float = CasusDevriyesi.AYAR.yakalama_ust
 CasusDevriyesi.AYAR.fener_taban = 1.0
 CasusDevriyesi.AYAR.yakalama_ust = 1.0
 CasusDevriyesi.gece(y,ol)
 assert(CasusDevriyesi.durum(y).bekliyor and k.saglik == 96 and CasusGeceTakibi.acik_izler(y).size() == 1)
 CasusDevriyesi.AYAR.fener_taban = eski
 CasusDevriyesi.AYAR.yakalama_ust = ust
 # Rüşvet farklı kaynak tur4; kışla ve terminal saldırı üretmez.
 var b := Oturum.new(kat,41)
 var br := b.karar_ver(gelen(&"chr_002"),&"rusvet")
 b.yonetim.gun = 2
 var bl: Array[Dictionary] = []
 KuyuZehirleme.gece(b.yonetim,{"taze":20},bl)
 assert(bl.is_empty())
 b.yonetim.gun = 3
 KuyuZehirleme.gece(b.yonetim,{"taze":20},bl)
 assert(bl.size() == 1 and b.yonetim.koylu(br.koylu_id).saglik == 97)
 var h := Oturum.new(kat,61)
 var hr := h.karar_ver(gelen(&"chr_009"),&"kisla")
 h.yonetim.gun = 9
 var hl: Array[Dictionary] = []
 KuyuZehirleme.gece(h.yonetim,{"taze":20},hl)
 assert(hl.is_empty() and h.yonetim.koylu(hr.koylu_id).saglik == 100)
 var f := Oturum.new(kat,62)
 var fr := f.karar_ver(gelen(&"chr_009"),&"kabul")
 var fm := f.yonetim.kabul({"ad":"İkinci içen"})
 f.yonetim.gun = 2
 var fl: Array[Dictionary] = []
 KuyuZehirleme.gece(f.yonetim,{"taze":1},fl)
 assert(f.yonetim.koylu(fr.koylu_id).saglik == 96 and fm.saglik == 100 and KuyuZehirleme.durum(f.yonetim).icenen == 1)
 # Gerçek gece hook: harmadik yaşanan gece, su ve ölüm fazı aynı; kimseye sahte bayrak yazılmaz.
 var n := Oturum.new(kat,77)
 var nr := n.karar_ver(gelen(&"chr_002"),&"kabul")
 var ny := n.yonetim
 ny.kaynaklar.ekle("gida",100)
 ny.a.iyilesme = 0
 ny.gun = 2
 var gece := ny.gece()
 assert(ny.koylu(nr.koylu_id).saglik == 96 and KuyuZehirleme.durum(ny).tespit_gunu == 3)
 assert(gece.su.taze > 0 and not CasusGeceTakibi.durum(ny).izler.is_empty())
 assert(KuyuZehirleme.oku({"kisiler":{"a":{},"2":{"karar":"kabul","cozuldu":"yanlis"}}}).kisiler.is_empty())
 print("KUYU ZEHİRLEME: GEÇTİ")
 quit(0)
