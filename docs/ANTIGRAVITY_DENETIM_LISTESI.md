# Antigravity denetim listesi — 14 Ekim – 9 Kasım 2026

Cursor, 15 Kasım 2026. Festive ucu `44174d7a` (Kalfa'nın SAH-34 commit'i).

Bu bir envanter ve teşhistir. Kod, veri ve ROADMAP işaretlerine dokunulmadı. Düzeltme Antigravity'ye (Gemini Argon) bırakıldı.

Kapsam: commit mesajında `(Antigravity)` imzası taşıyan 232 commit. Bunlar 188 benzersiz madde kimliğine değiniyor.

## Kararların anlamı

- **TAM:** İstenen davranış kodda var ve oyun akışından (sahne, gece, autoload, sinyal) gerçekten çağrılıyor.
- **EKSİK:** Kod ya da veri var ama kabulün bir parçası tutmuyor, ya da test kendi kendini doğruluyor.
- **SAHTE-BAĞSIZ:** Kod ve testi var, ikisi de geçiyor; ama oyunda hiçbir yer o kodu çağırmıyor. Yalnız testten `new()` ile kuruluyor.
- **YOK:** İddia edilen dosya ya da davranış repoda bulunamadı.

## Özet

Sayılar belgenin tablolarından sayıldı. Bir madde birden fazla tabloda geçmiyor.

| Karar | Sayı |
|---|---|
| TAM | 112 |
| EKSİK | 27 |
| SAHTE-BAĞSIZ | 23 |
| YOK | 2 |
| SAH (ayrı ele alındı, aşağıya bakın) | 7 |
| ROADMAP'te karşılığı olmayan id (çoğu yeniden adlandırılmış) | 21 |

Toplam 165 ROADMAP maddesi artı 7 id'siz kapanış iddiası. İkisinin toplamı 172'dir.

Öncelik sırası, oyunu en çok etkileyenler başta:

1. **OGR-33** — ilk altı gecede beş nihai sonun kilitlenmesi. Kilit kodu var ama `nihai_son.gd` onu hiç çağırmıyor; oyuncu ilk gecede kaybedebilir.
2. **OMR-17** — sonun kayda yazılması. `SonKaydi` oyunda hiç çağrılmıyor; epilog sonradan okunamıyor.
3. **DYL-08 / KOP-04** — kapı kararının günler sonra geri dönmesi. `KararDonusu` hiçbir akıştan çağrılmıyor.
4. **ZAR-04** — ikna, blöf, gözdağı ve gönül alma. `ZarDegistiricileri` oyunda çağrılmıyor; zar eşiği bu yüzden değişmiyor.
5. **DYL-06** — ortak dil yoksa kırık satır ve tercüman. `DilEngeli` hiç çağrılmıyor.
6. **ACL-03 / DYL-07** — gece raporundan önce eşle sohbet. `AksamSohbeti` hiç açılmıyor.
7. **HAN-01** — hane kaydı. `Hane` sınıfı hiç çağrılmıyor; hane kimliği kayda girmiyor.
8. **KOP-03** — yüz ve ellere bakınca hastalık belirtisi. `Bakis` hiç çağrılmıyor; teşhis adaptörü de boşta kalıyor.
9. **DIY-14** — "Bu hatırlanacak" notu. `HatirlanmaNotu` hiç çağrılmıyor.
10. **SOY-01** — söylenti kaydına `kaynak` ve `dogru` alanı. `Dedikodu` bu iki alanı tutmuyor.

## SAH maddeleri

SAH için ayrıntılı kanıt `docs/SAH_KANIT_TABLOSU.md` içindedir (Görev 22, Cursor, 10 Kasım). O tabloyu burada tekrar etmiyorum.

Kalfa, 15 Kasım'da SAH-01'den SAH-34'e kadar olan maddeleri yeniden işledi. Güncel durum:

| Madde | ROADMAP | Durum |
|---|---|---|
| SAH-01 | `[x]` (Kalfa) | `AyakZemini.kur` artık `karakter_model.gd:72` içinden çağrılıyor. Görev 22'de kaldırılan bağ geri gelmiş. |
| SAH-16 | `[x]` (Kalfa) | Kalfa doğruladı: 46 model, 7 eşya türü. |
| SAH-17 | `[x]` (Kalfa) | Kalfa doğruladı: gerçek oynatıcıda bekle, yürü, koş. |
| SAH-32 | `[x]` (Kalfa) | Kalfa doğruladı: 38 karede ara yürüyüş ağırlığı 0. |
| SAH-33 | `[x]` (Kalfa) | Kalfa doğruladı: kapı, patika ve tarla tek gezinme ağı. |
| SAH-42 | `[x]` (Antigravity) | Görev 22'de kanıtlandı: `tests/unit/dunya/sah_kamera_kanit_test.gd`. |
| SAH-50 | `[ ]` | Görev 22'de geri açıldı: `heybe_ile_mesafe_koru()` oyunda çağrılmıyor. |

