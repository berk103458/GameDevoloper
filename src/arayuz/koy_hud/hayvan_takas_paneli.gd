## TUC-14: aynı pazar hayvan satırının geri satış ve katkı açıklaması.
class_name HayvanTakasPaneli
extends RefCounted
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e._y
 e._etiket(ust, "Barınan öküz: %d · inek: %d. Öküz tarla/bostan +%d%%, inek ağıl +%d%%, koç kendi ağılı +%d%%; üst çarpan ×%.2f." % [CanliHayvanTakasi.barinan(y, "okuz"), CanliHayvanTakasi.barinan(y, "inek"), roundi(float(CanliHayvanTakasi.AYAR.tarla_okuz_bonus)*100), roundi(float(CanliHayvanTakasi.AYAR.agil_inek_bonus)*100), roundi(float(CanliHayvanTakasi.AYAR.agil_koc_bonus)*100), float(CanliHayvanTakasi.AYAR.carpan_ust)], Tema.KUCUK_PX)
 var satir := HBoxContainer.new()
 ust.add_child(satir)
 for t in CelepHamdullah.AYAR.hayvanlar:
  var tur := String(t)
  var d := e._dugme("%s geri sat · %d akçe" % [CelepHamdullah.AYAR.hayvanlar[t].ad, CanliHayvanTakasi.fiyat(tur)], satir)
  d.name = "hayvan_geri_sat_" + tur
  d.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  d.disabled = not CanliHayvanTakasi.satilabilir(y, tur)
  d.tooltip_text = "Tek hayvan Celep'e gider; gelir kamuya, barınak yeri boşalır. Alım fiyatının yarısı aşağı yuvarlanır."
  d.pressed.connect(func() -> void:
   if CanliHayvanTakasi.sat(y, tur):
    e.sahne3b.yenile()
    e.hud.guncelle()
    e._pazar_ac())
