extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1010)
 dene(MuhafizEpilogu.durum(o,&" ").is_empty() and MuhafizEpilogu.durum(o,&"").is_empty(),"Aktif/unknown oyun epilogue değil")
 o.yonetim.adalet=80
 for son in [&"zafer",&"isyan",&"tekfur",&"halk_kirildi"]:
  dene(MuhafizEpilogu.durum(o,son).dal=="adil_kahraman","Muhafız adaleti köy zaferinden bağımsız")
 o.yonetim.adalet=79
 dene(MuhafizEpilogu.durum(o,&"zafer").dal=="evine_donus","Adalet eşiği altında kahraman yok")
 o.yonetim.adalet=100
 o.bayraklar[&"rusvet_sayisi"]=4
 dene(MuhafizEpilogu.durum(o,&"tekfur").dal=="adil_kahraman","Yoz sınırı20 dahil")
 o.bayraklar[&"rusvet_sayisi"]=5
 dene(MuhafizEpilogu.durum(o,&"zafer").dal=="evine_donus","Yoz21 üstü kahraman değil")
 o.bayraklar[&"rusvet_sayisi"]=0
 o.yonetim.adalet=70
 o.koy_akce=100
 for i in 7:
  o.gun=i
  dene(KasaTransferi.uygula(o,"zimmet",10),"Gerçek günlük zimmet makbuzu")
 o.muhafiz_akce=50
 for son in [&"zafer",&"tekfur"]:
  dene(MuhafizEpilogu.durum(o,son).dal=="venedik_kacagi","Yoz70 ve özel50 köy sonucundan bağımsız Venedik")
 o.muhafiz_akce=49
 dene(MuhafizEpilogu.durum(o,&"zafer").dal=="parasiz_surgun","Kaçış için harcanmış kasa yetmez")
 o.koy_akce=1000000
 o.muhafiz_esyalari.append({"id":"test","adet":1000})
 dene(MuhafizEpilogu.durum(o,&"tekfur").dal=="parasiz_surgun","Kamu/eşya değeri nakit yerine sayılmaz")
 o.muhafiz_akce=1000000
 dene(MuhafizEpilogu.durum(o,SancakTeftisi.SON_IDAM).dal=="idam","İdam kaçıştan önce")
 dene(MuhafizEpilogu.durum(o,SancakTeftisi.SON_AZIL).dal=="azil","Azil kaçıştan önce")
 var once:=JSON.stringify(o.kaydet())
 var rng:=o._rng.state
 for i in 3: MuhafizEpilogu.durum(o,&"zafer")
 dene(once==JSON.stringify(o.kaydet()) and o._rng.state==rng,"Okuma saf, para/kayıt/RNG tüketmez")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(MuhafizEpilogu.durum(geri,&"zafer")==MuhafizEpilogu.durum(o,&"zafer"),"Tam JSON aynı kader")
 var z:=Oturum.new(kat,1011)
 z.muhafiz_akce=1000000
 dene(MuhafizEpilogu.durum(z,&"zafer").dal=="evine_donus","Meşru kişisel zenginlik tek başına kaçak değil")
 z.bayraklar[&"rusvet_sayisi"]=13
 dene(MuhafizEpilogu.durum(z,&"zafer").dal=="evine_donus","Yoz65 kaçış eşiği altında")
 z.bayraklar[&"rusvet_sayisi"]=14
 dene(MuhafizEpilogu.durum(z,&"zafer").dal=="venedik_kacagi","Gerçek tek rüşvet sayacı da kader kaynağı")
 var metin:=MuhafizEpilogu.metin(z,&"zafer","Köy zaferi")
 dene(metin.begins_with("Köy zaferi") and metin.contains("Venedik") and metin.contains("Muhafızın kaderi"),"Köy anlatısı korunur, tek muhafız sonu eklenir")
 dene(MuhafizEpilogu.metin(z,&"bilinmeyen","eski")=="eski","Unknown legacy metin değiştirilmez")
 print("MUHAFIZ EPILOGU: GEÇTİ" if hata==0 else "MUHAFIZ EPILOGU: KALDI")
 quit(hata)
