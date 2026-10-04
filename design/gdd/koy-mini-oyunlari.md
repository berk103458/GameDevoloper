# Köy içi olaylar ve mini oyunlar

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). Olaylar `tools/icerik/icerik_uret.py` → `OLAYLAR` (köy içi bölümü); ayarlar `data/ayarlar/oyun.tres` → "Mini oyunlar".*

## Overview
Köy gecesine altı yeni olay eklendi: **Okçuluk yarışı**, **Harman**, **Ağıldaki kurt**, **Samanlıkta yangın**,
**Yeni doğan**, **Pazar günü**. İkisi bir mini oyun açar: okçulukta salınan nişangâhla hedefe üç ok, harmanda
davulun ritmine uyup düveni sürmek. Puan ödülü büyütür; eşiği geçen ek bir kazanç alır.

## Player Fantasy
Bekçi yalnız kapıda değil, köyün içinde de var: gençlerle yay çeker, harmanda öküzleri sürer.

## Detailed Rules
1. Seçenek etkisinde `oyun` varsa (okculuk | harman) kart gizlenir, mini oyun panosu açılır; köyün 3D çizimi oyun boyunca durur.
2. Tek eylem: Boşluk/Enter ya da sol tık. Girdi panoda yakalanır, arkadaki düğmeleri tetiklemez.
3. **Okçuluk:** `okculuk_ok` ok. Nişangâh `Zamanlama.nisangah` ile salınır; her okta hız `okculuk_hiz_artis` artar. Basışta merkezden uzaklık ≤ `okculuk_merkez` → 2, ≤ `okculuk_halka` → 1, yoksa 0.
4. **Harman:** `harman_vurus` vuruş, `harman_aralik` arayla; daralan halka vuruş anında düven çemberine oturur, davul vuruşu duyulur. Vuruşa `harman_tolerans` içinde basmak 1 puan. Boşa basış en yakın (yarım aralık içindeki) vuruşu yakar — rastgele basarak puan toplanmaz. Kaçan vuruş ıska sayılır.
5. Bitince puan kartta yazar; sonuç metni puan eşiğin altındaysa `sonucN_az`, değilse `sonucN`.
6. Diğer dört olay mini oyunsuzdur; kurt seçeneklerinden biri köyde asker ister (`gerekli.sinif`).

## Formulas
- **F1 Ödül:** `akçe += oyun_odul.akce × puan`, `ambar += oyun_odul.ambar × puan`.
- **F2 Başarı:** `puan ≥ oyun_esik` ⇒ `oyun_basari.bar` uygulanır.
- **Örnek:** Harman, 6/8 isabet ⇒ ambar +6, Halk +1 (eşik 6). Okçuluk 3/6 ⇒ +3 akçe, başarı yok (eşik 4).

## Edge Cases
- Bilinmeyen `oyun` türü: mini oyun açılmaz, seçenek düz uygulanır (puan −1, ödül yok).
- Aynı vuruş iki kez sayılmaz; vurulmuş/yanmış vuruş yeniden seçilmez.
- Okçulukta ok saplanırken (duraklama) basış yok sayılır.

## Dependencies
Gece olayları (16), Barlar (8), Ekonomi (12), Ses (22: sfx_ok, sfx_hasat, sfx_kurt), Köy görünümü (20).

## Tuning Knobs
`okculuk_ok` 3, `okculuk_hiz` 0.45, `okculuk_hiz_artis` 0.12, `okculuk_merkez` 0.15, `okculuk_halka` 0.42,
`harman_vurus` 8, `harman_aralik` 0.8 s, `harman_tolerans` 0.17 s; olay başına `oyun_odul`, `oyun_esik`, `oyun_basari`.

## Acceptance Criteria
- Okçuluk puanı merkez/halka/dış sınırlarında doğru; harman isabeti en yakın vurulmamış vuruşu seçer, toleransı ve tekrarı doğru işler. — `tests/unit/mini_oyun/mini_oyun_test.gd`
- Ödül puanla ölçeklenir; eşikte başarı ve doğru sonuç metni. — aynı test.
- Katalogdaki mini oyunlu olaylar yalnız bilinen türleri anar. — aynı test.
- Pano, nişangâh, düven ve sonuç kartı görünür. — `production/qa/evidence/mini-oyun-1/`
