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
- Tur 3 · 11 Ekim 2026 · commit 34d36f7 (kod 254202d) · denge soruşturması, BÖLÜM 6 regresyon, sanity · bulgu 1, öneri 2
- Tur 4 · 11 Ekim 2026 · commit 0ac499c (kod 160ef54) · BUG-0018 doğrulama, 2. perde denge, karakter muayenesi (44 model), Türkçe dilim, BÖLÜM 7 regresyon · bulgu 1, öneri 3
## Tur 3 — 11 Ekim 2026 (commit 34d36f7 / kod 254202d)

### Durum
- **Ana odak:** ÖNCELİKLİ DENGE SORUSU (2. perde huzur çöküşü, zafer ulaşılabilirliği, erken ekonomi) + baştan sona oyunlar + rastgele regresyon.
- **Sağlık:** etkin sanity 320/320 PASS (harness 315 FAIL = ortam sertifika hatası). BÖLÜM 6: 9 kvr testi GEÇTİ.
- **Yeni bulgu:** TST-0004 (P1, [DENGE]) zafer sonu ulaşılamıyor. Doğrulanan: BUG-0016, TST-0003.
- **Yeni öneri:** ONR-003, ONR-004. Kod/test/data değiştirilmedi.

### Tur 3 özeti
- **Denge kök nedeni:** EKO-02 (`src/koy/odun_zinciri.gd`) `hizarhane`'yi "2 tomruk → 3 odun" yaptı; tomruk yalnız `odunluk`'tan gelir ama otomatik oyuncu ve `koy_benzetimi.gd` `odunluk` kurmuyor → **odun 1. günden sonra 0** → köy 5 yapıda donuyor → gıda 0 → `aclik_moral=15` ile huzur çöküşü → İsyan/Tekfur. 22/22 gözlem yenilgi, zafer 0.
- **Deneyler:** `work/tester/tur3/denge_ek.gd` (düzeltilmiş strateji — odunluk kur) ve `hizar_tani.gd` (hizarhane yerleşimi). Düzeltmede bile hizarhane yerleşemedi (2×2 + yol komşuluğu).
- **Koşular:** 201/202/203 (headless, kabul 0.95/0.5/0.1) + 301 (pencereli, --audio-driver Dummy). Hepsi İsyan/azil ile bitti.
- **Rastgele bölüm:** BÖLÜM 6 (tüccar/pazar/sipariş) — regresyon yok.
- **Kısıt:** Gerçek elle GUI oynaması yapılamadı; pencereli otomatik koşu + 1 ekran görüntüsü kullanıldı. TST-0002 `[KEY_NOT_FOUND]` ekranı netleşmedi.

### Sonraki tur planı
1. ONR-004 uygulanınca (otomatik oyuncu `odunluk`) zafer oranını yeniden ölç.
2. TST-0002'nin `[KEY_NOT_FOUND]` gösterdiği ekranı görüntüyle kesinleştir.
3. TST-0001 (KoyNufusu) tekrarını ara; pencereli elle CHR ikna-fail ekranı.
4. `koy_benzetimi.gd` zafer eşiğini test et.

## Tur 4 — 11 Ekim 2026 (commit 0ac499c / kod 160ef54)

### Durum
- **Ana odak:** (1) yeni commit `0ac499c` (BUG-0018 kaydı) doğrulaması, (2) ÖNCELİKLİ DENGE SORUSU devamı (2. perde savunma hazırlığı, ilk Tekfur gücü, huzur eğrisi, erken azil), (3) ilk **karakter muayenesi** (44 model, rehber §13.1), (4) Türkçe dilim (§13.3 ilk 150 satır), (5) BUG-0016/BUG-0017 sürdürme, (6) BÖLÜM 7 regresyon.
- **Yeni bulgu:** TST-0006 (P3, [DIYALOG]/metin). **Yeni öneri:** ONR-005, ONR-006, ONR-007.
- **Doğrulanan:** BUG-0018/TST-0004 (odun kilidi, kanıtla), BUG-0017/TST-0003, BUG-0016.
- **Kod/test/data değiştirilmedi.**

### Tur 4 özeti
- **DENGE yanıtları:** (a) 2. perde huzur eğrisi: gıda 1–3 gecede 0, huzur −10…−19/gece (110/112/114/116 örnekleri). (b) Zafer ulaşılamaz: 2. perde girişinde `sur=0 odun=0 yapı=5`, savunma ≈2–3; ilk akın gücü 4 (haraç `(gün+1)%6==0` → cevapsız ret → baski=1 → `2+2×1`), 106/113/117/123 g7'de düştü. (c) 6. gece azil = **Sancak teftişi** (ilk_gece=6, %50), ekonomi çöküşü değil (oyun 109: huzur 54 sağlıklı).
- **Karakter muayenesi:** `work/tester/muayene/` — 44 model, `muayene.json` + temas sayfaları; uyarı/açıklama Adım 5'te (TUR-004).
- **Türkçe dilim:** satır 2–150; 1 yeni bulgu (çift boşluk + yinelenen tekfur metni, TST-0006). Kaldığım satır: **150** (sonraki tur 151’den).
- **Sürekli oyun:** 24 oyun (101–123); sonlar Tekfur 9 · İsyan 5 · azil 3 · zafer 0; ortalama son gün ≈ 11,4; DONMA 0, KILIT 0 (fix sonrası), yeni HATA 0.
- Detay: `docs/tester/turlar/TUR-004.md`.