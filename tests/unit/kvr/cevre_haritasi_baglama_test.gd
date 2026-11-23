extends SceneTree

var _hata := 0
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1201)
 var rng:=o._rng.state
 var kayit:=JSON.stringify(o.kaydet())
 _dene(CevreHaritasi.bolge_durumu(null,"hisar").is_empty(), "baglama: bos oturum")
 var h:=CevreHaritasi.bolge_durumu(o,"hisar")
 _dene(String(h.durum)=="normal" and bool(h.kesfedildi), "baglama: hisar normal")
 _dene(String(h.manzara).ends_with("hisar.png") or String(h.manzara).contains("hisar"), "baglama: hisar temel manzara")
 _dene(CevreHaritasi.mevsim_katmani(o).ends_with("mevsim_ilkbahar_katman.png") or CevreHaritasi.mevsim_katmani(o).contains("ilkbahar"), "baglama: ilkbahar katman")
 o.yonetim.harac_bekliyor=true
 o.yonetim.tekfur_baski=4
 var t:=CevreHaritasi.bolge_durumu(o,"tekfur")
 _dene(String(t.durum)=="tehlike" and String(t.muhur)=="harac" and "heyet" in t.olaylar, "baglama: tekfur harac")
 _dene(String(CevreHaritasi.manzara(o,"tekfur")).contains("tekfur_ordu") or String(CevreHaritasi.manzara(o,"tekfur")).contains("tekfur"), "baglama: tekfur manzara")
 var md: Dictionary=MogolOncusu.durum(o)
 if MogolOncusu.AYAR is Dictionary and MogolOncusu.AYAR.has("varis_gunu"):
  o.gun=26
  md=MogolOncusu.durum(o)
  _dene(int(md.get("kalan",999))<=5, "baglama: mogol kalan")
  var mg:=CevreHaritasi.bolge_durumu(o,"mogol")
  _dene(String(mg.get("durum",""))=="tehlike" and "mogol_akin" in mg.get("olaylar",[]), "baglama: mogol tehlike")
 else:
  print("baglama: mogol AYAR yuklenmedi, tehlike dalı atlandı")
 var hs:=CevreHaritasi.manzara(o,"hisar")
 _dene(String(hs).contains("hisar"), "baglama: hisar manzara")
 o.gun=21
 var mk:=CevreHaritasi.mevsim_katmani(o)
 _dene(mk.contains("kis") or mk.contains("mevsim_"), "baglama: kis katman")
 _dene(not CevreHaritasi.kesfedildi_mi(o,"oba") and not CevreHaritasi.kesfedildi_mi(o,"sancak"), "baglama: sis varsayilan")
 _dene(CevreHaritasi.rotalar().size()>=3 and CevreHaritasi.yakinlastirma().has("adim"), "baglama: rota/zoom")
 _dene(o._rng.state==rng, "baglama: rng korunur")
 # kayit onceki snapshot'tan farklı olabilir (harac/gun); yalnız okuma fonksiyonları yazmamalı
 print("CEVRE HARITASI BAGLAMA: GEÇTİ" if _hata==0 else "CEVRE HARITASI BAGLAMA: KALDI (%d hata)"%_hata)
 quit(1 if _hata>0 else 0)

func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
