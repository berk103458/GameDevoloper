extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := BinaKatalogu.new()
 dene(kat.veri("agil").get("kurulabilir", false) and kat.slot("agil") == 1, "CHR ağıl gerçek katalog adaptörüdür")
 dene(kat.chr_hedef_turleri("Ağıl") == PackedStringArray(["agil"]), "CHR tür adı değişmez")
 var b := KoyBinasi.new()
 b.tur = "agil"
 dene(CobanSurusu.hazir(b), "Hazır ağıl")
 b.insa_kalan = 1
 dene(not CobanSurusu.hazir(b), "İnşa halindeki ağıl sürü üretmez")
 b.insa_kalan = 0
 b.tur = "ahir"
 dene(not CobanSurusu.hazir(b), "Ahır çekiş hayvanıyla karışmaz")
 var koyun := CobanSurusu.koyun()
 var parca := koyun.get_child_count() >= 6
 var hazir_model := bool(koyun.get_meta("statik_hayvan", false)) and koyun.get_node_or_null("bas") != null
 dene(parca or hazir_model, "Yünlü gövde, baş, dört bacak ya da hazır koyun modeli")
 koyun.free()
 var n := Node3D.new()
 CobanSurusu.agil_kur(n, 6, 6)
 dene(n.get_node_or_null("agil_kapisi") != null, "Dış JSON ile gerçek kapı kurulur")
 n.free()
 print("ÇOBAN SÜRÜSÜ: GEÇTİ" if hata == 0 else "ÇOBAN SÜRÜSÜ: KALDI")
 quit(hata)
