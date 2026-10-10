# 1→2. perde geçişi — SYS-19

## Overview
Gece sonunda nüfus `agalik_nufus` (18) olunca mevcut `_asamalar` "Köy oturdu" (Ağalık) açar ve oyuncuya mevcut "Ağa olarak devam et" kartı gösterilir. Gün/gece sayacı sıfırlanmaz; 2. perde kendi sayacını tutar ve `OyunAyarlari.perde2_hedef_gece` (12) gece dayanılınca biter.

## Detailed Rules
- Geçiş gecesinde `perde2_baslangic = gün + 1` işaretlenir; rapora "2. perde başladı: 12 gece dayan" satırı.
- `perde2_gece = gün − perde2_baslangic`; her gece `Oturum.gece_sonu` denetler; hedefe ulaşıldığında mevcut `zafer` sonu ("Uç tutundu" rapor satırı). Tekfur baskını/isyan/halk kırılması önce gelirse o son geçerlidir. SYS-20 hangi nihai sonun gösterileceğini seçer.
- Kayıt: `koy_yonetimi.perde2_baslangic`. Legacy (agalik açık, alan yok) veya ileri tarihli değer yükleme günüyle başlar; anında son üretmez.
- Ayar daha önce tanımlıydı ama hiçbir sistem okumuyordu; bu madde onu bağlar.

## Acceptance Criteria
`tests/unit/kvr/perde_gecisi_test.gd`: 17 nüfusta geçiş yok, 18'de geçiş, gün sıfırlanmaz, kayıt, tam 12 gece sonra son, legacy/ileri tarih.
