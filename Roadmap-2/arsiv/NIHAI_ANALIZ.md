# NIHAI ANALİZ — ROADMAP 2 genişletmesi

Tarih: 11 Ekim 2026. Yazan: Cursor (ROADMAP 2 ajanı). Oyun deposu `Kapı_Muhafizi` yalnız okundu; dal `claude/festive-volta-li1sfm`, HEAD `39847ea tester: tur 4`. Bu dizin dışına yazılmadı, commit yok.

Bu dosya dört aşamanın ortak defteridir. En alttaki **İLERLEME** bölümü kaldığım yeri tutar; bağlam dolarsa oradan devam edilir.

---

## (a) Bölüm ve madde sayımı — başlangıç (Aşama 1 anı)

| Dosya | Bölümler | Kimlik aralığı | Madde | Alt başlık |
|---|---|---|---|---|
| ROADMAP_2_A.md | 13, 14, 15, 24 | BUG-16…25, ACL-01…06, KAP-16…19, ARY-01…05 | 25 | yok (bölüm başına düz liste) |
| ROADMAP_2_B.md | 16, 17, 18, 25 | DIY-01, 01a, 02…18; ZAR-01…06; CAT-01…04; DYL-01…16; KOP-01…10 | 55 | yalnız 25'te (25.1–25.4) |
| ROADMAP_2_C.md | 19, 20, 21, 22, 23, 25a | YAZ-01…10, ISG-01…03, YAP-01…06, YSM-01…03, DNY-01…04, SEV-01…07 | 33 | yok |
| ROADMAP_2_BOLUM_26.md | 26 | NBT-01…10 | 10 | yok |
| ROADMAP_2_BOLUM_27.md | 27 | MCL-01…10 | 10 | yok |
| ROADMAP_2_BOLUM_28.md | 28 | SAB-01…10 | 10 | yok |
| ROADMAP_2_BOLUM_29.md | 29 | TEZ-01…10 | 10 | yok |
| ROADMAP_2_BOLUM_30.md | 30 | YIL-01…10 | 10 | yok |
| ROADMAP_2_BOLUM_31.md | 31 | KAY-01…72 | 72 | 31.1–31.10 |
| ROADMAP_2_BOLUM_32.md | 32 | DEN-01…80 | 80 | 32.1–32.10 |
| ROADMAP_2_BOLUM_44.md | 44 | SAH-01…80 | 80 | 44.1–44.10 |
| **Toplam** | 20 bölüm | | **395** | |

Sayım `rg '^- \[ \] \*\*[A-Z]+-'` ile yapıldı. Bölüm 31'de kimlikler ardışık değildir (31.3: KAY-13…18 + KAY-61…64; 31.8: KAY-43…48 + KAY-65…68; 31.9: KAY-49…54 + KAY-69…72). Kimlik değiştirilmedi.

Eksik bölüm numaraları: 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 45, 46.

---

## (b) Kodda gerçekten var olan sistemler (zemin; yeniden kurulmaz)

Yollar `Kapı_Muhafizi/` köküne göredir. Fonksiyon adları `rg '^func'` ile alındı.

| Sistem | Dosya / kanıt |
|---|---|
| Ayarlar deposu | `src/sistemler/ayarlar.gd` — `VARSAYILAN` anahtarları: `ses_ana`, `ses_muzik`, `ses_efekt`, `ekran_modu` (pencere/tam_ekran), `metin_olcegi` (100/125/150), `belirme_hizi` (normal/hizli/aninda), `grafik_profili` (normal/dusuk), `cozunurluk_3d` (50…100). Fonksiyonlar: `yukle`, `yaz`, `al`, `ayarla`, `varsayilana_don`, `belirme_ms`, `boyut`, `uygula`. Dosya `user://ayarlar.cfg`. Sinyal `degisti`. |
| Ayarlar ekranı | `src/arayuz/ayarlar_ekrani.gd` — `SATIRLAR` altı satır (ses ×3, ekran_modu, metin_olcegi, belirme_hizi). Zemin: tek `ColorRect` `Renkler.GECE` (satır 21–24). Grafik: `src/arayuz/grafik_ayarlari_paneli.gd` (`_secici` OptionButton). |
| Girdi eylemleri | `src/arayuz/ana.gd:238 _eylemleri_kur()` — `geri` (Esc), `menu` (P), `kisayol_1…5` (1–5); gamepad: `geri`=JOY_BUTTON_B, `menu`=JOY_BUTTON_START. `project.godot` içinde `[input]` bloğu **yok**; eylemler çalışma zamanında InputMap'e eklenir. Başka doğrudan tuşlar: `src/arayuz/koy_ekrani.gd` (W/A/S/D/Q/E, 1–5, P, Esc), `src/arayuz/kapi_ekrani.gd`, `heybe_paneli.gd`, `esya_karti.gd`, `mini_oyun.gd`, `src/debug/admin_hud.gd` (F1, `~`), `kapi/esya_detay_karti.gd`. Tuş yeniden atama ekranı yok. |
| Ekran / pencere | `project.godot:21–28` — viewport 1920×1080, override 1600×900, stretch `canvas_items` / `expand`. |
| Yerelleştirme | `project.godot:30–33` — `locale/translations = ["res://data/metin/metinler.tr.translation"]`, `locale/fallback = "tr"`. `src/arayuz/ana.gd:23 TranslationServer.set_locale("tr")` sabit. `data/metin/metinler.csv` başlık `keys,tr`, 1744 satır; tek dil sütunu. `TranslationServer.translate` doğrudan çağrıları: `karar_replik_adaptoru.gd`, `iflas_yoneticisi.gd`, `koylu_karti_verisi.gd`, `levent_firari.gd`, `sancak_teftisi.gd`, `koylu_takibi.gd`, `coban_surusu.gd` (sözlükte sabit TR metin). `tools/metin_dogrula.py`, `docs/METIN_ANAHTAR_STANDARDI.md` var. |
| Tema / yazı tipi | `src/arayuz/tema.gd` — `GOVDE_PX 26`, `KUCUK_PX 22`, `BASLIK_PX 34`; Alegreya değişken font (`assets/font/`); `olustur(ayarlar)`, `font(agirlik, italik)`, `koy_paneli()`. `src/arayuz/renkler.gd`, `src/arayuz/sanat.gd` (`KOK = res://assets/art/`, `doku`, `portre`, `koy_figuru`). |
| Kayıt | `src/sistemler/oturum.gd:8 KAYIT_SURUMU := 3`; `src/koy/koy_yonetimi.gd:17 KAYIT_SURUMU := 1`; `src/sistemler/kayit_deposu.gd` tek dosya `user://kayit.json` (`var_mi`, `yaz`, `oku`, `sil`); `src/sistemler/atomik_json_kaydi.gd`; `src/sistemler/kayit_gocu.gd`; `src/koy/guvenli_kayit.gd`. Kayıt yuvası ve hızlı kayıt yok. |
| Oyun hızı | `src/arayuz/koy_ekrani.gd:330–352` — `_hiz_sec`, `get_tree().paused`, `Engine.time_scale`; divan/harita/oda bağlantıları hızı saklayıp geri yükler (`divan_baglantisi.gd:16`, `koy_hud/harita_baglantisi.gd:17`, `muhafiz_odasi_baglantisi.gd:22`). |
| Performans / bellek | `src/debug/performans_seridi.gd` (`ac`, `_yenile`), `src/dunya/dusuk_bellek_profili.gd` (`memory_free()` beş önbelleği boşaltır), `src/dunya/grafik_profili_adaptoru.gd`, `src/ses/efekt_havuzu_temizligi.gd`, `src/dunya/donma_yoneticisi.gd`. |
| Son ekranı istatistiği | `src/arayuz/ana.gd:125` — `arayuz.son.istatistik` ile gün, kabul, ret, nüfus. Başka istatistik/başarım sistemi yok (`rg -i 'basarim|achievement'` → 0). |
| Olaylar | `src/veri/olay_verisi.gd` (`id`, `baslik_anahtari`, `metin_anahtari`, `kosullar`, `agirlik`, `tek_sefer`, `secenek_anahtarlari`, `secenek_etkileri`, `ses`, `muzik`); `data/olaylar/*.tres` 34 adet: derviş, düğün, bebek, bey_daveti, harman, pazar_gunu, vergi_tahsildari, tekfur_elcisi, kervan, salgın, yangın, kurt vb. Örnek `dervis.tres`: `kosullar {gece_min: 2}`, `tek_sefer`, etki `{ambar: -1, bar: [1,0,0,0], bayrak: dervis}`. |
| Sıra olayları | `data/sira_olaylari/` (atlama, bayılma, kavga, panik, vazgeçen); `src/kapi/sira_atlama_adaptoru.gd`. |
| Fısıltı gazetesi | `src/kapi/fisilti_gazetesi.gd` — `oku`, `durum`, `gece`, `olay`, `tanimli`, `uygun`, `uygula`; veri `data/fisilti_gazetesi.json`. |
| Karakter kadrosu / hafıza | `src/sistemler/karakter_kadrosu.gd` — `durumlar: Dictionary`, `uygunlar(gece)`, `iste`, `ziyaret_basladi`, `sonuc(id, kaldi, karar, gece)`, `kaydet`, `yukle`. |
| Takvim | `src/koy/takvim.gd` statik: `mevsim`, `kis_mi`, `mevsim_gunu`, `yil_gunu`, `hafta_basi`. Mevsim 7 gün, yıl 28 gün (MEV-01). |
| Denge sayıları | `data/ayarlar/oyun.tres` (`gece_basina_gelen 3`, `oturma_esigi 18`, `perde2_gece_basina_gelen 2`, `perde2_hedef_gece 12`, `olay_olasiligi 0.75`, `sira_olay_olasiligi 0.35`, `yalan_olasiligi 0.35`, `azami_soru 4`, `rusvet_hakki 3`, bina bedelleri…); `data/ayarlar/koy.tres` (`kervan_araligi 4`); `data/koy/*.json` 18 dosya. |
| Divan | `src/kapi/divan_*.gd` (oturum, hüküm, kanıt, haksızlık, sorgu paneli). |
| Muhafız odası | `src/dunya/muhafiz_odasi.gd/.tscn`, `src/arayuz/muhafiz_odasi_ekrani.gd`, `oda_*_paneli.gd` (kasa, terazi, vicdan, yetenek, geliştirme, envanter, teftiş). |
| Köy HUD | `src/arayuz/koy_hud/` ~45 panel; `src/arayuz/hud.gd`, `hud_islem_kapisi.gd`. |
| Debug / tester | `src/debug/` (admin_hud, senaryo_kosucusu, zaman_makinesi, kriz/kaynak/stat enjektörleri, diyalog_deneyi, performans_seridi); `tools/` (sanity_check.py, acilis_denetimi.py, api_sozlesmesi.py, metin_dogrula.py, godot_script_taramasi.py, python_test_runner.py); `tests/oto` 144 `.tscn`, `tests/unit` 184 `*_test.gd`. |
| Hane / eş | Kodda eş, hane, aile verisi **yok** (`rg -w 'hane|eşi|esi'` yalnız yorumlarda "çocuk"). ACL-01…03 ve DYL-07 bunu ilk kez kurar; Bölüm 36 onlara biner. |
| Açık R1 kalıntıları | ADM-16 `[/]` (Oyun Köprüsü). ADV-01…07 (`docs/denetim/2026-10-10-claude-test-raporu.md:62–69`). Tester: TST-0001 (KoyNufusu.sayi SCRIPT ERROR), TST-0002 (6 eksik metin anahtarı), TST-0005 (43 öksüz .import), TST-0006 (çift boşluk/yinelenen tekfur metni), TST-0007 (chr_011 kukuleta), TST-0008 (ayak havada / Aydoğdu yayı) AÇIK. BUG-0011…0015 DÜZELTİLDİ (Codex, `docs/denetim/2026-10-11-codex-oz-denetim.md:113–117`). |

