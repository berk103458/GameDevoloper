## Gece sonu ekonomisi: ambar takası, seyyar satış, ambardan maaş (design/gdd/koy-gelisimi.md F3–F5). Düz betik:
##   godot --headless --path . -s tests/unit/ekonomi/ekonomi_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0


func _init() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	var a := k.ayarlar
	var o := Oturum.new(k, 5)
	# F3: QA'daki şişmiş ambar (19 kişi, 190 ürün) akçeye döner; pazar satış sınırını büyütür.
	var t := o.ambar_takasi(190, 19, 0)
	_esit("takas: pazarsız akçe", t.y, a.takas_taban)
	_esit("takas: satılan ürün", t.x, a.takas_taban * a.ambar_akce_orani)
	_esit("takas: pazar sınırı büyütür", o.ambar_takasi(190, 19, 2).y, a.takas_taban + 2 * a.takas_pazar_artis)
	# Yedeğe dokunulmaz: fazla bir akçelik değilse satış yok.
	var yedek := 19 * a.ambar_yedek_gece
	_esit("takas: yedek korunur", o.ambar_takasi(yedek + a.ambar_akce_orani - 1, 19, 0), Vector2i.ZERO)
	_esit("takas: az fazlada az satış", o.ambar_takasi(yedek + a.ambar_akce_orani, 19, 3).y, 1)
	# F4: tezgâh bulamayan esnaf seyyar satar (pazarsız 2 tezgâh; 6 esnaf → 2 + ⌊4/2⌋ = 4 akçe).
	o = _koy(k, 0, 6, 0, 0, 0)
	o.gece_sonu()
	_esit("seyyar: gelir", o.akce, a.pazar_tezgah_taban * a.esnaf_gelir + (6 - a.pazar_tezgah_taban) / a.seyyar_bolen)
	# F5: akçe yetmeyen maaş ambardan ödenir, Ordu düşmez. 12 asker: maaş 6; ambar 100 − tüketim 12 = 88;
	# takas 2 akçe (−8 ürün) → 80; eksik 4 akçe ambardan −16 ürün → 64.
	o = _koy(k, 0, 0, 12, 0, 100)
	var ordu := o.barlar.degerler[3]
	o.gece_sonu()
	_esit("maaş: Ordu düşmedi", o.barlar.degerler[3], ordu)
	_esit("maaş: akçe sıfır", o.akce, 0)
	var tuketim := ceili(12 / float(a.tuketim_bolen))
	var takas := o.ambar_takasi(100 - tuketim, tuketim, 0)
	_esit("maaş: ambardan ödendi", o.ambar, 100 - tuketim - takas.x - (12 / 2 - takas.y) * a.ambar_akce_orani)
	# Ne akçe ne ambar varsa Ordu düşer.
	o = _koy(k, 0, 0, 4, 0, 0)
	ordu = o.barlar.degerler[3]
	o.gece_sonu()
	_esit("maaş yok: Ordu −1", o.barlar.degerler[3] < ordu, true)
	print("EKONOMI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _koy(k: Katalog, ciftci: int, esnaf: int, asker: int, akce: int, ambar: int) -> Oturum:
	var o := Oturum.new(k, 5)
	o.akce = akce
	o.ambar = ambar
	for s in [[&"ciftci", ciftci], [&"esnaf", esnaf], [&"asker", asker]]:
		for i in s[1]:
			o.koy.ekle(s[0])
	return o


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
