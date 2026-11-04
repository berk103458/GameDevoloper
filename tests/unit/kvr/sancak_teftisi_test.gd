extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func kur(kat: Katalog,rusvet: int) -> Oturum:
 var o:=Oturum.new(kat,915)
 for i in rusvet:
  var g:=Gelen.new()
  g.id=StringName("teftis_%d"%i)
  o.karar_ver(g,&"rusvet")
 return o
func rapor(gece_no: int) -> Dictionary:
 var olaylar: Array[Dictionary]=[]
 return {"gun":gece_no-1,"son":"","olaylar":olaylar}
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var ayar:=SancakTeftisi.AYAR
 SancakTeftisi.AYAR=ayar.duplicate(true)
 SancakTeftisi.AYAR.bulma_olasiligi=1.0
 var sinir:=kur(kat,19)
 var sinir_rng:=sinir._rng.state
 var sinir_raporu:=rapor(6)
 SancakTeftisi.gece(sinir,sinir_raporu)
 dene(sinir.yonetim.son=="" and sinir.sancak_teftisi.sonuc=="temiz" and sinir._rng.state==sinir_rng,"DEN-44: 19 rüşvette risk zarı yok")
 var o:=kur(kat,20)
 var rng:=o._rng.state
 var r:=rapor(5)
 SancakTeftisi.gece(o,r)
 dene(r.olaylar.is_empty() and o._rng.state==rng,"Erken gece çekiliş yok")
 var cash:=o.muhafiz_akce
 var kamu:=o.koy_akce
 var stok:=o.yonetim.kaynaklar.kaydet()
 r=rapor(6)
 SancakTeftisi.gece(o,r)
 dene(o.yonetim.son==String(SancakTeftisi.SON_AZIL) and r.son==o.yonetim.son and r.olaylar.size()==1,"Gerçek rüşvet+kişisel kasa azil")
 dene(o.muhafiz_akce==cash and o.koy_akce==kamu and o.yonetim.kaynaklar.kaydet()==stok,"Teftiş çift müsadere/para silme yapmaz")
 var once:=JSON.stringify(o.kaydet())
 SancakTeftisi.gece(o,r)
 dene(JSON.stringify(o.kaydet())==once and r.olaylar.size()==1,"Tek gece/terminal idempotansı")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(geri!=null and geri.yonetim.son==o.yonetim.son and geri.sancak_teftisi==SancakTeftisi.oku(o.sancak_teftisi),"JSON sonuç ve terminal devamı")
 var legal:=kur(kat,0)
 legal.muhafiz_akce=1000
 rng=legal._rng.state
 r=rapor(6)
 SancakTeftisi.gece(legal,r)
 dene(legal.yonetim.son=="" and legal.sancak_teftisi.sonuc=="temiz" and legal._rng.state==rng,"Meşru kişisel para suç değil; zar yok")
 var bos:=kur(kat,70)
 bos.muhafiz_akce=0
 bos.muhafiz_esyalari=[{"adet":0}]
 rng=bos._rng.state
 r=rapor(6)
 SancakTeftisi.gece(bos,r)
 dene(bos.yonetim.son=="" and bos._rng.state==rng,"Boş/satılmış içerik risk oluşturmaz")
 bos.sancak_teftisi={}
 bos.muhafiz_esyalari=[{"ad":"Gerçek kişisel içerik","adet":1}]
 r=rapor(6)
 SancakTeftisi.gece(bos,r)
 dene(bos.yonetim.son==String(SancakTeftisi.SON_IDAM) and bos.sancak_teftisi.esya==1,"Yalnız eşya + ağır gerçek yozlaşma idam")
 var gizli:=kur(kat,20)
 SancakTeftisi.AYAR.bulma_olasiligi=0.0
 r=rapor(6)
 SancakTeftisi.gece(gizli,r)
 dene(gizli.yonetim.son=="" and gizli.sancak_teftisi.sonuc=="bulunamadi","Bulunamama dalı")
 rng=gizli._rng.state
 SancakTeftisi.gece(gizli,r)
 dene(gizli._rng.state==rng and r.olaylar.size()==1,"Tekrar zar/olay yok")
 gizli=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(gizli.kaydet())))
 SancakTeftisi.AYAR.bulma_olasiligi=1.0
 r=rapor(11)
 SancakTeftisi.gece(gizli,r)
 dene(gizli.yonetim.son==String(SancakTeftisi.SON_AZIL) and gizli.sancak_teftisi.son_gece==11,"Reload sonrası sıradaki teftiş")
 var biten:=kur(kat,70)
 biten.yonetim.son=KoyYonetimi.SON_TEKFUR
 rng=biten._rng.state
 r=rapor(6)
 SancakTeftisi.gece(biten,r)
 dene(biten.yonetim.son==KoyYonetimi.SON_TEKFUR and biten._rng.state==rng and r.olaylar.is_empty(),"Mevcut terminal ezilmez")
 var gece:=kur(kat,20)
 gece.yonetim.kabul({"ad":"Sağ kalan köylü"})
 gece.gun=5
 gece.yonetim.kaynaklar.ekle("gida",100)
 gece.yonetim.kaynaklar.ekle("su",100)
 var tam:=gece.gece_sonu()
 dene(tam.son==SancakTeftisi.SON_AZIL and tam.rapor.son==String(SancakTeftisi.SON_AZIL) and tam.olay==null and tam.olaylar.back().has("sancak_teftisi"),"Tam gece sonucu mevcut rapor ve terminale bağlandı")
 dene(IflasYoneticisi.olay_metin(tam.olaylar.back()).contains("azledildi") and not SancakTeftisi.son_metni(tam.son).metin.contains("arayuz.son"),"Son/rapor insan metni")
 dene(SancakTeftisi.tip(gece).contains("11. gece"),"Sıradaki tarih gerçek sayaca göre")
 dene(SancakTeftisi.oku(null).son_gece==-1 and SancakTeftisi.oku({"son_gece":"6","zar":"0","sonuc":"uydurma"}).sonuc=="","Eski/bozuk optional kayıt güvenli")
 SancakTeftisi.AYAR=ayar
 print("SANCAK TEFTIS: GEÇTİ" if hata==0 else "SANCAK TEFTIS: KALDI")
 quit(hata)