---

## (c) Eksikler, çakışmalar, tekrarlar, kural ihlalleri

### Eksikler
1. Bölüm 33–43, 45, 46 yazılmamış. 31, 32 ve 44 onlara atıf veriyor: hızlı kayıt/yuva → 35 (`BOLUM_31.md:5, :189`); zorluk menüsü → 35 ve 43 (`DEN-72`); tuşlar → 45 (`BOLUM_44.md:11`).
2. 25a ve 26–30 alt başlıksız (indeks madde 9 bunu 46 sonrasına bırakmıştı; Muharrir talimatıyla tek seferde yapılır).
3. Bölüm 32 ve 44'te "Ne" satırı yok (Kabul/Bağımlılık/Dosya/Asset var). Ahmet'in biçimi Ne ister. Yeniden yazılmaz; eksik, Aşama 4 raporunda not edilir; yeni bölümler Ne ile yazılır.
4. İndeks tablosunda A/B/C satırlarının bölüm numaraları (13–15, 24 / 16–18, 25 / 19–23, 25a) yok; yalnız dosya adı var.

### Çakışma / tekrar riski (yeni bölüm yazarken sınır)
- **40 ↔ 25.3 (DYL-11…16):** 25.3 yazım araçlarını tanımlıyor. 40 onları kopyalamaz; kalite kapısı, tarama, kabul ölçütü ve hat disiplinini ekler. DYL kimlikleri yerinde kalır; 40 onlara atıf verir.
- **43 ↔ 24 (ARY-01…05):** ARY-02 tema altyapısı, ARY-03 sekiz ekranın taşınması. 43 ekranları dosya adıyla tek tek envanterler, arka planı olmayanları işaretler; ARY-03'ün alt kapanışlarını kimliklendirir. ARY kimlikleri değişmez.
- **34 ↔ 30 (YIL):** 30 mevsim izini kişiye bağlar. 34 perde yapısıdır (SYS-19 köy oturdu / perde 2, SYS-20 beş son, DNY zaman çizelgesi). Mevsim satırı 34'e girmez.
- **36 ↔ ACL-01…03, DYL-07, MCL-03, SAB-02:** eş ve hane orada açılıyor. 36 akşam sohbetini yeniden kurmaz; hane içi günlük döngü, çocuk/yaşlı, ev ekonomisi, komşuluk. Kalp puanı/romans/hediye yasak.
- **37 ↔ DIY-13 dedikodu, KOP-05 fısıltı, BUG-17, SAB-04, MCL:** 37 dedikodunun ağını (kaynak → taşıyıcı → kulak → kamuoyu) ve HUD görünürlüğünü kurar; fısıltı gazetesi motoru ve DIY-13 yayılım kuralı yeniden yazılmaz.
- **38 ↔ data/olaylar (derviş, düğün, bebek, bey_daveti, vergi_tahsildari, tekfur_elcisi…), KAP-16 boş gün, SEV-01:** olay sistemi var. 38 onları sahneye ve Söz motoruna bağlar, yeni olay türü (cenaze töreni, âşık, kadı) ekler; `OlayVerisi` şeması değişmez.
- **39 ↔ DIY-14 "Bu hatırlanacak", DYL-08 kararın dönüşü, DIY-07 beyan defteri, SAB-01 sabah defteri:** 39 oyuncunun okuyacağı tek hafıza defteri arayüzüdür; kayıt alanlarını yeniden tanımlamaz.
- **41 ↔ 31 (KAY), BUG-16…25, ADV-01…07, TST-000x:** 41 teknik borç ve performanstır. Açık ADV ve TST kayıtları kimlik korunarak madde olur ("eski: ADV-03" gibi).
- **42 ↔ DEN (ölçüm), ARY-04 yükleme:** 42 demo kesiti, başarım/istatistik, ekran listesi; asset yok.
- **45 ↔ BUG-24 orta tuş kamera, SAH (44):** 45 tuş atama ve gamepad; BUG-24 yerinde kalır.
- **46 ↔ SYS-09 metin anahtarı, TST-0002, `metin_dogrula.py`:** 46 ikinci sütun altyapısı; çeviri kapsam dışı.
- **33 ↔ ACL-04 açılış, KAP-16, BUG-21/22 açılış ekonomisi, TST-07 persona:** 33 ilk saatin öğretim akışıdır; açılış sahnesini yeniden yazmaz.