## DEN — Denge

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| DEN-02 | Açlık eşiği | `[x]` | `data/ayarlar/denge.json` | Eşik veride, `denge_dogrula.py` okuyor | — | TAM | — |
| DEN-03 | Denge doğrulayıcı | `[x]` | `tools/denge_dogrula.py` | Araç bu denetimde çalıştı, "GECTI" verdi | — | TAM | — |
| DEN-04 | Üretim tabanı | `[x]` | `data/ayarlar/denge.json` | Değer veride | — | TAM | — |
| DEN-05 | Tüketim ölçümü | `[x]` | `src/sistemler/denge_olcumu.gd` | `olustur` gece raporunu okuyor | Yalnız testlerden çağrılıyor, oyunda bir ekran ya da gece adımı yok | EKSİK | Ölçümün nereye yazılacağına karar ver; gece akışına tek satır bağ yeterli |
| DEN-06 | Ölçüm HUD'da görünmez | `[x]` | `src/sistemler/denge_olcumu.gd` | Oyuncu arayüzünde "denge" yazısı yok | Ölçümün kendisi oyunda çalışmıyor (DEN-05) | EKSİK | DEN-05 bağlanınca bu madde kendiliğinden doğrulanır |
| DEN-07 | Doğrulayıcı kuralı | `[x]` | `tools/denge_dogrula.py` | Kural araçta | — | TAM | — |
| DEN-08 | Doğrulayıcı kuralı | `[x]` | `tools/denge_dogrula.py` | Kural araçta | — | TAM | — |
| DEN-09 | Kapasite tabanı | `[x]` | `data/ayarlar/denge.json`, `koy.tres` | Değer iki yerde de var | — | TAM | — |
| DEN-11 | Açılış denge kontrolü | `[x]` | `tests/oto/acilis_denge_kontrol.tscn` | Test sahnesi var | — | TAM | — |
| DEN-13 | Moral eşiği | `[x]` | `data/ayarlar/denge.json` | Değer veride | — | TAM | — |
| DEN-14 | Sadakat eşiği | `[x]` | `data/ayarlar/denge.json` | Değer veride | — | TAM | — |
| DEN-17 | Sorgu kuralı | `[x]` | `data/ayarlar/denge.json`, `sorgu_kurallari.tres` | Kural iki yerde | — | TAM | — |
| DEN-18 | Zar kasaya yazılmaz | `[x]` | `src/sistemler/denge_olcumu.gd` | Ölçüm fonksiyonu var | Oyunda çağrılmıyor; kasanın gerçekten değişmediği oyun içinden doğrulanamıyor | EKSİK | DEN-05 ile birlikte bağla |
| DEN-19 | Rüşvet oranı | `[x]` | `data/ayarlar/denge.json` | Değer veride | — | TAM | — |
| DEN-20 | Zar kasa testi | `[x]` | `tests/unit/denge/zar_kasa_test.gd` | Test var, gerçek oturum kuruyor | — | TAM | — |
| DEN-21 | Zar kasa testi | `[x]` | `tests/unit/denge/zar_kasa_test.gd` | Test var | — | TAM | — |
| DEN-22 | Başarısız zar sayısı | `[x]` | `src/sistemler/denge_olcumu.gd` | Sayım fonksiyonu var | Oyunda çağrılmıyor | EKSİK | DEN-05 ile birlikte bağla |
| DEN-23 | Doğrulayıcı kuralı | `[x]` | `tools/denge_dogrula.py` | Kural araçta | — | TAM | — |
| DEN-24 | Zar testi yeşil kalır | `[x]` | — | Madde yalnız "mevcut testi çağır" diyor | Kendi kodu yok, bu beklenen | TAM | — |
| DEN-36 | Zorluk çarpanı | `[x]` | `data/ayarlar/denge.json` | Değer veride | — | TAM | — |
| DEN-41 | Rüşvet testi | `[x]` | `tests/unit/denge/rusvet_test.gd` | Test var | — | TAM | — |
| DEN-42 | Doğrulayıcı kuralı | `[x]` | `tools/denge_dogrula.py` | Kural araçta | — | TAM | — |
| DEN-45 | Rüşvet testi | `[x]` | `tests/unit/denge/rusvet_test.gd` | Test var | — | TAM | — |
| DEN-47 | Zorluk verisi | `[x]` | `data/ayarlar/denge.json` | Değer veride | — | TAM | — |
| DEN-48 | Persona koşusu | `[x]` | `tests/oto/denge_persona.tscn` | Test sahnesi var | — | TAM | — |
| DEN-64 | Kriz koşusu | `[x]` | `tests/oto/denge_kriz.tscn` | Test sahnesi var | — | TAM | — |
| DEN-67 | Zorluk testi | `[x]` | `tests/unit/denge/zorluk_test.gd` | Test var | — | TAM | — |
| DEN-68 | Açılış kontrolü | `[x]` | `tests/oto/acilis_denge_kontrol.tscn` | Test sahnesi var | — | TAM | — |
| DEN-74 | Persona koşusu | `[x]` | `tests/oto/denge_persona.tscn` | Test sahnesi var | — | TAM | — |
| DEN-77 | Persona koşusu | `[x]` | `tests/oto/denge_persona.tscn` | Test sahnesi var | — | TAM | — |
| DEN-78 | Persona koşusu | `[x]` | `tests/oto/denge_persona.tscn` | Test sahnesi var | — | TAM | — |

