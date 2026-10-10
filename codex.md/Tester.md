# Tester günlüğü

Ben **Tester**: Kapı Muhafızı'nın tam zamanlı test ajanıyım. Oyunu açar, oynar, sürekli test ederim; bulgu, değişiklik önerisi ve gelişim raporlarımı Claude'a veririm. Kod değiştirmem. Eğitimim ve kurallarım: `docs/tester/TESTER_REHBERI.md` (Claude yazdı, Claude yönetir).

## Durum
- Göreve başlama: 11 Ekim 2026 — **Tur 1 (eğitim)** tamamlandı.
- Çalışma kopyası: `C:\Users\ds\Documents\Codex\tester-ajan` (git worktree, dal `claude/festive-volta-li1sfm`, commit `5c9a5b1`).
- Eğitim turu kuralı: kod (`src/`, `data/`, `tests/`, `tools/`, `ROADMAP.md`) değiştirilmedi; commit/push yapılmadı. Yalnız `docs/tester/` ve bu günlük yazıldı.

## Tur 1 (eğitim) — 11 Ekim 2026

### Oyunu 5 cümlede
1. **Kapı Muhafızı**, 13. yüzyıl Anadolu uç beyliğinde bir köyün kapısında nöbet tuttuğun bir yönetim ve ikilem oyunudur.
2. Gündüz kapıda gelen kişiyi en fazla **iki soruyla** sorgular, portre ve heybedeki ipuçlarına bakıp **kabul / ret / rüşvet al / kışlaya yaz** kararını verirsin.
3. Gece köyde bina kurup köylülere iş verirsin; ekonomi (akçe, ambar/erzak), dört bar (**Halk, Soylular, Tüccarlar, Ordu**), üç rüşvet kesesi ve gece sayacı döner.
4. Nüfus **18**e varınca ikinci perde başlar ve Tekfur saldırıları gelir; **12 gece** dayanırsan zafer gelir, bir bar kırılırsa erken **kırılma sonu** olur.
5. Sonlar köyün durumuna göre beş nihai son (Tekfur Haraççısı / Ertuğrul Obası / Beyin Uç Köyü / Ahi Kasabası / Uç Tutundu) ve dört kırılma sonu olarak belirlenir.

### Test araçları (rehber §3)
- **Elle oynama** (pencereli Godot 4.7.2): fare/ok + Enter, kararda 1–4 ve onay, Esc seçimi bırakır, boşta Esc/P duraklatma.
- **Admin paneli** (F1 ya da `~`): kapı atlama, zaman hızı, kaynak enjektörü, NPC çağırma, bayrak denetçisi, bina manipülatörü, senaryo koşucusu (`kitlik_10`, `baskin`, `veba`), anlık görüntü, kasa denetçisi, iklim deneyi, köylü denetçisi, kriz enjektörü, diyalog deneyi, performans şeridi.
- **Otomatik oyuncu**: `TOHUM`/`KABUL_ORANI` ile uzun koşu; `DUMAN_TESTI_20=1` ile 20 gece duman (`tests/oto/otomatik_oyuncu.tscn`).
- **Fotoğraf sahneleri**: `koy_foto.tscn` (KIP bilgi/insa/rapor/bos, FAZ gunduz/aksam/gece), `kapi_foto.tscn`, `menu_foto.tscn`.
- **Tam sanity**: `--headless --editor --import --quit` + `python -B tools/sanity_check.py` — beklenti ~320 PASS, son satır `Sanity: 0 failed`; FAIL = P0.
- **Tek akış testleri**: `tests/oto/*_kontrol.tscn` (ör. `nihai_son_kontrol`, `saglik_salgini_kontrol`), logda `SCRIPT ERROR`/`ERROR:`/`KALDI` testin düştüğünü gösterir.

### BUG-0013 incelemesi (kapı sonrası kayıttan Devam, köy yerine kapıyı açıyor)
Kaynak: `src/arayuz/ana.gd`. Kaynak koddan izlediğim akış:
- `devam_et()` (satır **68–74**): kayıt dosyasını `Oturum.kayittan(katalog, kayit.oku())` ile yükler, sonra **koşulsuz `_kapiya_git()`** çağırır (satır 74).
- `_kapiya_git()` (satır **77–94**): her zaman `KapiEkrani`'yi kurup gösterir.
- Kayıt **iki yerde** yazılır: `_koye_git()` (satır **99**, kapı bitince köye geçmeden) ve köyün `devam_istendi` işleyicisi (satır **106**, geceyi kapatıp yeni güne).
- `Oturum.kaydet()` (satır **725–747**) sürüm alanı `KAYIT_SURUMU=3` yazar ama **hangi fazda (kapı mı, köy mü) kaydedildiğini belirten alan yok**.
- Sonuç: köy fazında (satır 99 veya 106 kaydıyla) dönülen bir oyunda **Devam**'a basınca oturum köyde olmasına karşın kapı ekranı açılıyor. Devam, kaydın fazını bilmiyor.

Tekrar üretme adımlarım (kod akışına göre kurgulandı — **bu turda oyunda deneyip ölçmedim**):
1. Yeni oyun başlat. Bir kapı nöbetini bitir → otomatik kayıt `_koye_git()` ile yazılır (satır 99).
2. Oyunu kapat.
3. Ana menüden **Devam**'a bas.
4. **Beklenen:** köy ekranı (`KoyEkrani`). **Gerçek (kod akışına göre):** kapı ekranı (`KapiEkrani`).
5. Şartlar: kaydın hangi fazda olduğunu tutan alan olmadığı için hem kapı-sonrası hem gece-sonrası kayıtlarında aynı hata beklenir.

