# Cursor — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Cursor — Muharrir’in verdiği doğrulama ve ince adaptör işi. İmza `(Cursor)`. Günlük bu dosyadır. Repo: `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`. Dal: `claude/festive-volta-li1sfm`.

## Bölüm 39 — 3 Kasım 2026

HFZ-01…21, HFZ-23…29 ve HFZ-32. Tek hafıza defteri, dört sayfa: karar, beyan, söylenti, not. Kaynak sistemlere yazılmaz; diyalog cümlesi yazılmadı, oyuncu metni yer tutucu anahtardır. Köy düğmesi ve duraklat dördüncü satırı açar; kapı sorgu defterine çağrı yok. HFZ-22, HFZ-30, HFZ-31 Claude'da duruyor. Asset gerekmedi. Godot 4.7.2 headless `tests/unit/sistemler/hafiza_defteri_test.gd` GEÇTİ, 0 hata. Tam sanity çalıştırılmadı. Kota görünmüyor. Ahmet'in yerel kopyası bu makinede yok; eşitlendi denmez.

## VFX — 24 Ekim 2026

Duman, alev, yağmur çizgisi, yumuşak ışık ve bir ateş topu. Şimşek, büyü, kan ve namlu yok. Kar ve ayrı kıvılcım yok. Sahneye bağlanmadı. Headless 5 PNG, `SONUC 0`, `SCRIPT ERROR` yok. Tam sanity yok. Kota görünmüyor.

## Ses — 24 Ekim 2026

Kapı, adım, sikke, dere, tahta tık, kılıç, yay, örs, boru ve üç hece. Elektronik arayüz, büyü, et darbesi ve İngilizce konuşma yok. S02 FLAC alınmadı. Ses autoload'una bağlanmadı. Headless `SONUC 0`, `SCRIPT ERROR` yok. Tam sanity yok. VFX yok. Kota görünmüyor.

## Hayvan — 24 Ekim 2026

HYV03 koyun ve inek, HYV02 köpek. Zürafa, corgi ve egzotik türler yok. HYV08 repoya alınmadı. Ölçü yakın, bağlanmadı. Headless `SONUC 0`, `SCRIPT ERROR` yok. Tam sanity yok. Ses ve VFX yok. Kota görünmüyor.

## Eşya — 24 Ekim 2026

ESY01, ESY02, ESY03, ESY04 ücretsiz KayKit glTF. Alet, kılıç, mızrak, yay, kalkan, yatak, masa, bir odun, bir demir çubuk. Modern, fantastik ve satırsız parçalar yok. Ölçü büyük, bağlanmadı. Yay uzun ekseni X. Headless `SONUC 0`, `SCRIPT ERROR` yok. Tam sanity yok. KAR05, C07, C10 yeniden denenmedi. Hayvan, ses ve VFX yok. Kota görünmüyor.

## Karakter — 24 Ekim 2026

KAR02 ücretsiz: demirci 1,80 m ve çocuk 1,27 m glTF, T-pozu, bağlanmadı. Avcı ihtiyaç satırı yok. KAR05, C07, C10 imzalı indirme engellendi, atlandı. Tam sanity yok. Kota görünmüyor. Commit `0daf072`.

## Test kuralı — 24 Ekim 2026 (Ahmet)

- Her pakette yalnız eklenen dosyalar için headless import/parse. `SCRIPT ERROR` ve import hatası yok.
- Godot MCP ile eklenen parçanın sahnesinde görsel kontrol.
- Birkaç paket grubunda bir ve iş bitince, yalnız dokunulan bölümün hedefli testleri. Köye asset eklendiyse köy ile ilgili `tests/unit`. İlgisiz bölüm test edilmez.
- Hata çıkarsa yalnız o bölümde düzelt.
- Tam sanity yalnız Ahmet isterse en sonda bir kez. `tools/sanity_check.py` bu görev boyunca çalıştırılmaz. `work/sanity-cursor-cevre` yarım logu commit edilmez.

## Çevre — 24 Ekim 2026