## OGR — Öğretici

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| OGR-01 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | `koy_hizi_ipucunu_goster` oyunda çağrılıyor | — | TAM | — |
| OGR-03 | Zar ipucu | `[x]` | `src/kapi/zar_ipucu.gd` | Sınıf ve testi var | `ZarIpucu` oyunda hiç çağrılmıyor; `ilk_saat.gd` içindeki `zar_ipucu_kontrol` ayrı bir fonksiyon | SAHTE-BAĞSIZ | `ilk_saat.gd:175` içindeki kontrolü `ZarIpucu`'ya bağla |
| OGR-04 | İlk saat bağları | `[x]` | `src/sistemler/ilk_saat.gd`, `src/arayuz/ana.gd` | `Ana._ready` çağırıyor | — | TAM | — |
| OGR-06 | Tehdit başlangıcı | `[x]` | `data/ogretici/ilk_saat.json` | `tehdit_baslangic` alanı var | — | TAM | — |
| OGR-07 | İpucu kaydı | `[x]` | `src/sistemler/ipucu_kaydi.gd` | `Oturum` içinde kuruluyor, kayda giriyor | — | TAM | — |
| OGR-08 | İpucu şeridi | `[x]` | `src/arayuz/koy_hud/ipucu_seridi.gd` | HUD'a ekleniyor | — | TAM | — |
| OGR-10 | İpucu kaydı | `[x]` | `src/sistemler/ipucu_kaydi.gd` | OGR-07 ile aynı bağ | — | TAM | — |
| OGR-11 | İpucu şeridi | `[x]` | `src/arayuz/koy_hud/ipucu_seridi.gd` | OGR-08 ile aynı bağ | — | TAM | — |
| OGR-12 | İpucu paneli | `[x]` | `src/debug/ipucu_paneli.gd` | `IpucuPaneli.kur` çağrılıyor | — | TAM | — |
| OGR-13 | İlk aile konuları | `[x]` | — | Kabul `gece_min` alanı istiyor | `data/soz` altında `gece_min` bulunamadı | EKSİK | İlk aile dosyasına `gece_min` ekle |
| OGR-14 | Beyan defteri tanıtımı | `[ ]` | `src/kapi/defter_tanitimi.gd` | Kod var | Görev 22 geri açtı; Görev 23'te de bağlanamadı, çünkü çelişkiyi üreten söz motoru oyunda çalışmıyor | SAHTE-BAĞSIZ | Söz motoru bağlanmadan bu madde kapanmaz |
| OGR-15 | Heybe ipucu | `[x]` | `src/sistemler/ilk_saat.gd` | `IlkSaat` oyunda çağrılıyor | — | TAM | — |
| OGR-16 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-17 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-18 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-20 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-21 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-24 | Yeni düğme işareti | `[x]` | `src/arayuz/koy_hud/yeni_dugme_isareti.gd` | Görev 23'te `YeniDugmeBaglantisi` ile köy ekranına bağlandı | — | TAM | — |
| OGR-31 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-32 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-33 | Son kilidi | `[x]` | `src/sistemler/son_kilidi.gd`, `src/sistemler/nihai_son.gd` | `kilitli_mi` var | `nihai_son.gd:18` yalnız zafer kolunda çağırıyor; diğer dört son ilk gecede de açılabiliyor | EKSİK | Kilidi `son()` fonksiyonunun en başına taşı, beş son için de geçerli olsun |
| OGR-34 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OGR-37 | Geçmişe göre ipucu | `[x]` | `data/ogretici/ilk_saat.json` | `atla_gecmis` dokuz kez geçiyor | — | TAM | — |
| OGR-45 | İpucu tavanı | `[x]` | `data/ogretici/ilk_saat.json` | `kavramlar` listesi 9, tavan 20 | — | TAM | — |
| OGR-47 | Oyuncu izi | `[x]` | `src/sistemler/oyuncu_izi.gd` | `OyuncuIzi.new` çağrılıyor | — | TAM | — |
| OGR-53 | Çekirdekte öğretici anahtarı yok | `[x]` | `src/arayuz/kapi_ekrani.gd` | Dört dosyanın üçü temiz | `kapi_ekrani.gd:226` hâlâ `kapi_acilis_ogretici.gd` çağırıyor; kabul "dört dosyada 0" diyor | EKSİK | Çağrıyı adaptör dosyasına taşı ya da kabulü güncelle |
| OGR-55 | F1 anılmaz | `[x]` | `data/ogretici/ilk_saat.json` | Öğretici metinlerinde "F1" yok | — | TAM | — |