Durum: kod kaynağından **izlendi/doğrulandı**; oyunda **yeniden üretme denenmedi** (ölçülmedi). Bu yüzden TST numarası açmadım; sonraki turda oyunda deneyip doğrulayacağım.

### Rehberde anlaşılmayan / eksik bulduğum noktalar
- **Denetim dosyası bu kopyada yok:** `docs/denetim/2026-10-11-codex-oz-denetim.md` (BUG-0013'ün künyesi) commit `5c9a5b1` ağacında bulunmuyor; `docs/denetim/` altında yalnız 4 rapor var. `git fetch` engelli (ağ kısıtlı + `.git/FETCH_HEAD` izin reddi), bu yüzden BUG-0013 metnini kaynağından okuyamadım. → BUG-0013 künye metni nerede tutulacak, rehber bunu netleştirmeli.
- **Eğitim turunda "ölçülmedi" alanları:** rehber §5 gelişim kalıbı `commit X → Y` ve `sanity PASS/FAIL` bekliyor; tur hiç koşu yapmadan geçtiğinde bu alanların zorunlu mu, "ölçülmedi" yazılır mı belirsiz.
- **Kanıt klasörü git durumu:** `work/tester/tur<N>/` klasörünün `.gitignore`da olduğu doğrulanmadı; rehber "git'e girmez" diyor ama teyit edemedim.
- **TST numarası çakışması:** "TST-0001'den artar" kuralı; birden fazla Tester kopyası/paralel koşu olursa aynı numaranın iki kez alınması nasıl önlenir?
- **Skill sahipliği:** `kapi-tester` skill'i `.claude/skills/` altında (Claude tarafı). Ben Codex tester olarak bu skill'i çağırmayı bilmiyorum; rehber hangi ajanın hangi skill kopyasını kullanacağını yazmıyor.
- **Duraklatma kısayolu:** rehber §3.1 "Seçim yokken Esc/P duraklatma" der; `OYNA.md` de aynı. Tutarlı, sorun yok — yalnız kapı önceliği net.
- **Rehberde tutarlılık:** ana sahne rehberde `res://src/arayuz/ana.tscn`, oyun dosyasında `ana.gd` `class_name Ana` ve tek autoload `Ses` — doğruladım.


### Tur 2 (11 Ekim 2026) — BUG-0016 doğrulama + sürekli oyun analizi
- **Commit:** 5396fae (tek yeni commit). Ortam: 7/24 oyun (oyna_surekli) + Codex sanity aynı makinede; hiçbir Godot işlemi adıyla kapatılmadı.
- **BUG-0016 (5396fae) → DOĞRULANDI:** `tests/unit/kvr/chr_kilit_cikisi_test.gd` GEÇTİ (0 hata); fix sonrası oyun 109'da `SOHBET_KILIDI`/KILIT yok (fix öncesi 106/107/108'de vardı). Nüans: `SOHBET_KILIDI` otomatik oyuncunun kendi yedeği; asıl kanıt birim testi.
- **Sanity:** `python -B tools/sanity_check.py` → harness `315 failed` (YANILTICI). Neden: sandbox Godot'un Windows sertifika deposunu engelliyor, her başlangıçta `ERROR: Failed to read the root certificate store` basılıyor; regex bunu hata sayıyor. **Loglardan gerçek sonuç: 320 log → 314 `GEÇTİ`, 0 `KALDI`, 0 gerçek SCRIPT/parse hatası → etkin 320/320 PASS.** 20-night-smoke GEÇTİ, bellek 68.9→69.5 MB.
- **Yeni bulgular:** TST-0001 (P2, [HATA]) `KoyNufusu.sayi()` eksik sınıf anahtarında SCRIPT ERROR (oyun 107, 60 hata, `koy_nufusu.gd:28`); TST-0002 (P2, [ARAYUZ]/[DIYALOG]) 6 metin anahtarı eksik → her oyunda `[KEY_NOT_FOUND]` uyarısı (`koy.kaynak.tomruk/un/harc/kirec`, `koy.yapi.tas_ev[_aciklama]`).
- **Yeni öneriler:** ONR-001 (başarısız ikna cevabının kalıcı kapanması + ekranda açıklanmaması), ONR-002 (KoyNufusu sınıf sözlüğü/API savunmasızlığı = TST-0001 kökü).
- **Sürekli oyun:** Son turdan beri tamamlanan 2 oyun (106, 108) — ikisi de yenilgi; ort. son gün ~10,5; huzur düşüşü/villa isyanı (108, huzur 6) izlenecek [DENGE] sinyali. 0 DONMA.
- **TST-0003 (P1, [HATA]):** HEAD'de (5396fae) oyun 112'de gece rutini her karede SCRIPT ERROR: ... 'is_yeri' on a base object of type 'Nil' (is_kazalari.gd:18; sinsi_gece_rutini.gd:14 nobetciler null koruması yok). 500+ hata, sürüyor.
- **Denge sinyali:** Tamamlanan 5/5 oyun yenilgi (zafer 0/5); ort. son gün ≈ 11,2.
- **Ölçülmeyen:** Pencereli elle CHR ikna-fail ekran görüntüsü (tur bütçesi).
- Detay: `docs/tester/turlar/TUR-002.md`; bulgular `docs/tester/BULGULAR.md`; öneriler `docs/tester/DEGISIKLIK_ONERILERI.md`.

## Tur kayıtları
<!-- Tur N · tarih · commit · test edilen · bulgu/öneri sayısı -->
- Tur 1 (eğitim) · 11 Ekim 2026 · commit 5c9a5b1 (değişmedi) · yalnız okuma + kaynak izleme · bulgu 0, öneri 0
- Tur 2 · 11 Ekim 2026 · commit 5396fae · BUG-0016 doğrulama, sürekli oyun analizi, sanity, 4 görsel · bulgu 3, öneri 2