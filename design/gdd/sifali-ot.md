# Salgında şifalı ot toplama — KRI-15

## Overview
Belirtisi açık bir salgın sürerken boştaki vasıfsız köylüler kırdan şifalı ot toplar. Ot = mevcut `afyon` stoğu, yani KRI-03 ilaç reçetesinin (1 afyon + 1 su) girdisi; ikinci kaynak veya üretim yolu yoktur. İlaç üretiminin darboğazı (afyon) açılır, üretim hızı artar.

## Player Fantasy
Salgın köyü sararken işsiz eller de boş durmaz; otacının ihtiyaç duyduğu şifalı otu kırdan taşırlar.

## Detailed Rules
- Koşul: köyde belirtisi açık (`hasta` bayrağı görünen), temas edebilen bir hasta var; isyan yok; oturum sürüyor. Gizli kuluçka toplamayı başlatmaz (ifşa yok).
- Toplayıcı: işi olmayan (`BOSTA`), usta olmayan (vasıfsız), sağlam yetişkin; hasta, karantina, zindan, dış görev hariç. Gece en çok 3 toplayıcı, kişi başı 1 afyon (ambar kapasitesi sınırında).
- Üretimden önce eklenir: Şifahane ilaç reçetesi aynı gece kullanabilir. Şifahane bilgi metni yeni kaynağı söyler. RNG yok; yeni kayıt alanı yok.

## Formulas
`ot = min(3, |toplayıcı|) × 1` (ambar boş yeri ile sınırlı).

## Dependencies
`KoyYonetimi.gece` (tek satır, üretimden önce), `IflasYoneticisi.olay_metin`, `HekimIlac.metin` (bilgi satırı). Ayar: `data/koy/sifali_ot.json`.

## Acceptance Criteria
Birim: `tests/unit/kvr/sifali_ot_test.gd`; akış: `tests/oto/sifali_ot_kontrol.gd`.