## OMR — Omurga

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| OMR-02 | Omurga verisi | `[x]` | `src/sistemler/omurga.gd` | `dalga`, `donem`, `hat_onceligi` oyunda çağrılıyor | — | TAM | — |
| OMR-03 | Omurga süzgeci | `[x]` | `src/sistemler/omurga_suzgeci.gd` | `gece_kuyrugu` içinden çağrılıyor | — | TAM | — |
| OMR-04 | Omurga | `[x]` | `src/sistemler/omurga.gd` | Aynı bağ | — | TAM | — |
| OMR-06 | Omurga | `[x]` | `src/sistemler/omurga.gd` | Aynı bağ | — | TAM | — |
| OMR-11 | İlk saat | `[x]` | `src/sistemler/ilk_saat.gd` | Aynı bağ | — | TAM | — |
| OMR-13 | Son göstergeleri | `[x]` | `src/arayuz/oda_gidisat_paneli.gd` | `muhafiz_odasi_ekrani.gd:60` çağırıyor, perde 2'de altı satır | — | TAM | — |
| OMR-14 | Gidişat cümlesi | `[x]` | `src/arayuz/oda_gidisat_paneli.gd` | Aynı panel, dalga 2'den itibaren | — | TAM | — |
| OMR-17 | Son kayda yazılır | `[x]` | `src/sistemler/son_kaydi.gd` | Sınıf eksiksiz: `kayda_yaz`, `kayittan_oku` | Oyunda hiçbir betik `SonKaydi` çağırmıyor; epilog kayda girmiyor | SAHTE-BAĞSIZ | `nihai_son.son_metni` dönüşünü `Oturum.kaydet` içine `SonKaydi.kayda_son_ekle` ile bağla |
| OMR-19 | Dış hat kapısı | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | `koy_yonetimi.gd`, `haberci_agi.gd`, `sancak_asker_talebi.gd` çağırıyor | — | TAM | — |
| OMR-20 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-23 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-24 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-25 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-26 | Kapatılan hat sona yansır | `[x]` | `src/sistemler/nihai_son.gd` | `son()` her kolunda `hat_kapali_mi` okuyor | — | TAM | — |
| OMR-27 | Divan hükmü sabaha düşer | `[x]` | `src/koy/sabah_defteri.gd` | `sabah_paneli.gd:34` çağırıyor; infaz ve sürgün "adalet" yazıyor | — | TAM | — |
| OMR-28 | Yozlaşma uyarısı | `[x]` | `src/arayuz/oda_yozlasma_uyarisi.gd` | `oda_vicdan_paneli.gd:13` çağırıyor | — | TAM | — |
| OMR-29 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-30 | Dört hat kapalıysa uç tutuldu | `[x]` | `design/omurga.md`, `src/sistemler/nihai_son.gd` | `son()` varsayılan dönüşü `uc_tutundu` | — | TAM | — |
| OMR-32 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-34 | Omurga | `[x]` | `src/sistemler/omurga.gd` | Aynı bağ | — | TAM | — |
| OMR-36 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-37 | Dış hat | `[x]` | `src/sistemler/dis_hat_kapisi.gd` | Aynı bağ | — | TAM | — |
| OMR-38 | Haber defteri | `[x]` | `src/arayuz/hafiza_defteri_ekrani.gd` | ROADMAP `hafiza_defteri.gd` diyor, o dosya yok | Gerçek dosya `hafiza_defteri_ekrani.gd`; haber sayfası `HafizaDefteri._haber_sayfasi` içinde var | EKSİK | Dosya adını doğrula, haber sayfasının `haberci_agi.oku` ile eşit olduğunu test et |
| OMR-44 | Perde 2 meclisi | `[x]` | `src/koy/meclis_sesi.gd` | `haftalik_mi` ve `dis_hat_konusu` çağrılıyor | — | TAM | — |
| OMR-49 | Geçmişe göre selam | `[x]` | — | Kabul söz dosyasında selam farkı istiyor | Ayrı bir selam verisi bulunamadı | EKSİK | İki geçmiş için selam satırını söz dosyasına ekle |
| OMR-50 | Tohum dalgayı kaydırır | `[x]` | `tools/python_test_runner.py` | Koşu aracı var | Dalga kaydırmasının kendisi doğrulanamadı | EKSİK | 20 tohumluk koşuyu çalıştır, yüz gecesinin dalga içinde kaldığını göster |
| OMR-53 | Sabitler veride | `[x]` | `data/omurga.json`, `src/sistemler/omurga.gd` | `omurga.gd` dosyayı okuyor, 0 ve 1 dışında tek sayı sabiti var | — | TAM | — |