### Kural ihlali / tutarsızlık
- İndeks madde 8 "Her biri onay beklemeden yazılmaz" ve madde 9 "O iş 46 bitmeden başlanmaz": Muharrir talimatı (tek seferde bitir) ile geçersiz. İndekste "(Muharrir, 11 Ekim: iptal)" notu düşülür, metin silinmez.
- Bölüm 30 dosya başlığı "# Kapı Muhafızı — ROADMAP 2 / Bölüm 30" + "## BÖLÜM 30" çift başlık; 26–29 tek başlık. Yapı birleştirilirken 30'un üst başlığı korunur, alt başlıklar `###` olur.
- Karar kaydına aykırı madde taraması: `rg -i 'kalp puan|romans|hediye takvimi|seslendirme|ikinci harita'` → yalnız yasak cümleleri ("yoktur") içeren satırlar; ihlal yok.
- Kimlik çakışması: yok (her kimlik tek dosyada).

---

## (d) Yazılacak bölümler ve sıra

Sıra Ahmet'in listesi + bağımlılıklara göre:

1. **33** Oyuncuyu alıştırma ve ilk saat (OGR) — ACL-04, KAP-16, BUG-21/22 üstüne.
2. **34** Ana hikâye omurgası ve perde yapısı (OMR) — SYS-19/20, DNY-01…04, YIL ile sınır.
3. **35** Ayarlar, erişilebilirlik ve okuma konforu (AYR) — `ayarlar.gd`, KAY-30 hızlı kayıt, DEN-72 zorluk.
4. **36** Muhafızın kişisel hayatı ve hane içi diyalog (HAN) — ACL-01…03, DYL-07.
5. **37** Söylenti, dedikodu ve kamuoyu ağı (SOY) — DIY-13, fısıltı gazetesi.
6. **38** Gece, kapı dışı ve özel olaylar (OZL) — `data/olaylar`, KAP-16.
7. **39** Karar sonuçlarının görünürlüğü ve hafıza defteri (HFZ) — DIY-14, DYL-08.
8. **40** Diyalog kalite güvencesi ve yazım hattı (KLT) — 25.3 ile birleşik atıf.
9. **41** Performans, kararlılık ve teknik borç (TEK) — ADV-01…07, TST-000x, ADM-16.
10. **42** Sürüm hazırlığı ve cila (SRM) — demo, başarım, istatistik, ekran listesi.
11. **43** Arayüz görsel revizyonu (GRV) — YÜKSEK ÖNCELİK; ekran envanteri dosya adıyla; ARY ile birleşik.
12. **45** Kontroller ve girdi (GIR) — `_eylemleri_kur`, gamepad.
13. **46** Yerelleştirme altyapısı (YER) — `metinler.csv` ikinci sütun, `set_locale`.
14. Kendi eklerim (47+): Aşama 3 sonunda üç soruyla gerekçelendirilerek; zayıf olan eklenmez.

Yeni kimlik önekleri mevcutlarla çakışmaz (kontrol: ADM, BUG, KAP, KVR, UZM, EKO, ANI, TUC, MEV, CAS, ODA, HAR, KRI, SYS, ACL, ARY, DIY, ZAR, CAT, DYL, KOP, YAZ, ISG, YAP, YSM, DNY, SEV, NBT, MCL, SAB, TEZ, YIL, KAY, DEN, SAH, TST).

Biçim: her madde `Ne / Kabul / Bağımlılık + Boyut / Dosya / Asset`. Her bölüm 10 alt başlık; alt başlıkta on madde dolmazsa bölüm sonunda tek cümle sebep.

---

## (e) Kapanış sayımı — 11 Ekim 2026, Aşama 4

Madde sayımı `^- \[ \] \*\*[A-Z]` ile. Kimlik çakışması: aynı kimlik iki dosyada checkbox olarak yok.

| Dosya | Kimlik | Madde | Alt başlık |
|---|---|---|---|
| A | BUG, ACL, KAP, ARY | 25 | düz liste |
| B | DIY, ZAR, CAT, DYL, KOP | 55 | 25'te 4 |
| C | YAZ, ISG, YAP, YSM, DNY, SEV | 33 | 25a'da 4 |
| 26 | NBT-01…10 | 10 | 5 (gerekçe dosya sonunda) |
| 27 | MCL-01…10 | 10 | 5 |
| 28 | SAB-01…10 | 10 | 5 |
| 29 | TEZ-01…10 | 10 | 4 |
| 30 | YIL-01…10 | 10 | 6 |
| 31 | KAY-01…72 | 72 | 10 |
| 32 | DEN-01…80 | 80 | 10 |
| 33 | OGR-01…57 | 57 | 10 |
| 34 | OMR-01…55 | 55 | 10 |
| 35 | AYR-01…52 | 52 | 10 |
| 36 | HAN-01…52 | 52 | 10 |
| 37 | SOY-01…50 | 50 | 10 |
| 38 | OZL-01…35 | 35 | 10 |
| 39 | HFZ-01…32 | 32 | 10 |
| 40 | KLT-01…25 | 25 | 10 |
| 41 | TEK-01…34 | 34 | 10 |
| 42 | SRM-01…26 | 26 | 10 |
| 43 | GRV-01…30 | 30 | 10 |
| 44 | SAH-01…80 | 80 | 10 |
| 45 | GIR-01…26 | 26 | 10 |
| 46 | YER-01…23 | 23 | 10 |
| **Toplam** | | **892** | |

Aşama 1 anındaki 395 madde duruyor. Eklenen 497 madde: 33–43, 45, 46. 26–30'a madde eklenmedi.

Bölüm 32 ve 44'te "Ne" satırı hâlâ yok. Gövde yeniden yazılmadı; yeni bölümler Ne ile yazıldı.

Başlık aralığı, gövdede olmayan kimlik taşımaması için düzeltildi: SOY-50, OZL-35, HFZ-32, KLT-25, TEK-34, SRM-26, GRV-30, GIR-26, YER-23. Köy HUD dosya sayısı 43 (`src/arayuz/koy_hud/*.gd`).

İleri atıflar karşılandı: HFZ-01, SOY-01/02/03/05, TEK-10, SRM-05, GIR-01, GIR-03, GIR-06, YER-01, YER-02.

### Bölüm 47 açılmadı