Yapı ailesi E02 MegaKit Standard. KayKit hex ve LOKIT yapıları yok. Ölçü: KayKit ev 0,93 m, MegaKit cephe yaklaşık 5,9 m, LOKIT duvar 4,0 m. Mevcut ev ve kapı modelleri duruyor. İHT-0339 açık. Headless: 7 glTF, her birinde mesh 1, SCRIPT ERROR yok. Görsel: E02 etiketleri ve zemin göründü; modül gövdeleri bu karede zeminden ayrışmadı. Tam sanity çalıştırılmadı. Commit `8c1df71`, festive'ye push edildi. Sıradaki grup karakter: KAR02, KAR05, C07, C10; henüz başlanmadı.

## Animasyon — 24 Ekim 2026

Ana kaynak A01 Quaternius UAL Standard. A02 aynı aile, tarım ve kılıç. KayKit A03 duruyor, bağlanmadı. chr_001 Idle görüntüsü: KayKit omuz silkiyor, UAL kolları indiriyor. Tam kabul yok. Butler `C:\Users\Ahmet\bin\butler.exe` v15.32.0. Kota görünmüyor. Çevre seçimi sıradaki.

## Kurulum turu — 24 Ekim 2026

Bu tur yalnız kurulum ve doğrulama. Asset indirilmedi. Oyun kodu değişmedi. Commit yok; bu günlük ilk iş commit’iyle birlikte gidecek. Kota görünmüyor.

### Tamam
- Kurallar okundu: `AGENTS.md`, `codex.md/SOUL.md`, `ROADMAP.md` / `ROADMAP_2.md` işaretleme panosu, `docs/EKSIK_ASSET_ENVANTERI.md`, `docs/asset_envanteri/IHTIYAC_ANA_LISTESI.md`, `docs/asset_envanteri/UCRETSIZ_ASSET_EKLEME_2026-10-24.md`, `docs/credits/HAZIR_ASSET_ATIFLARI.md`.
- Dal `claude/festive-volta-li1sfm`. `git pull` ve `git lfs pull` güncel. HEAD `63a8b92`. Git LFS 3.7.1. Stash, reset, checkout, restore yok.
- `uvx.exe` Winget yolunda yoktu. Gerçek yol: `C:\Users\Ahmet\AppData\Local\Programs\Python\Python312\Scripts\uvx.exe` (uv 0.11.33). `C:\Users\Ahmet\.cursor\mcp.json` içinde yalnız bu yol düzeltildi. Diğer sunuculara ve anahtarlara dokunulmadı.
- Godot AI eklentisi 3.2.4, resmî `godot-ai-plugin.zip` (SHA-256 `8275d98c66b9932feee2a2a5118768e6699a5827ca798fe6032978845ae16321`, yayın dosyasıyla aynı). `addons/godot_ai/` yerelde. `.git/info/exclude` satırı: `addons/godot_ai/`. Commit edilmedi.
- Eklenti Project Settings karşılığı olarak yerelde açık: `editor_plugins` ve autoload `_mcp_game_helper`. Bu `project.godot` farkı commit edilmeyecek. Başkasının `run/main_scene` satır kaydırması duruyor.
- Godot `C:\Users\Ahmet\Desktop\Godot.exe` bu projeyle açık (PID 22744).
- MCP `user-godot-ai` bağlandı. Oturum `kap-muhafizi@e47f`, proje bu klasör, eklenti ve sunucu 3.2.4, hazır. Sahne ağacı okundu: `res://tests/oto/acilis_bagimlilik_kontrol.tscn` tek düğüm `AcilisDenetimi` (Node). Ardından `res://src/arayuz/ana.tscn` açıldı (`switched: true`). Sahne kaydedilmedi.
- Godot headless: `4.7.2.stable.official.ed1daf0bf`.
- Python 3.12.10. `tests/tools` standart kütüphane ve `unittest` kullanıyor; pytest, numpy, requests, PIL yok. Yeni paket kurulmadı.
- Kısa kuru çalıştırma: `python -B tools/chr_parser.py --check` → 30 sayfa, çıkış 0. `python -B tools/acilis_denetimi.py --filesystem` → `Startup source audit: PASS`. `python -B tools/sanity_check.py -h` yardım basar, test koşmaz.