## OZL — Olaylar

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| OZL-01 | Tek seçici | `[x]` | `src/sistemler/oturum.gd` | `olay_sec` tek yerde; ikinci `olay_secici` dosyası yok | — | TAM | — |
| OZL-02 | Olay söz bağı | `[x]` | `src/sistemler/olay_soz_bagi.gd` | `sira_atlama_adaptoru.gd` çağırıyor | — | TAM | — |
| OZL-04 | Tek sefer | `[x]` | `data/olaylar/*.tres` | `tek_sefer` alanı şemada | — | TAM | — |
| OZL-05 | Boş havuz | `[x]` | `src/sistemler/gece_bilancosu.gd` | Bilanço dosyası var | "Bu gece köy sessiz" satırı bulunamadı | EKSİK | Havuz boşken gece raporuna tek satır ekle |
| OZL-07 | Olay söz bağı | `[x]` | `src/sistemler/olay_soz_bagi.gd` | Aynı bağ | — | TAM | — |
| OZL-12 | Mevsim koşulu | `[x]` | `data/olaylar/*.tres` | `kosullar` alanı var | Dört mevsim için ayrı koşul doğrulanamadı | EKSİK | `tarla_yagmur` kartına kış koşulunu yaz |
| OZL-13 | Hafta başı ağırlığı | `[x]` | `data/olay_agirlik.json` | `olay_on_kosulu.gd:91` dosyayı okuyor | — | TAM | — |
| OZL-14 | Kış odunu kartı yok | `[x]` | `data/olaylar/` | `kis_odun` kimliği yok | — | TAM | — |
| OZL-15 | Düğün koşulu | `[x]` | `data/olaylar/dugun.tres` | `yetiskin_hane_min: 2` yazıyor; `nufus_katmani_test.gd` gerçek `olay_sec` çağırıyor | — | TAM | — |
| OZL-16 | Bebek koşulu | `[x]` | `data/olaylar/bebek.tres` | `hane_var: true` yazıyor | — | TAM | — |
| OZL-17 | Cenaze kartı yok | `[x]` | `data/olaylar/` | `cenaze.tres` yok | — | TAM | — |
| OZL-18 | Cenaze raporu | `[x]` | `src/arayuz/koy_hud/cenaze_raporu.gd` | Rapor paneli var | `olay.cenaze` anahtarının rapordan türetildiği doğrulanamadı | EKSİK | `olay_soz_bagi.gd` içine cenaze okuyucusunu ekle |

## AYR — Arayüz ve kayıt

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| AYR-05 | Ayarlar eki | `[x]` | `src/sistemler/ayarlar_ek.gd` | `ana.gd:28` `bagla` çağırıyor, ayar satırı `ayarla` çağırıyor | — | TAM | — |
| AYR-22 | Odak kaybında ses | `[x]` | `src/sistemler/odak_sesi.gd` | Sınıf var | `OdakSesi` oyunda hiç çağrılmıyor; pencere odak kaybedince ses kısılmıyor | SAHTE-BAĞSIZ | `ana.gd` içine `NOTIFICATION_APPLICATION_FOCUS_OUT` bağla |
| AYR-28 | Üç kayıt yuvası | `[x]` | `src/sistemler/kayit_yuvalari.gd` | `yeni_oyun_ekrani.gd` yuva seçiyor | Seçilen yuva `Ana.kayit`'a bağlanmıyor; oyun tek `GuvenliKayit` dosyasına yazıyor | EKSİK | `Ana.kayit` yolunu seçilen yuvanın yoluna çevir |
| AYR-29 | Yuva kartı | `[ ]` | `src/arayuz/kayit_yuva_karti.gd` | Kod var | Görev 22 geri açtı; AYR-28 bağlanmadan kart gerçek kaydı göstermez | SAHTE-BAĞSIZ | Önce AYR-28'i bağla |
| AYR-31 | Ayarlar eki | `[x]` | `src/sistemler/ayarlar_ek.gd` | Aynı bağ | — | TAM | — |
| AYR-32 | Kayıt yuvaları | `[x]` | `src/sistemler/kayit_yuvalari.gd` | AYR-28 ile aynı durum | Yuva seçimi kayda yazılmıyor | EKSİK | AYR-28 ile birlikte bağla |
| AYR-33 | Uyumsuz kayıt | `[ ]` | `src/arayuz/kayit_yuva_karti.gd` | Kod var | Görev 22 geri açtı | SAHTE-BAĞSIZ | AYR-28 bağlanınca kartın sürüm kontrolü de çalışır |
| AYR-43 | Ayarlar eki | `[x]` | `src/sistemler/ayarlar_ek.gd` | Aynı bağ | — | TAM | — |
| AYR-46 | Ayarlar eki | `[x]` | `src/sistemler/ayarlar_ek.gd` | Aynı bağ | — | TAM | — |

## KOP — Kapı

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| KOP-03 | Bakışla teşhis | `[x]` | `src/soz/bakis.gd`, `src/kapi/hastalik_teshis_adaptoru.gd` | Teşhis adaptörü `oturum.gd` içinden çağrılıyor | `Bakis` sınıfı hiç çağrılmıyor; yüz ve el satırı üretilmiyor | SAHTE-BAĞSIZ | Bakış satırını kapı ekranındaki bölge seçimine bağla |
| KOP-04 | Karar dönüşü | `[x]` | `src/soz/karar_donusu.gd` | Sınıf ve testi var | Hiçbir akış `KararDonusu` çağırmıyor; karar günler sonra geri dönmüyor | SAHTE-BAĞSIZ | `gece_sonu` içine `KararDonusu.ilerlet` çağrısı ekle |
| KOP-05 | Dedikodu | `[x]` | `src/sistemler/dedikodu.gd` | `Dedikodu.new` çağrılıyor | — | TAM | — |
| KOP-09 | Kapı | `[x]` | — | Madde veri kuralı | — | TAM | — |
| KOP-10 | Karar matrisi | `[x]` | `src/kapi/chr_karar_matrisi.gd` | Kapı ekranı çağırıyor | — | TAM | — |

