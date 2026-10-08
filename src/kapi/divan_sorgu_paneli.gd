## CAS-06: var olan divan listesinde dar kanıt sun/sorgula işlemi; ayrı HUD/kart verisi yok.
class_name DivanSorguPaneli
extends RefCounted
## Her seçili kişide aynı kaynak Clue devamını göster; keşfedilmemiş kanıt kapalıdır.
static func kur(e: DivanEkrani,v: VBoxContainer,id: int) -> void:
 if v.has_node("divan_sorgu"):
  var once := v.get_node("divan_sorgu")
  v.remove_child(once)
  once.queue_free()
 var n := VBoxContainer.new()
 n.name = "divan_sorgu"
 v.add_child(n)
 var y := e.oturum.yonetim
 var k := y.koylu(id)
 if k == null: return
 var d := DivanKanit.durum(k)
 var bilgi := Label.new()
 bilgi.text = "Kapıdan gelen kanıtlar · %d bulundu, %d sunuldu" % [d.ipuclar.size(),d.sunulan.size()]
 bilgi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 n.add_child(bilgi)
 var kaynak := DivanKanit.ipuclari(k)
 for clue in d.ipuclar:
  DivanKanitKarti.ekle(e,n,id,String(clue),kaynak[clue],d)
 var sorgu := Button.new()
 sorgu.name = "divan_sorgula"
 sorgu.text = "Tutanaktaki fiili kabul ediyorum." if d.itiraf else "Sunulan kanıtlarla sorgula"
 sorgu.tooltip_text = "Gözlenmiş fiil, en az iki bağımsız kanıt ve kapıda bulunmuş yük/suç aleti gerekir."
 sorgu.disabled = d.itiraf or not DivanKanit.yeterli(k,d) or DivanOturumu.izler(y,id).is_empty()
 if d.itiraf: sorgu.add_theme_color_override("font_disabled_color",Renkler.KUL)
 sorgu.custom_minimum_size.y = 42
 n.add_child(sorgu)
 sorgu.pressed.connect(func() -> void:
  if DivanKanit.sorgula(y,id): e._goster(id)
 )
