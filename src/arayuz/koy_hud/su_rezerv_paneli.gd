class_name SuRezervPaneli
extends RefCounted
## Mevcut pazarda tek kuyu doldurma düğmesi; ikinci kaynak paneli yok.
static func ekle(e: KoyEkrani, v: VBoxContainer) -> void:
 var y := e.oturum.yonetim
 var b := Button.new()
 b.name = "su_rezerv_doldur"
 b.text = "Kuyudan %d su ayır · %d kamu akçesi" % [int(SuDengesi.AYAR.doldurma_parti),int(SuDengesi.AYAR.doldurma_akce)]
 b.tooltip_text = SuDengesi.tip(y)
 b.disabled = not SuDengesi.doldurabilir(y)
 v.add_child(b)
 b.pressed.connect(func()->void:
  if SuDengesi.doldur(y):
   e._yenile()
   e._pazar_ac()
 )