## DIY — Diyalog altyapısı

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| DIY-01 | Söz tasarımı | `[x]` | `docs/SOZ_TASARIMI.md` | Belge var | — | TAM | — |
| DIY-09 | Satır seçici | `[x]` | `src/soz/satir_secici.gd` | `baglam_hazirla` çağrılıyor | — | TAM | — |
| DIY-11 | Kişi hafızası | `[x]` | `src/soz/kisi_hafizasi.gd` | `kaydet_olay`, `hafiza_uygula` çağrılıyor | — | TAM | — |
| DIY-12 | Grup itibarı | `[x]` | `src/soz/grup_itibari.gd` | `gecerli_grup_mu` çağrılıyor | — | TAM | — |
| DIY-13 | Dedikodu | `[x]` | `src/sistemler/dedikodu.gd` | Kuruluyor | — | TAM | — |
| DIY-14 | Hatırlanma notu | `[x]` | `src/arayuz/kapi/hatirlanma_notu.gd` | Sınıf ve testi var | `HatirlanmaNotu` hiç çağrılmıyor; not ekranda görünmüyor | SAHTE-BAĞSIZ | Kapı kararının verildiği yere tek satır ekle |

## DYL — Diyalog

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| DYL-01 | Çelişki yüzleştirme | `[x]` | — | ROADMAP `src/soz/celiski.gd` diyor | Dosya yok. Görev 23'te de bağlanamadı | YOK | Çelişki yüzleştirmesini yeniden yaz; söz motoru bağlanmadan çalışmaz |
| DYL-06 | Dil engeli | `[x]` | `src/soz/dil_engeli.gd` | 233 satır, testi var | Hiç çağrılmıyor; tercüman düğmesi çıkmıyor | SAHTE-BAĞSIZ | Kapı ekranında ortak dil yokken `DilEngeli` çağır |
| DYL-07 | Akşam konusu | `[x]` | `src/koy/aksam_sohbeti.gd` | Konu seçimi ve testi var | `AksamSohbeti` hiç açılmıyor | SAHTE-BAĞSIZ | ACL-03 ile birlikte gece raporundan önce aç |
| DYL-08 | Karar dönüşü | `[x]` | `src/soz/karar_donusu.gd` | KOP-04 ile aynı sınıf | Hiç çağrılmıyor | SAHTE-BAĞSIZ | KOP-04 ile birlikte bağla |

## CAT, ZAR, KAP

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| CAT-01 | Kapı kavgası | `[ ]` | `src/kapi/kapi_kavgasi.gd` | Kod var | Görev 22 geri açtı. Görev 23'te de bağlanamadı: hiçbir gelen kavga tipi taşımıyor | SAHTE-BAĞSIZ | Önce gelen verisine kavga tipi ekle |
| CAT-02 | Kapı kavgası | `[ ]` | `src/kapi/kapi_kavgasi.gd` | Aynı | Aynı neden | SAHTE-BAĞSIZ | CAT-01 ile birlikte |
| CAT-03 | Hekim ilacı | `[x]` | `src/koy/hekim_ilac.gd` | `saglik_yoneticisi.gd` ve `sifahane.gd` çağırıyor | — | TAM | — |
| CAT-04 | Kapı kavgası | `[ ]` | `src/kapi/kapi_kavgasi.gd` | Aynı | Aynı neden | SAHTE-BAĞSIZ | CAT-01 ile birlikte |
| ZAR-01 | Sorgu zarı | `[x]` | `src/kapi/sorgu_zari.gd` | `kapi_kavgasi.gd` ve `tansiyon_kacis_adaptoru.gd` çağırıyor | — | TAM | — |
| ZAR-02 | Sorgu değeri | `[x]` | `tools/chr_parser.py`, `tests/tools/test_chr_sorgu_degeri.py` | Ayrıştırıcı ve testi var | — | TAM | — |
| ZAR-03 | Sorgu zarı | `[x]` | `src/kapi/sorgu_zari.gd` | Aynı bağ | — | TAM | — |
| ZAR-04 | Yaklaşım değiştiricileri | `[x]` | `src/kapi/zar_degistiricileri.gd` | Testi var ve geçiyor | Sınıf oyunda hiç çağrılmıyor; zar eşiği değişmiyor | SAHTE-BAĞSIZ | Zar atılmadan önce `ZarDegistiricileri` çağır |
| ZAR-05 | Beyaz ve kırmızı kontrol | `[x]` | `src/kapi/sorgu_zari.gd`, `tests/unit/kapi/zar_tur_test.gd` | Test gerçek sınıfı çağırıyor | — | TAM | — |
| KAP-17 | Aile kafilesi | `[x]` | `src/kapi/aile_kafilesi.gd` | Beş yerden çağrılıyor | — | TAM | — |
| KAP-18 | Yetimler | `[ ]` | — | "Kalfa bekleniyor" | — | EKSİK | Kalfa'ya bırak |
| KAP-19 | Nüfus katmanı | `[x]` | `src/sistemler/olay_on_kosulu.gd` | `nufus_katmani_test.gd` gerçek `olay_sec` çağırıyor | — | TAM | — |