### Eksik
- Blender kurulu değil: PATH’te yok, HKLM/HKCU kaldırılan-program kaydında yok, `C:\Program Files\Blender Foundation` yok. Kurulmadı.
- `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper` ve `C:\Users\ds\Documents\GitHub\GameDevoloper` bu makinede yok. Eşitlendi denmez.
- Tam sanity bu turda çalıştırılmadı. Komut iş bitince: `python -B tools/sanity_check.py --godot C:\Users\Ahmet\Desktop\Godot.exe`. Log varsayılanı `work/sanity`. İçinde CHR, CSV, denge, Python testleri, `tools/acilis_denetimi.py --filesystem`, API sözleşmesi, headless import, `tests/unit/**/*test.gd`, `tests/oto/*.tscn` ve `tests/oto/otomatik_oyuncu.tscn` (20 gece) var. Birim örneği: `Godot.exe --headless --path <proje> -s tests/unit/<test>.gd`.

### Dokunulmayanlar
Başkasının değişmiş dosyaları duruyor: altı `.glb.import`, `project.godot` içindeki eski satır kaydırması, `_tmp_*`, `_doc_*`, `*_CLAUDE.md`, `work/` ve diğer izlenmeyen kopyalar. Silinmedi, commit edilmedi. Editör açılınca yeni izlenmeyen `.uid` dosyaları oluştu (`src/kapi/`, `src/sistemler/denge_olcumu.gd.uid`, `tests/unit/denge/`, `tests/unit/kapi/`). Onlar da commit edilmedi.

### İndirme erişimi
Beş adres `curl -I` ile HTTP 200: itch.io, kenney.nl, opengameart.org, quaternius.com, ambientcg.com. Bu turda oyun dosyası indirilmedi.

itch.io: sayfa açık. Resmî araç butler. Kurulum: https://itch.io/docs/butler/installing — Windows için https://itchio.itch.io/butler veya kalıcı `https://broth.itch.zone/butler/windows-amd64/LATEST/archive/default`. Sayfadaki indirme bağlantıları süresi dolan adreslerdir. `butler dl <url> <hedef>` verilen adresi indirir, kaldığı yerden sürer ve boyutu doğrular (https://docs.itch.zone/butler/master/utilities.html). Ücretsiz paket için sayfadaki güncel dosya adresini o anda almak gerekir. Hesap isteyen 0 USD “claim” bu turda denenmedi.

### Sonraki plan
İlk gerçek iş gelince bu günlüğü o commit’e koymak. ROADMAP maddesi bu turda alınmadı. Ajan Masası’nın son yorumları Kalfa → Muharrir; Cursor’a yazı yok, cevap yazılmadı.

## Önceki kayıt

Cursor — Godot doğrulama ve ince adaptör. Bu turda KAP-02, KAP-03, BUG-11 ve TUC-11/14 notu.

## Şu an üzerinde çalışılan
Bölüm 31 boş kayıt maddeleri `[/] (Cursor)`. Kod dalı `cursor/gece-31-dogrulama`. Kalfa'nın ekonomi/köy maddelerine ve Antigravity'nin diyalog metnine dokunulmadı. Doğrulayıcı yalnız araç. Asset gerekmedi. kota görünmüyor.

Bölüm 35 boş AYR maddeleri sahiplendi: AYR-01, 03, 04, 07–21, 23–27, 30, 34–42, 45, 47, 48, 50, 52. İşaret `[/] (Cursor)`. Kod `cursor/gece-35-ayarlar` dalında. Kalfa ekonomi/köy ve Antigravity diyalog alanına dokunulmadı. Kota görünmüyor.

KAP-02 ve KAP-03 `[x] (Cursor)`. BUG-11 eski notu düzeltildi. TUC-11/14 notları duruyor. MEV-01 satırına yazılmadı. Yeni dosya ve ikinci sistem yok. TUC/MEV/CAS kaynak dosyalarına dokunulmadı.

## Bölüm 35 sahiplenme — 3 Kasım 2026
38 boş madde `[/] (Cursor)` yapıldı. `[x]` olan AYR maddelerine ve başka ajanın `[/]` satırına yazılmadı. Asset bu sahiplenmede gerekmedi.

