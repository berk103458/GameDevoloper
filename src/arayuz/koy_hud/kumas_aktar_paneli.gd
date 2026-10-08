## TUC-04: mevcut pazarda ortak ambardan oyuncu kontrollü lüks dağıtımı.
class_name KumasAktarPaneli
extends RefCounted
## Yalnız dağıtılabilir stok varsa aynı pazar kartında bir eylem satırı açar.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e._y
 if KumasAktarDestegi.kisi(y, "kece") + KumasAktarDestegi.kisi(y, "kumas") <= 0: return
 var h := HBoxContainer.new()
 ust.add_child(h)
 for tur in KumasAktarDestegi.AYAR.luks:
  var t: String = tur
  var d := e._dugme("%s dağıt · %d kişi Refah +%d" % [GezginTuccarStogu.ad("koy.kaynak." + t), KumasAktarDestegi.kisi(y, t), KumasAktarDestegi.AYAR.luks[t].refah], h)
  d.name = "luks_dagit_" + t
  d.disabled = KumasAktarDestegi.kisi(y, t) == 0
  d.tooltip_text = "Kişi başına bir stok kullanılır; düşük Refah önce. Kamu kasası ve RNG değişmez."
  d.pressed.connect(func() -> void:
   if KumasAktarDestegi.dagit(y, t) > 0:
    e._kart_kapat()
    e._pazar_ac()
    e.hud.guncelle())