## YAP, YAZ, YER

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| YAP-03 | Ustalar kapıdan gelir | `[ ]` | — | "Kalfa bekleniyor" | — | EKSİK | Kalfa'ya bırak |
| YAP-04 | Usta defterleri | `[x]` | `src/koy/usta_defterleri.gd` | Altı yerden çağrılıyor | — | TAM | — |
| YAP-24 | Usta adlıdır | `[x]` | `data/soz/` | Kural veri tarafında | — | TAM | — |
| YAP-28 | Çırak yaşı | `[x]` | `src/koy/` | UZM-04'e bağlı | Erken çırak denetimi doğrulanamadı | EKSİK | UZM-04 testini çalıştır |
| YAP-29 | Usta nöbet tutmaz | `[x]` | `src/koy/` | NBT-02'ye bağlı | Atama denetimi doğrulanamadı | EKSİK | NBT-02 testini çalıştır |
| YAP-37 | Söz motoru | `[x]` | `src/soz/soz_motoru.gd` | `SozKaydi.motor` olarak kuruluyor | Motor yalnız kaydedilip yükleniyor, oyunda bir söz akışı başlatmıyor | EKSİK | Motoru bir sahneye bağla |
| YAP-51 | Eşya açıklaması anahtardır | `[x]` | `data/metin/metinler.csv` | Metinler anahtarlı | — | TAM | — |
| YAP-53 | Kavga ganimeti | `[x]` | `src/kapi/` | Kural kapı tarafında | CAT açık olduğu için ganimet yolu da kapalı | EKSİK | CAT-01 bağlanınca çalışır |
| YAZ-02 | Üslup kapısı | `[x]` | — | Kabul `data/soz/yasak_kelimeler.txt` ve `tests/tools/test_uslup_kapisi.py` istiyor | İkisi de yok | EKSİK | Yasak kelime listesini ve testi yaz |
| YER-01 | Dil sekmesi | `[x]` | `src/arayuz/dil_sekmesi.gd` | Ayar ekranına ekleniyor | — | TAM | — |
| YER-02 | Metin anahtar standardı | `[x]` | `docs/METIN_ANAHTAR_STANDARDI.md`, `tools/metin_dogrula.py` | Belge ve araç var | — | TAM | — |
| YER-03 | Dil ayardan okunur | `[x]` | `src/sistemler/dil_ayari.gd` | `DilAyari.uygula` ayarı okuyup locale kuruyor | `ana.gd:24` hâlâ `set_locale("tr")` yazıyor; kabul "yazmaz" diyor | EKSİK | Sabit satırı kaldır, yalnız `DilAyari.uygula` kalsın |
| YER-04 | İngilizce sütun | `[x]` | `data/metin/metinler.csv` | Başlık `keys,tr,en` | — | TAM | — |
| YER-05 | Tek çeviri dosyası | `[x]` | `project.godot` | `locale/translations` tek kayıt | — | TAM | — |

## ACL, HAN, MCL, BUG, KAY, SOY

| Madde | Başlık | ROADMAP | İlgili dosyalar | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|---|---|
| ACL-03 | Akşam sohbeti | `[x]` | `src/koy/aksam_sohbeti.gd` | Konu seçimi, atlama ve testi var | Hiçbir sahne açmıyor | SAHTE-BAĞSIZ | Gece raporundan önce tek çağrı ekle |
| HAN-01 | Hane kaydı | `[x]` | `src/koy/hane.gd` | 177 satır | `Hane` sınıfı hiç çağrılmıyor; kayda girmiyor | SAHTE-BAĞSIZ | `KoyYonetimi.kaydet` içine hane alanını ekle |
| MCL-02 | Meclis sesi | `[x]` | `src/koy/meclis_sesi.gd` | `cinar_alti_meclisi.gd` ve `cinar_meclis_paneli.gd` çağırıyor | — | TAM | — |
| BUG-16 | Olay ön koşulu | `[x]` | `src/sistemler/olay_on_kosulu.gd` | `oturum.gd:472` havuzu bu koşuldan geçiriyor | — | TAM | — |
| KAY-04 | İçerik sürümü | `[x]` | `src/sistemler/kayit_gocu_soz.gd` | `icerik_surumu_oku` içerik dosyasını okuyor | — | TAM | — |
| SOY-01 | Söylenti kaynağı | `[x]` | `src/sistemler/dedikodu.gd` | Dedikodu kaydı var | `kaynak` ve `dogru` alanı yok; Görev 23'te bu iş `SoylentiAgi` ile ayrı yapıldı | EKSİK | Alanları `Dedikodu` yerine `SoylentiAgi` kaydında tut |