## Sonraki plan
Festive PR. Yeni özellik yok. ODA-01 açılınca TUC-11 tekrar yazılmaz.

## Güncel durum
- Dal: `cursor/roadmap-gap-verify-0b16`, taban festive `6da34ad` (CAS-07..12 alındı). Kilit `29a71c6`. CAS-13 Codex'te `[/]`; dokunulmadı.
- Test: Godot 4.7.2 `ed1daf0bf`. İlk import 104 `ERROR:`, 0 `SCRIPT ERROR`. `f3ef5c4` tam sanity 230 `PASS`, 0 başarısız (`metin-csv` ve 20 gece dahil). `6da34ad` sonrası import 0 hata; `divan_kanit_sozlesme`, `zehir_clue_sozlesmesi`, `divan_kanit`, `kuyu_zehirleme` birimleri ve kuyu UI geçti. `metin-csv` geçti.
- KAP-02 `[x] (Cursor)`: `tansiyon_yoneticisi.gd` yok. Aralık ve `tansiyon_delta` `ChrSorgusu` içinde; gösterge KAP-12. KAP-11 `ipucu_yoneticisi.gd` duruyor.
- KAP-03 `[x] (Cursor)`: panel `src/arayuz/heybe_paneli.gd`. Kart açılışta 0.3→1. İpucu kartı KAP-14. BUG-15 testi `tests/unit/heybe/heybe_tik_test.gd`.
- MEV-01 festive `59cbcc5` üzerinde zaten `[x] (Codex)`. Satır geri alındı; üzerine yazılmadı. MEV/TUC/CAS kaynak dosyalarına dokunulmadı.
- BUG-11 notu: "BUG-08 hâlâ açık" silindi. BUG-08 kapalı.
- TUC-14 notu: TUC-02 alış bitti; TUC-14 aynı `lojistik.hayvanlar` kaydının geri satışı ve çarpanı. İkinci sürü yok.
- TUC-11 notu: kaçak mal pazar kartı envanteri. 3B oda ODA-01 `[ ]`; bağımlılık yazıldı.
- Asset gerekmedi. `C:\Users\ds\Documents\GitHub\GameDevoloper` ve Ahmet `Kapı_Muhafizi` bu ortamda yok; eşitlendi denmez.
- Önceki BUG-15 dalı `cursor/bug-15-heybe-click-3e1a` → PR #8, taban `ec23ee9` tarihsel kayıttır.
- `src/arayuz/heybe_paneli.gd` satır 34: `mouse_filter = Control.MOUSE_FILTER_STOP`. İlk çocuk `ColorRect` de varsayılan STOP. Üretim koduna satır eklenmedi.
- Kanıt: `tests/unit/heybe/heybe_tik_test.gd` (Godot 4.7.2 headless). Tık `(400, 400)`, panel dikdörtgeni kapıdaki `_dunya` ile aynı `(0, 92, 1140×988)`.
  - Açıkken imleç heybe çocuğunda, dünya `gui_input` 0, 3B `SubViewport` sondası 0.
  - Panel kapanınca aynı nokta `DunyaAlani` kontrolüne ve 3B görüntü kapısına gider (sayaç 1).
- Kapı sahnesinin kendisi tıklamayı `TextureRect` (`MOUSE_FILTER_IGNORE`) üzerinden SubViewport'a iletmez. Test, Godot'nun gerçek 3B tık yolu olan `SubViewportContainer` ile de aynı örtüyü doğrular.
- Bu makinede `C:\Users\ds\Documents\GitHub\GameDevoloper` ve Ahmet'in `Kapı_Muhafizi` kopyası yok; eşitlendi veya fast-forward yapıldı denmez.

## BUG-07 paketi (8 Ekim 2026)

Durum: BUG-07, SYS-09, SYS-11, SYS-12, KVR-11 `[x] (Cursor)`. Başlarken ROADMAP'te `[/] üzerindeyim (Cursor)` kilidi `1e898fd` ile push edildi.
Yeni dosya + ince adaptör: `GuvenliMetin` (yeni), `ana.gd` 1 satır, `katalog.gd` 4 satır, `sanity_check.py` 1 satır. Asset gerekmedi. Tam sanity 0 başarısız.
