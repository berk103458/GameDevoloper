extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 for n in range(1,31):
  var o:=Oturum.new(kat,n)
  var id:=StringName("chr_%03d"%n)
  var g:=o._adli_gelen(id)
  var s: ChrSorgusu=g.chr_sorgusu()
  var v: KarakterVerisi=s.karakter
  var kaynak:=var_to_str(v)
  s.obje_incele(1)
  s.obje_incele(2)
  s.gorsel_incele()
  var bulunan: Dictionary=s.ipuclari.duplicate(true)
  var bayrak: Dictionary=s.bayraklar.duplicate(true)
  var rr:=o.karar_ver(g,&"kabul")
  var k:=o.yonetim.koylu(rr.koylu_id)
  dene(k!=null,"Gerçek kabul kişi: "+String(id))
  if k==null: continue
  var d:=DivanKanit.durum(k)
  var izin:=DivanKanit.ipuclari(k)
  var ids: Array=[]
  for a in bulunan:
   if bulunan[a]==true and izin.has(String(a)): ids.append(String(a))
  dene(d.ipuclar.size()==ids.size() and d.sunulan.is_empty() and not d.itiraf,"Kaynak keşfi birebir devam: "+String(id))
  for a in ids: dene(a in d.ipuclar,"Kaynak kimlik aynen: "+String(id))
  dene(var_to_str(v)==kaynak and s.ipuclari==bulunan and s.bayraklar==bayrak,"Kapı/source immutable: "+String(id))
  var geri:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
  dene(DivanKanit.durum(geri.yonetim.koylu(k.id))==d,"Tam Oturum JSON: "+String(id))
  var stok:=o.yonetim.kaynaklar.kaydet()
  var rng:=o.yonetim._rng.state
  var para:=o.muhafiz_akce
  dene(not DivanKanit.sun(o.yonetim,k.id,"Clue_foreign") and not DivanKanit.sorgula(o.yonetim,k.id),"Gözlemsiz/foreign reddi: "+String(id))
  dene(o.yonetim.kaynaklar.kaydet()==stok and o.yonetim._rng.state==rng and o.muhafiz_akce==para,"Kasa/stok/zar: "+String(id))
  var eski:=Koylu.kayittan({"id":k.id,"adli_id":String(id)})
  dene(DivanKanit.durum(eski).ipuclar.is_empty(),"Eski kayıt keşif uydurmaz: "+String(id))
  var bozuk:=DivanKanit.oku(k,{"ipuclar":ids+["Clue_foreign",42],"sunulan":["Clue_foreign"],"itiraf":true})
  dene(bozuk.ipuclar.size()==ids.size() and bozuk.sunulan.is_empty() and not bozuk.itiraf,"Bozuk kayıt kaynak sınırı: "+String(id))
 print("DIVAN KANIT SÖZLEŞMESİ 30 CHR: GEÇTİ" if hata==0 else "DIVAN KANIT SÖZLEŞMESİ: KALDI")
 quit(hata)
