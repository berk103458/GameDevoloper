# Claude günlüğü

Claude: yönetici ajan. testx (EVREN/DeepSeek) ve Codex'in teslimlerini inceler, sanity'den geçirir, yayınlar; kendi maddelerini de uygular. Commit ve kota disiplini: `AGENTS.md` "Commit ve kota disiplini".

## 12 Ekim 2026

- **Gece (ROADMAP 2):** 22 → 123+ madde [x]. Kendi maddelerim: DIY-01 (`docs/SOZ_TASARIMI.md`, Ahmet onayı bekliyor), OMR-01, YER-02, KLT-10/11/43/44/45, SRM-01 (pencere adı 'Uçta bir kapı.'), KLT-23, KAY-40, SRM-17, ARY-05, SRM-18, AYR-51, TEK-17/21, SRM-13/14, OZL/HFZ/HAN/SOY/GRV/GIR/YER sınır maddeleri (`tools/kapsam_bekcisi.py`), API sözleşmesi 11 → 88 imza (OMR-52, HAN-51, SOY-47, OZL-30, HFZ-31). Taslak, insan kararı bekliyor: YAZ-01 (dünya kitabı, 14 dosya), ARY-01 (üç arayüz şablonu, seçim bekliyor).
- **testx/Codex teslimleri onaylandı ve yayınlandı:** BUG-0020 + TEK-10 (tam sanity 0 failed, 358 PASS), TEK-06/12/22–26, BUG-22, DEN-01, DIY-08, TEK-27/28, KAY-01/44/56, DEN-50/51/52/55/56, NBT-01, MCL-01, TEZ-01, YSM-01.
- **Sabah (oyunda doğrulama):** Oyunu pencereli açıp köylü kartı, gece raporu ve çınar meclisini görüntüyle kontrol ettim; iki hata buldum ve düzelttim: YSM-01 muhafız (oyuncu) kartında açlık alanı vardı (81c1216); MCL-01 konuşanlar arasında kurucu hane (Muhafız, Eş) çıkıyordu (2fad63d).
- AGENTS.md: "Commit ve kota disiplini" bölümü (Muharrir talimatı); ROADMAP 2 bölümündeki bozuk Türkçe karakterler onarıldı.
- kota: kota görünmüyor
- ACL-05 yayında (testx + Claude tamamladı). kota: kota görünmüyor
- BUG-0021 (temiz klon import 16→0) ve AYR-06 düğme taşması düzeltildi, oyunda doğrulandı. kota: kota görünmüyor

## 15 Kasım 2026 (Claude_gorev.md)

- **GRV-65…100 (33 madde) [x]:** `Kabuk.yer_tutucu` eklendi (renk veriden, bozuk renk nötr yedeğe düşer); haberci ve tekfur panellerindeki yerel ColorRect'ler buna, sürükleme kulpunun sabit 22 puntosu `ayarlar.boyut(Kabuk.KUCUK)`'a bağlandı. Diğer 30 dosyada ihlal yoktu, düğmeler genel temanın dört durumunu okuyor. Test `tests/oto/grv_tema_baglari_kontrol.tscn`: GEÇTİ (33 dosya, her biri oyunda çağrılıyor); eski kodla KALDI (3 hata) — bozulunca düşüyor. `haberci_agi_kontrol`, `tekfur_heyeti_kontrol` GEÇTİ. Not: `gecici_isler_kart_kontrol` bu değişiklikten bağımsız olarak KALDI (kulube kurulamıyor; eski kodla da aynı), kulp sürükleme denetimi geçiyor. kota: kota görünmüyor
- **SAH-47 [x]:** `KameraSurukleme.koyde_sarsinti_suresi` sabit 0 yerine kare örneklerinden ölçüyor (`sarsinti_suresi`). Test `tests/unit/dunya/sah47_sarsinti_test.tscn`: gerçek `KapiEkrani._karar_ver("ret")` → CAT-02 kavga sarsıntısı > 0, sonra `Ana._koye_git()` → köy kamerası (konum + h/v kayma) 0 sn; köy `_process`'ine sarsıntı eklenince KALDI. `sahne_yol_kamera_test` GEÇTİ. kota: kota görünmüyor
- **SAH-55 [x]:** Kod değişikliği gerekmedi; eksik olan ölçümdü. Test `tests/oto/sah55_kacis_kadraj_kontrol.tscn`: gerçek kapı sahnesinde gelen yaklaşır, `TansiyonKacisAkisi.ekranda` (CHR panelinin `kacis_istendi` yolu) çağrılır; kaçan kişi 3 sn kadrajda yürüyerek uzaklaşır, kamera 0.05 sn'de 0 m oynar. Mutasyon: kişi yürümeden silinince ve kamera 3 m sıçrayınca KALDI. kota: kota görünmüyor