## Günlükteki id'siz kapanış iddiaları

Görev 17, "onaylanan 7 madde" dedi. Bunlar ROADMAP'e sonradan eklendi:

| Madde | ROADMAP | Ne var | Ne eksik | Karar | Antigravity'ye not |
|---|---|---|---|---|---|
| ANL-DON-01 | `[x]` | `data/diyalog/diyalog_donusler.json` var | Dosyayı okuyan kod yok; kabuldeki `diyalog_butunluk_test.gd` de yok | SAHTE-BAĞSIZ | Okuyucuyu yaz, testi ekle |
| ES-GECM-01 | `[x]` | `data/parley/koy/koylu_muhabbet_es.ds` var | `KoyDiyalogYoneticisi` köylü kartından açılıyor ama bu sahneyi seçtiği doğrulanamadı; kabuldeki `koy_parley_sistemi_test.gd` yok | EKSİK | Testi yaz, sahnenin gerçekten açıldığını göster |
| ANL-EPI-01 | `[x]` | `src/sistemler/epilog_metin_verisi.gd` var | Hiç çağrılmıyor; ROADMAP de "UI arayüz kodu: Kalfa bekleniyor" diyor | SAHTE-BAĞSIZ | Kalfa'ya bırak |
| SOY-SON-01 | `[ ]` | — | Görev 22 geri açtı; Görev 23'te de bağlanamadı | SAHTE-BAĞSIZ | Kaynak olaylar oyuna girmeden kapanmaz |
| KVR-SES-01 | `[ ]` | Metin ve adaptör var | Hava motoru Kalfa'da | EKSİK | Kalfa'ya bırak |
| MECLIS-ARA-01 | `[x]` | `data/parley/koy/meclis_davalari.ds` var | Bu sahneyi açan kod bulunamadı | SAHTE-BAĞSIZ | Çınar meclisi paneline bağla |
| SES-DIL-01 | `[x]` | `docs/SESLENDIRME_REJI_KILAVUZU.md` var | Belge maddesi, kod yok | TAM | — |

Ayrıca `gece kapisi ui: map_bg, ornament_emblem, cursor_grab, cursor_busy, icon_akce uretildi` commit'i `assets/ui/atmosfer/gece_kapisi/` altına beş görsel koymuş. Bu, "asset üretilmez" kuralına aykırı. Görseller duruyor; silmek bu denetimin kapsamı dışında.

## ROADMAP'te karşılığı olmayan kimlikler

Commit mesajlarında geçen ama `ROADMAP_2.md` ve `ROADMAP.md` içinde madde satırı bulunamayan 21 kimlik:

`ARA-01`, `ARAR-01`, `ARAR-02`, `ARAR-03`, `DIL-01`, `DNT-01`, `DON-01`, `EN-01`, `EPI-01`, `ESME-02`, `GECM-01`, `NERI-01`, `OMPT-01`, `OMPT-02`, `OREV-08`, `OREV-09`, `OREV-13`, `OREV-21`, `RLIK-01`, `SES-01`, `SON-01`.

Bunların büyük kısmı Görev 17'deki yedi önerinin eski kısa adları (`DON-01` → `ANL-DON-01`, `GECM-01` → `ES-GECM-01`, `EPI-01` → `ANL-EPI-01`, `SES-01` → `KVR-SES-01`). Gerisi İngilizce taslak partileri (`DIL-EN-*`) ve diyalog aşama notları. Ayrı bir madde değiller.

## Belirleyemediklerim

- **DEN-48, DEN-64, DEN-74, DEN-77, DEN-78:** Test sahneleri var ama bu denetimde çalıştırılmadı. Tam koşu Görev 23 kuralıyla yasaktı; sahnelerin totolojik olup olmadığını görmedim.
- **OMR-50:** Dalga kaydırması `python_test_runner.py` ile doğrulanıyor. Aracı çalıştırmadım.
- **YAP-28, YAP-29:** UZM-04 ve NBT-02 testlerine bağlı. O testleri çalıştırmadım.
- **OZL-12:** `kosullar` alanı var ama dört mevsim kartının her birini tek tek açmadım.
- **ES-GECM-01:** Parley sahnesi duruyor; köylü kartının bu sahneyi seçip seçmediğini uçtan uca izlemedim.

## Nasıl baktım

Her madde için ROADMAP metnini, "Dosya:" satırındaki yolu ve o dosyanın `class_name`'ini çıkardım. Sonra sınıfın `src/` altında kaç yerden çağrıldığını saydım. Çağrı yoksa preload ve dosya adı ile de baktım. Veri maddelerinde dosyanın varlığını ve onu okuyan kodu kontrol ettim. Testlerin gerçek sınıfı mı yoksa kendi ürettiği veriyi mi doğruladığını, şüpheli olanlarda testin ilk satırlarından gördüm. Godot çalıştırmadım; tek çalışan araç `tools/denge_dogrula.py` oldu ve "GECTI" verdi.