Üç soru: (1) Oyuncuya ne katar? (2) ROADMAP 1 veya 2'de zaten var mı? (3) Mevcut mimariye nasıl bağlanır?

- Mod / atölye: bu sürümde oyuncuya bir şey katmaz; depoda yükleyici yok. Zayıf.
- Fotoğraf modu: oynanışa bağlanmaz. Zayıf.
- Steam başarımı: SRM-11 ayrı sistem açmamayı yazdı; `basarim` kodu 0. Ayrı bölüm ikinci kez aynı red olur.
- Seslendirme: karar kaydı yasak. Bölüm açılmaz.
- Çok oyunculu: tek harita kararına ters; mimari yok.

## İLERLEME

- [x] Aşama 1 — okuma ve bu dosya (11 Ekim 2026).
- [x] Aşama 2 — indeks madde 8/9 notu + madde 10 faz sırası; 25a (4), 26 (5), 27 (5), 28 (5), 29 (4), 30 (6) alt başlık; madde eklenmedi. 32/44 "Ne" satırı yok, yeniden yazılmadı.
- [x] Aşama 3 — 33…46 yazıldı (37 yarım kaldığı yerden kapatıldı; 38 OZL, 39 HFZ, 40 KLT, 41 TEK, 42 SRM, 43 GRV, 45 GIR, 46 YER). Bölüm 47 yok.
- [x] Aşama 4 — kimlik çakışması yok; indeks tablosu 37–43, 45, 46 satırlarını aldı; başlık aralıkları gövdeyle eşitlendi.

Kaldığım yer: katı ayıklama. Son biten alt başlık: 25.2 içinde DYL-03 ve DYL-04. Sıradaki: DYL-30 (DYL-05'e bağlı) ve DYL-05 gövdesi. Parça C ve bölüm 26–30 henüz açılmadı. Öz denetim yapılmadı.

## Birleştirilen/silinen kimlikler

Ek turdaki kısa maddeler. `dup`: başka maddenin tekrarı, silindi. `ban`: yasak veya kontrol, hedefin kabul satırına taşındı. Numaralar yeniden sıralanmadı. 829 kısa madde bağımsız kural olarak genişletildi; onlar bu tabloda yok.

| Kimlik | Tür | Nereye | Başlık |
|---|---|---|---|
| ACL-07 | dup | ACL-01 | Oyun köy ekranından açılır |
| ACL-17 | dup | HAN-10 | Meslek üretimi ayrı keseye yazmaz |
| ACL-23 | dup | DYL-07 | Akşam sohbeti ACL-03'tür |
| ACL-25 | dup | HAN-13 | Misafir gecesi üç ağızdır |
| ACL-27 | dup | DYL-08 | Sohbet karar sonucunu okur |
| ACL-28 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Sohbet metni anahtardır |
| ACL-30 | ban | ACL-03 kabul | Sohbet kalp yazmaz |
| ACL-31 | dup | ACL-04 | Kapıyı ulak açar |
| ACL-32 | dup | BUG-18 | Ulak tehdit sayılmaz |
| ACL-34 | dup | OGR-02 | İlk gece rüşvet kapalıdır |
| ACL-35 | dup | ARY-04 | Ulak sahnesi yükleme çerçevesini kullanır |
| ACL-36 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Berat metni anahtardır |
| ACL-38 | dup | ACL-05 | İlk aile yatak uyarısını görür |
| ACL-46 | dup | OGR-08 | Uyarı metni doksan karakteri aşmaz |
| ACL-49 | ban | ACL-06 kabul | Geçmiş kalp açmaz |
| ACL-52 | ban | ACL-06 kabul | Geçmiş sesi yoktur |
| ACL-54 | dup | YAZ-10 | Geçmiş metni üsluptan geçer |
| ACL-56 | dup | HAN-04 | Sofra hafta başında bir gıdadır |
| ACL-57 | dup | HAN-18 | Eş duyumu günde bir |
| ACL-58 | dup | SOY-02 | Duyum söylenti düğümüdür |
| ACL-59 | dup | HAN-12 | Hane misafiri bir gecedir |
| ACL-62 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Hane metni anahtardır |
| ACL-64 | dup | OGR-04 | İlk köy ekranı kabulden sonra |
| ACL-66 | dup | OGR-08 | İpucu pencere açmaz |
| ACL-80 | ban | ACL-01 kabul | Yasak sahne yoktur |
| ACL-81 | ban | ACL-01 kabul | Wav yoktur |
| ACL-82 | ban | ACL-02 kabul | Kalp yoktur |
| ACL-83 | ban | ACL-01 kabul | İkinci harita yoktur |
| ACL-84 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| ARY-19 | ban | ARY-02 kabul | Admin temayı import etmez |
| ARY-30 | dup | ARY-04 | Yükleme yuvası sekizdir |
| ARY-33 | dup | TEK-21 | Hazırlanıyor anahtardır |
| ARY-35 | dup | ACL-04 | Ulak ara sahnesi aynı çerçevededir |
| ARY-36 | dup | TEK-19 | Yükleme input'u bitince bırakır |
| ARY-38 | dup | ARY-05 | Envanter kimliksiz satır tutmaz |
| ARY-46 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Boş liste metni anahtardır |
| ARY-59 | dup | GIR-06 | Sekme odağı kopuk düğme bırakmaz |
| ARY-60 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Sekme metni anahtardır |
| ARY-64 | dup | GRV-19 | Heybe defterin üstüne binmez |
| ARY-65 | dup | SRM-05 | Debug katmanı oyuncuda yoktur |
| ARY-66 | dup | OGR-08 | Bildirim ipucu pencere açmaz |
| ARY-67 | dup | HFZ-22 | Son ekranı defteri açmaz |
| ARY-68 | ban | GRV-18 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Mini oyun kadrajı temadadır |
| ARY-76 | ban | ARY-02 kabul | Köy hız düğmesi tema durumunu kullanır |
| ARY-79 | dup | TST-0007 | 3B cila burada yoktur |
| ARY-84 | dup | TEK-12 | Baseline stil artınca güncellenir |
| BUG-38 | dup | KOP-05 | Gazete bar değiştirmez |
| BUG-45 | dup | HAR-02 | Moğol sayacı durmaz |
| BUG-53 | dup | BUG-16 | Sırada kimse yoksa olay başlamaz |
| BUG-56 | dup | KRI-05 | Ölüm cenazeyi bir kez çağırır |
| BUG-58 | dup | BUG-21 | Taş yatağı açılış tablosundadır |
| BUG-64 | dup | BUG-23 | Çiftçi tarla hücresindedir |
| BUG-70 | dup | BUG-25 | Meşale modeli eksikse düz ışıktır |
| BUG-75 | dup | TEK-01 | Eksik sınıf anahtarı sıfır döner |
| BUG-92 | dup | TEK-02 | Yetim import silinir, jpg üretilmez |
| BUG-93 | dup | TST-0007 | Model ölçüsü bu bölümde yoktur |
| BUG-95 | dup | ADM-16 | Portsuz köprü dinlemez |
| BUG-96 | dup | SRM-05 | Admin oyuncuda doğmaz |
| BUG-100 | ban | BUG-16 kabul | Yasak sahne yoktur |
| BUG-101 | dup | OZL-25 | Yeni olay kartı bu bölümde yoktur |
| BUG-103 | dup | TEK-12 | API artınca baseline güncellenir |
| CAT-05 | dup | CAT-01 | Ret kavga açabilir |
| CAT-09 | dup | KOP-04 | Kavga ikinci kuyruk açmaz |
| CAT-10 | dup | BUG-19 | Kavga metni kişiye göredir |
| CAT-16 | dup | ZAR-01 | Söz yatıştırma zar ister |
| CAT-17 | dup | CAT-04 | Ret sırayı korkutur |
| CAT-19 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Seçenek metni anahtardır |
| CAT-20 | ban | ARY-02 kabul | Seçenek tema düğmesidir |
| CAT-21 | dup | CAT-03 | Yaralı hekim varsa iyileşir |
| CAT-25 | dup | KRI-05 | Ölüm cenazeye gider |
| CAT-28 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Yara metni anahtardır |
| CAT-29 | dup | CAT-04 | Şiddet sıradaki tansiyonu artırır |
| CAT-30 | dup | ZAR-03 | Artış 10'da kişiyi gönderir |
| CAT-37 | dup | OZL-07 | Kavga Söz düğümü açabilir |
| CAT-38 | dup | DIY-06 | Kavga beyan yazar |
| CAT-39 | dup | DIY-14 | Kavga hatırlanacak açabilir |
| CAT-42 | dup | NBT-02 | Yaralı nöbet tutamaz |
| CAT-43 | dup | SOY-12 | Kavga meclise ancak kamuoyuysa girer |
| CAT-59 | dup | DEN-04 | Zorluk çarpanı oranı çarpar |
| CAT-60 | dup | DEN-06 | Ölçüm oyuncuda görünmez |
| CAT-64 | dup | SRM-05 | Debug kavga oyuncuda yoktur |
| CAT-66 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| CAT-67 | dup | TEK-12 | Baseline güncellenir |
| CAT-69 | ban | CAT-01 kabul | Yasak sahne yoktur |
| CAT-72 | ban | CAT-01 kabul | İkinci harita yoktur |
| CAT-73 | ban | CAT-02 kabul | Kalp yoktur |
| CAT-77 | dup | CAT-02 | Dört seçenek kimliği değişmez |
| CAT-83 | dup | KOP-05 | Gazete kavga satırını kendisi yazmaz |
| DNY-07 | dup | KLT-22 | Çizelge çalışma anında kitap okumaz |
| DNY-09 | dup | SYS-19 | İşaret perdeyi atlatmaz |
| DNY-10 | dup | SYS-20 | İşaret altıncı son açmaz |
| DNY-12 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | İşaret metni anahtardır |
| DNY-17 | dup | OZL-20 | Haber kartı ile yüz aynı gece çakışmaz |
| DNY-20 | ban | DNY-02 kabul | Haber sesi yoktur |
| DNY-22 | dup | KAP-18 | Savaş haberi yetim kafilesini açar |
| DNY-27 | dup | BUG-16 | Etki küçük nüfusta susar |
| DNY-33 | dup | HFZ-05 | İşaret deftere düşer |
| DNY-42 | dup | OMR-24 | Bir gecede bir dış yüz |
| DNY-45 | ban | ARY-02 kabul | Haber paneli tema zemini ister |
| DNY-50 | dup | GIR-06 | Odak haber düğmesinde kopmaz |
| DNY-52 | ban | SRM-05 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Haber debug'da enjekte edilir |
| DNY-53 | dup | MEV-01 | Çizelge sırası takvim günüdür |
| DNY-56 | dup | BUG-18 | Tehdit süresi dünyayı silmez |
| DNY-57 | dup | OMR-08 | Perde geçiş gecesi yüz gelmez |
| DNY-64 | dup | TEK-12 | Baseline güncellenir |
| DNY-65 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| DNY-66 | dup | SRM-05 | Debug işaret oyuncuda yoktur |
| DNY-69 | ban | DNY-01 kabul | Yasak sahne yoktur |
| DNY-70 | ban | DNY-01 kabul | İkinci harita yoktur |
| DNY-71 | ban | DNY-02 kabul | Ses yoktur |
| DNY-72 | ban | DNY-04 kabul | Kalp yoktur |
| DNY-73 | ban | SYS-20 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Altıncı son yoktur |
| DNY-75 | dup | KLT-22 | Kitap export'a girmez |
| DNY-78 | dup | MCL-09 | Meclis dünya işareti açamaz |
| DNY-82 | dup | YIL-10 | Yıl izi haber sayılmaz |
| DNY-83 | dup | SEV-02 | Sevilen yüz dünya elçisi değildir |
| DYL-19 | dup | DYL-02 | Bakış konuşma hakkı harcamaz |
| DYL-24 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Bakış metni anahtardır |
| DYL-36 | dup | DYL-07 | Akşam sohbeti ACL-03 sahnesidir |
| DYL-38 | dup | HAN-13 | Akşam sohbeti misafirle üç ağız olur |
| DYL-44 | dup | SOY-22 | Denetçi sorusu rüşvet kamuoyusunu okur |
| DYL-58 | dup | KLT-14 | Örneksiz taslak reddedilir |
| DYL-60 | dup | DYL-15 | Site düzenleyici oyun içi değildir |
| DYL-62 | dup | DIY-01a | Site sır dayatmaz |
| DYL-70 | dup | SOY-12 | Sonuç meclis şikâyetine ancak kamuoyuysa girer |
| DYL-71 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Sonuç metni anahtardır |
| DYL-80 | dup | OGR-08 | Eylem ipucu doksan karakteri aşmaz |
| DYL-84 | ban | SRM-05 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Debug eylem enjekte edilir |
| DYL-86 | dup | YAZ-09 | Eylem kotaya girer |
| DYL-87 | ban | DYL-08 kabul | Eylem ikinci harita açmaz |
| DYL-88 | ban | YAZ-09 kabul | Eylem kalp yazmaz |
| DYL-90 | ban | DYL-01 kabul | Yasak sahne yoktur |
| DYL-92 | ban | TEK-12 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Baseline güncellenir |
| DYL-93 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| DYL-94 | dup | DYL-11 | 25.3 kimlikleri durur |
| ISG-04 | dup | ISG-01 | Kabul anında uyarı bir kez |
| ISG-06 | dup | UZM-08 | Çocuk uyarısı iş önermez |
| ISG-08 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Uyarı metni anahtardır |
| ISG-10 | dup | OGR-08 | Uyarı doksan karakteri aşmaz |
| ISG-17 | dup | ACL-01 | Eş havuza girmez |
| ISG-19 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Havuz metni anahtardır |
| ISG-23 | dup | UZM-08 | Çocuk boşta bedeli yemez |
| ISG-29 | ban | ARY-02 kabul | Atama tema düğmesi kullanır |
| ISG-31 | dup | TEK-23 | Atama gece kilidinde kapalıdır |
| ISG-34 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Atama metni anahtardır |
| ISG-49 | dup | TEK-23 | Yıkım gece kilitliyken kapalıdır |
| ISG-50 | dup | KRI-05 | İşçi ölünce yer boşalır |
| ISG-54 | dup | TEK-03 | Kart güvenlik satırı kaybolmaz |
| ISG-55 | ban | GRV-31 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Kart tema zemini GRV'dedir |
| ISG-58 | dup | GRV-13 | Sayı punto 22 altı değildir |
| ISG-59 | dup | SOY-31 | İş satırı söylenti balonu değildir |
| ISG-64 | dup | SRM-05 | Debug atama oyuncuda yoktur |
| ISG-65 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| ISG-66 | dup | TEK-12 | Baseline güncellenir |
| ISG-68 | ban | ISG-01 kabul | Yasak sahne yoktur |
| ISG-70 | ban | ISG-01 kabul | Kalp yoktur |
| ISG-71 | ban | ISG-01 kabul | Ses yoktur |
| ISG-72 | ban | ISG-02 kabul | Hediye ile iş açılmaz |
| ISG-81 | dup | MCL-09 | Meclis iş atamaz |
| ISG-82 | dup | KOP-05 | Gazete iş ilanı basmaz |
| KAP-54 | dup | DNY-01 | Yetim kafilesi savaş haberi olmadan gelmez |
| MCL-11 | dup | MCL-01 | Konuşan köydedir |
| MCL-13 | dup | UZM-08 | Çocuk söz istemez |
| MCL-16 | dup | MCL-08 | Ölü listede durmaz |
| MCL-18 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Konuşan metni anahtardır |
| MCL-19 | dup | MCL-04 | Oy KRI-07 değerine yazar |
| MCL-28 | dup | MCL-06 | Düğme konuşulan adı söyler |
| MCL-29 | dup | MCL-07 | En ağır karar önce konuşur |
| MCL-30 | dup | SOY-12 | Ağırlık kamuoyu konusundandır |
| MCL-31 | dup | MCL-02 | Şikâyet kararın adını taşır |
| MCL-34 | ban | ARY-02 kabul | Düğme temadadır |
| MCL-35 | dup | MCL-09 | Savaş açılmaz |
| MCL-37 | dup | SYS-20 | Son değişmez |
| MCL-41 | dup | DNY-04 | Çizelge işareti yazılmaz |
| MCL-42 | ban | MCL-01 kabul | Kalp yazılmaz |
| MCL-45 | ban | MCL-01 kabul | Yasak sahne yoktur |
| MCL-46 | ban | MCL-01 kabul | Wav yoktur |
| MCL-49 | dup | SRM-05 | Debug meclis oyuncuda yoktur |
| MCL-50 | dup | TEK-12 | Baseline güncellenir |
| MCL-51 | dup | SOY-12 | Şikâyet kaynağı kamuoyudur |
| MCL-52 | dup | MCL-06 | Şikâyet adı kişidir |
| MCL-53 | dup | SOY-05 | Yanlış söylenti şikâyet olabilir |
| MCL-57 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Şikâyet metni anahtardır |
| MCL-64 | dup | DNY-02 | Haber meclisten önce düşmüş olmalıdır |
| MCL-65 | dup | SRM-07 | Demo perde 2 meclisini keser |
| MCL-66 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Hat konusu metni anahtardır |
| MCL-68 | ban | ARY-02 kabul | Panel tema zemini ister |
| MCL-70 | dup | GIR-06 | Odak iki düğmeyi gezer |
| MCL-74 | ban | SOY-31 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Baloncuk yoktur |
| MCL-75 | dup | ACL-03 | Akşam sohbeti meclis gecesinde yoktur |
| MCL-79 | dup | SOY-40 | Küçük nüfus meclis açmaz |
| MCL-80 | dup | YSM-03 | Meclis uyku sayılmaz |
| MCL-83 | ban | MCL-01 kabul | Yasak sahne yoktur |
| MCL-85 | ban | MCL-01 kabul | Wav yoktur |
| MCL-86 | ban | MCL-04 kabul | Kalp yoktur |
| MCL-87 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| MCL-88 | dup | TEK-12 | Baseline güncellenir |
| MCL-89 | dup | SRM-05 | Debug kapalıdır |
| NBT-11 | dup | UZM-08 | Çocuk nöbet tutmaz |
| NBT-12 | dup | ACL-01 | Eş nöbet tutmaz |
| NBT-13 | dup | YSM-02 | Bitkin nöbet tutmaz |
| NBT-14 | dup | KRI-05 | Ölü direğe yazılmaz |
| NBT-18 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Nöbetçi metni anahtardır |
| NBT-23 | dup | KRI-14 | Kıtlık nöbetçiyi ambara yeni yolla çekmez |
| NBT-33 | ban | ARY-02 kabul | Rapor temadadır |
| NBT-36 | dup | NBT-09 | Oyuncu direğe geçince nöbetçi çekilir |
| NBT-46 | ban | NBT-01 kabul | Yasak sahne yoktur |
| NBT-47 | ban | NBT-01 kabul | Wav yoktur |
| NBT-48 | ban | NBT-01 kabul | Kalp yoktur |
| NBT-50 | dup | SRM-05 | Debug atama oyuncuda yoktur |
| NBT-57 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Seçim metni anahtardır |
| NBT-58 | ban | ARY-02 kabul | Seçim temadadır |
| NBT-72 | dup | SYS-20 | Oyuncu ölürse son ekranı |
| NBT-78 | dup | EKO-01 | Maaş çift kasaya gider |
| NBT-83 | ban | NBT-01 kabul | Yasak sahne yoktur |
| NBT-85 | ban | NBT-01 kabul | Wav yoktur |
| NBT-86 | dup | TEK-12 | Baseline güncellenir |
| NBT-87 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| NBT-88 | dup | SRM-05 | Debug kapalıdır |
| SAB-12 | dup | CAS-07 | Satır divan kaydını okur |
| SAB-16 | ban | ARY-02 kabul | Satır tema ile çizilir |
| SAB-23 | dup | SEV-07 | Ölü tezgâh veda ile kapanır |
| SAB-24 | dup | UZM-08 | Çocuk tezgâh açmaz |
| SAB-26 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Sabah metni anahtardır |
| SAB-27 | dup | SAB-05 | Zindan ekmeği bir pay |
| SAB-30 | dup | SAB-06 | Sürgün kapıdan bir addır |
| SAB-32 | dup | SAB-07 | İnfaz cenazeyi bir kez çağırır |
| SAB-33 | dup | SAB-10 | Sürgünde cenaze 0 |
| SAB-34 | dup | SAB-10 | İnfazda yol 0 |
| SAB-35 | dup | SAB-08 | İkinci sabah ekmeği sürer |
| SAB-36 | dup | SAB-09 | Üçüncü sabah vekil aramaz |
| SAB-39 | dup | SAB-10 | Zindanda yol yüzünden nüfus düşmez |
| SAB-44 | dup | SAB-10 | Kapanış erzak yazmaz |
| SAB-46 | dup | SAB-10 | Kapanış temadadır |
| SAB-47 | dup | SAB-10 | Kapanış anahtardır |
| SAB-48 | dup | SAB-10 | Kapanış ayrı sahne değildir |
| SAB-49 | dup | SAB-10 | Kapanış ölçümü DEN satırıdır |
| SAB-50 | dup | SAB-10 | Kapanış ikizde aynıdır |
| SAB-52 | dup | KAP-16 | Sabah boş günde de vardır |
| SAB-66 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Pay metni anahtardır |
| SAB-73 | ban | SAB-06 kabul | Yol sesi yoktur |
| SAB-77 | dup | GIR-08 | Kapatma Esc ile olur |
| SAB-79 | dup | GIR-06 | Odak kapat düğmesindedir |
| SAB-81 | dup | SRM-05 | Debug sabah oyuncuda yoktur |
| SAB-82 | dup | SOY-31 | Baloncuk yoktur |
| SAB-83 | ban | SAB-01 kabul | Yasak sahne yoktur |
| SAB-85 | ban | SAB-01 kabul | Wav yoktur |
| SAB-86 | ban | SAB-01 kabul | Kalp yoktur |
| SAB-87 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| SAB-88 | dup | TEK-12 | Baseline güncellenir |
| SAB-89 | ban | SAB-06 kabul | İkinci harita yoktur |
| SEV-08 | dup | SEV-01 | Boş gün köy günüdür |
| SEV-09 | dup | KAP-16 | Boş gün kuyruk üretmez |
| SEV-10 | dup | OZL-08 | Boş günde sıra olayı yoktur |
| SEV-13 | dup | KAP-16 | Boş gün 28 günde alt sınırdadır |
| SEV-14 | dup | BUG-18 | Boş gün tehdit doğurmaz |
| SEV-15 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Boş gün metni anahtardır |
| SEV-16 | dup | SEV-02 | Tanıdık ateşe gelir |
| SEV-23 | ban | SEV-02 kabul | Ateş sesi yoktur |
| SEV-24 | dup | SEV-03 | İz köyde kalır |
| SEV-26 | dup | SEV-07 | İz ölüde veda ile kalkar |
| SEV-31 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | İz metni anahtardır |
| SEV-37 | dup | DIY-14 | İstek sözü hatırlanır |
| SEV-39 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | İstek metni anahtardır |
| SEV-41 | ban | SEV-05 kabul | Bağ kalp değildir |
| SEV-43 | dup | SEV-07 | Bağ ölümde kalkar |
| SEV-45 | ban | SEV-05 kabul | Bağ hediye istemez |
| SEV-48 | dup | SEV-06 | Ad sorulmadan maske kalır |
| SEV-49 | dup | YAZ-08 | Ad köy sohbetinde de öğrenilir |
| SEV-52 | dup | DIY-06 | Ad beyan defterine düşer |
| SEV-53 | dup | DYL-01 | Yanlış ad yüzleştirilebilir |
| SEV-55 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Ad metni anahtardır |
| SEV-56 | dup | SEV-07 | Veda kişiyi götürür |
| SEV-57 | dup | KRI-05 | Cenaze iki seçenektir |
| SEV-59 | dup | SEV-03 | Veda izi siler |
| SEV-63 | ban | SEV-07 kabul | Veda sesi yoktur |
| SEV-65 | ban | ARY-02 kabul | Ateş satırı tema ile çizilir |
| SEV-67 | dup | GIR-06 | Odak kopuk değildir |
| SEV-75 | dup | SRM-05 | Debug yüz oyuncuda yoktur |
| SEV-76 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| SEV-77 | dup | TEK-12 | Baseline güncellenir |
| SEV-80 | ban | SEV-01 kabul | Yasak sahne yoktur |
| SEV-81 | ban | SEV-05 kabul | Kalp yoktur |
| SEV-82 | ban | SEV-05 kabul | Romans yoktur |
| SEV-83 | ban | SEV-04 kabul | Hediye takvimi yoktur |
| SEV-84 | ban | SEV-02 kabul | Seslendirme yoktur |
| SEV-85 | ban | SEV-01 kabul | İkinci harita yoktur |
| SEV-86 | ban | SYS-20 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Yeni son yoktur |
| TEZ-11 | dup | TEZ-01 | Dört tezgâh durur |
| TEZ-13 | dup | UZM-08 | Tezgâh çocuğa açılmaz |
| TEZ-16 | ban | ARY-02 kabul | Yer temadadır |
| TEZ-17 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Yer metni anahtardır |
| TEZ-19 | dup | TEZ-02 | Siparişin yüzü bir kişidir |
| TEZ-22 | dup | SEV-06 | Yüz adı maske kuralındadır |
| TEZ-23 | dup | TEZ-10 | Yüzsüz sipariş sayımı çökertmez |
| TEZ-24 | dup | TEZ-09 | Yüz günde bir cümle |
| TEZ-25 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Yüz metni anahtardır |
| TEZ-26 | ban | TEZ-02 kabul | Yüz sesi yoktur |
| TEZ-28 | dup | TEZ-07 | Sabah usta yoksa çırak |
| TEZ-29 | dup | UZM-04 | Çırak çocuk yaşındaysa sabah durur |
| TEZ-30 | dup | TEZ-08 | Teslim beşinci usta sabahıdır |
| TEZ-33 | dup | EKO-04 | Un deltası sıfırdır |
| TEZ-35 | dup | TEZ-09 | Tam cümle bir anahtardır |
| TEZ-36 | dup | YAZ-10 | Cümle üsluptan geçer |
| TEZ-42 | ban | TEZ-09 kabul | Cümle sesi yoktur |
| TEZ-50 | ban | ARY-02 kabul | Sayım temadadır |
| TEZ-53 | dup | TEZ-04 | İz sabahı kaynak istemez |
| TEZ-62 | dup | EKO-01 | Ücret çift kasadadır |
| TEZ-63 | dup | SEV-07 | Yüz ölürse teslim ambara |
| TEZ-64 | dup | DIY-14 | Teslim sözü hatırlanır |
| TEZ-66 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Teslim metni anahtardır |
| TEZ-71 | dup | GIR-06 | Odak kopuk değildir |
| TEZ-75 | ban | TEZ-01 kabul | Yasak sahne yoktur |
| TEZ-77 | ban | TEZ-09 kabul | Wav yoktur |
| TEZ-78 | ban | TEZ-02 kabul | Kalp yoktur |
| TEZ-79 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| TEZ-80 | dup | TEK-12 | Baseline güncellenir |
| TEZ-81 | dup | SRM-05 | Debug sipariş oyuncuda yoktur |
| TEZ-83 | dup | MCL-09 | Meclis teslim etmez |
| TEZ-85 | dup | KOP-05 | Gazete sipariş basmaz |
| YAP-07 | dup | YAP-01 | Kademe baştan açık değildir |
| YAP-13 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Kademe metni anahtardır |
| YAP-21 | ban | YAP-02 kabul | Bilgi takası akçe istemez |
| YAP-22 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Bilgi metni anahtardır |
| YAP-23 | dup | YAP-03 | Usta kapıdan gelir |
| YAP-30 | dup | ACL-02 | Usta eşi listesinde yoktur |
| YAP-31 | dup | YAP-04 | Usta defteri ganimettir |
| YAP-39 | dup | YAP-05 | Çözümleme iş günü ister |
| YAP-57 | dup | GIR-06 | Kur düğmesi kapalıyken odaklanmaz |
| YAP-71 | ban | YAP-01 kabul | Yasak sahne yoktur |
| YAP-73 | ban | YAP-04 kabul | Ses yoktur |
| YAP-74 | ban | YAP-03 kabul | Kalp yoktur |
| YAP-75 | ban | YAP-01 kabul | İkinci harita yoktur |
| YAP-76 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| YAP-77 | dup | TEK-12 | Baseline güncellenir |
| YAP-80 | ban | SRM-05 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Bilgi düğmesi debug'da enjekte edilir |
| YAP-81 | dup | MCL-09 | Meclis kademe açamaz |
| YAP-84 | dup | KOP-05 | Gazete yapı ilanı basmaz |
| YAZ-27 | dup | YAZ-03 | Ses kartı olmayan adlı dosya girmez |
| YAZ-28 | dup | DIY-01a | Kart sır alanını zorunlu tutmaz |
| YAZ-29 | ban | YAZ-03 kabul | Kart kalp alanı taşımaz |
| YAZ-42 | dup | KLT-18 | Üretim günlüğü tur raporuna bir satırdır |
| YAZ-50 | dup | YAZ-06 | Pilot onayından önce toplu yazım yok |
| YAZ-56 | dup | DNY-02 | Aynı olayı iki ağız aynı cümleyle anlatamaz |
| YAZ-57 | dup | KLT-07 | Ölü ad toplu dosyada koşulsuz geçemez |
| YAZ-60 | dup | DYL-16 | Önizleme fixtures ile aynı düğümü seçer |
| YAZ-69 | dup | SOY-27 | Dedikodu çekirdeği yüzde yirmidir |
| YAZ-82 | dup | TST-0002 | Eksik anahtar kilidi KLT-10'dur |
| YAZ-85 | ban | YAZ-09 kabul | Kalp ve hediye alanı reddedilir |
| YAZ-86 | ban | YAZ-08 kabul | Köy sahnesi import edilmez |
| YAZ-88 | ban | TEK-12 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | API baseline içerik ekleyince güncellenir |
| YIL-16 | dup | MEV-01 | Seçim yıl açılışında bir kez |
| YIL-18 | ban | SYS-09 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Seçim metni anahtardır |
| YIL-20 | dup | YIL-03 | Şenlik yoksa harman cümlesi |
| YIL-21 | dup | SEV-07 | Güz kişisi ölüyse slot boş |
| YIL-26 | ban | YIL-02 kabul | Güz sesi yoktur |
| YIL-28 | dup | YIL-05 | Kış tarlası susar |
| YIL-35 | dup | YIL-06 | İlkbahar tarlasına döner |
| YIL-36 | dup | YIL-07 | Taşkın bir cümledir |
| YIL-42 | ban | YIL-06 kabul | İlkbahar sesi yoktur |
| YIL-43 | dup | YIL-08 | Yaz su sırasında söz |
| YIL-49 | ban | YIL-08 kabul | Yaz sesi yoktur |
| YIL-51 | dup | YIL-09 | Söylenen ad karttaki addır |
| YIL-53 | dup | YIL-10 | Kapanış dördüncü mevsimin yedinci günüdür |
| YIL-55 | dup | SYS-20 | Rapor son kimliği yazmaz |
| YIL-59 | dup | MEV-01 | Mevsim günü 7'dir |
| YIL-63 | dup | SEV-01 | Boş gün slot sayısına girmez |
| YIL-65 | dup | MCL-09 | Meclis yıl seçmez |
| YIL-68 | ban | ARY-02 kabul | Cümle temadadır |
| YIL-70 | dup | GIR-06 | Odak kapatmadadır |
| YIL-74 | dup | SOY-31 | Baloncuk yoktur |
| YIL-78 | dup | SRM-05 | Debug yüz oyuncuda yoktur |
| YIL-79 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| YIL-80 | dup | TEK-12 | Baseline güncellenir |
| YIL-82 | ban | YIL-10 kabul | Kalp anahtarı dosyada 0 |
| YIL-83 | ban | YIL-01 kabul | Yasak sahne yoktur |
| YIL-84 | dup | MEV-01 | İkinci takvim yoktur |
| YIL-85 | ban | YIL-02 kabul | Wav yoktur |
| YIL-86 | ban | SYS-20 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Yeni son yoktur |
| YIL-87 | ban | YIL-01 kabul | Hediye yoktur |
| YIL-88 | ban | YIL-01 kabul | Romans yoktur |
| YIL-89 | ban | YIL-01 kabul | İkinci harita yoktur |
| YSM-09 | dup | UZM-08 | Çocuk iş yorgunluğu yazmaz |
| YSM-11 | dup | KRI-05 | Ölüde değer donar |
| YSM-20 | dup | YSM-03 | Gece uykusu evdedir |
| YSM-21 | dup | ACL-05 | Yatak yoksa uyku yarım kalır |
| YSM-25 | dup | MEV-15 | Uyku fırtınada ev ister |
| YSM-33 | dup | HAN-04 | Sofra haftalık bir gıdadır |
| YSM-43 | dup | SOY-31 | Baloncuk çizilmez |
| YSM-48 | dup | SRM-05 | Debug değer oyuncuda yoktur |
| YSM-49 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |
| YSM-50 | dup | TEK-12 | Baseline güncellenir |
| YSM-61 | dup | NBT-02 | Bitkin kapıya nöbetçi olmaz |
| YSM-64 | dup | SOY-12 | Meclis açlığı ancak kamuoyuysa alır |
| YSM-65 | dup | ACL-03 | Eş açlığı akşam sohbetine girer |
| YSM-68 | ban | YSM-01 kabul | Yasak sahne yoktur |
| YSM-70 | ban | YSM-01 kabul | Kalp yoktur |
| YSM-71 | ban | YSM-03 kabul | Ses yoktur |
| YSM-72 | ban | YSM-01 kabul | İkinci harita yoktur |
| YSM-73 | ban | YSM-01 kabul | Hediye ile moral dolmaz |
| YSM-75 | dup | SRM-05 | Debug panel oyuncuda yoktur |
| YSM-78 | dup | KOP-05 | Gazete açlık ilanı basmaz |
| YSM-81 | dup | MCL-09 | Meclis doyuramaz |
| ZAR-14 | ban | ZAR-01 kabul | Zar sesi üretilmez |
| ZAR-23 | dup | ZAR-03 | Tansiyon 10'da karakter gider |
| ZAR-35 | dup | KOP-06 | Yozlaşma değiştiricisi ODA skorudur |
| ZAR-41 | dup | DIY-11 | Kırmızı bayrak kişi hafızasındadır |
| ZAR-47 | dup | ZAR-06 | Sezgi zar atmaz |
| ZAR-68 | ban | SRM-05 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Hileli zar debug'dadır |
| ZAR-78 | dup | DEN-06 | Ölçüm oyuncu HUD'unda yoktur |
| ZAR-81 | ban | ZAR-01 kabul | Yasak sahne yoktur |
| ZAR-82 | ban | ZAR-01 kabul | Seslendirme yoktur |
| ZAR-83 | ban | ZAR-04 kabul | Kalp ve romans eşiği yoktur |
| ZAR-84 | dup | TEK-12 | API değişince baseline güncellenir |
| ZAR-85 | ban | KAY-04 (hedef dosyası 32–46 arasındaysa metin eklenmedi) | Göç bir adımdır |

### Kalıp temizliği (aynı tabloya ek)

"Oyuncu bunu … bir kez görür" ve "Ölçü dosyadaki kabulün sayısıdır" kalıpları silindi. Aşağıdakiler test ya da tekrar olduğu için kalktı.

| KLT-36 | sil | KLT-07 | Ayrılan kişi koşulsuz anılmaz |
| KLT-38 | sil | BUG-16 | Bina adı liste dışındaysa hata |
| KLT-41 | sil | KLT-10 | Eksik anahtar listesi tektir |
| KLT-42 | sil | KLT-11 | Çift boşluk sohbet önekine de bakar |
| KLT-49 | sil | KLT-02 | İki isimden biri boşsa red |
| KLT-51 | sil | DYL-16 | Fixtures farkı sıfırdır |
| KLT-52 | sil | KLT-17 | Site editörü `src` altında değildir |
| KLT-56 | sil | KLT-18 | Tur satırı `soz_kapi` özetidir |
| KLT-58 | sil | KLT-19 | Ses turu açılmaz |
| KLT-61 | sil | KLT-20 | Sır kotası yüzde yüzü reddeder |
| KLT-62 | sil | SOY-27 | Dedikodu kotası yüzde yirmidir |
| KLT-63 | sil | KLT-21 | Hitap puanı alanı açılmaz |
| KLT-66 | sil | KLT-22 | Kitap export'a girmez |
| KLT-67 | sil | KLT-23 | HTTP dizesi söz araçlarında yoktur |
| KLT-70 | sil | ADM-16 | Çalışma anı istisnası yalnız köprüdür |
| KLT-71 | sil | KLT-24 | DYL-11…16 durur |
| KLT-74 | sil | TEK-12 | Baseline şema artınca güncellenir |
| KLT-75 | sil | KLT-25 | Kapanış beş fixtures reddeder |
