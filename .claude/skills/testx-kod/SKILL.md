---
name: testx-kod
description: "testx'in ROADMAP 2 kod görevi: gorev.md'deki maddeyi oku, yeni dosya + ince adaptörle uygula, Kabul iddialarını teste çevir, import + hedefli test + tam sanity koş, teslim.json yaz. Kullan: 'madde uygula', 'görev', 'kod yaz', 'DÜZELT'."
argument-hint: "[gorev | duzelt]"
user-invocable: true
---

# testx-kod

Önce `docs/tester/TESTX_KOD_REHBERI.md` dosyasını baştan sona oku. Bu skill o rehberin sıralı uygulamasıdır.

## Kipler

- **`gorev`** (varsayılan): `~/.codex-tester/gorev.md` dosyasındaki maddeyi uygula.
- **`duzelt`**: `gorev.md`'deki "DÜZELT:" notlarını uygula. Önceki teslimini bozmadan yalnız istenen yeri düzelt.

## Sıra

1. `gorev.md` dosyasını oku. Madde kimliğini `ROADMAP_2.md` içinde bul. Amaç, Kurallar, Uç durumlar, Kabul, Bağımlılık, Dosya ve Asset bölümlerinin hepsini oku.
2. Bağımlı maddeleri, `ROADMAP.md`'de dokunduğun ROADMAP 1 sistemini ve onun `design/gdd/` belgesini oku. Mevcut kodu `rg` ile bul.
3. `work/testx/teslim.json` dosyasını erken yaz (`"durum": "yarim"`).
4. Mantığı **yeni dosyada** yaz. Çekirdeğe yalnız ince adaptör ekle. Veri `data/`'ya, metin CSV'ye (anahtar bazlı) girer.
5. Kabul iddialarının her biri bir `_kontrol` olacak şekilde birim testi yaz. Gerekiyorsa akış testi yaz ve onu `tools/sanity_check.py` listesine ekle.
6. Testleri şu sırayla, **tek tek** (aynı anda tek Godot) koş: import → hedefli testler → **etkilenen test taraması** (değiştirdiğin her sınıf/fonksiyon adı için `rg -n "<Ad>" tests/`, çıkan bütün testler) → `metin_dogrula` (CSV'ye dokunduysan) → `python -B tools/python_test_runner.py`. Tam sanity'yi yalnız `gorev.md` "SANITY SENDE" diyorsa koş; yoksa Claude koşar. Biri düşüyorsa teslim etme: düzelt ya da `durum: yarim` ile nedenini yaz.
7. `teslim.json` dosyasını tamamla (`"durum": "bitti"`). Kapsam dışı fikirlerini `oneriler`'e, belirsizlikleri `sorular`'a yaz.

## Sert kurallar

- git commit/push, ROADMAP işaretleme, `project.godot`, yeni autoload, `koy_sahnesi`, asset ÜRETME: **YOK** (açık lisanslı uygun asset ekleme ve isim etiketli yer tutucu kuralı: rehber §2).
- Başka ajanın `[/]` maddesine ve görev dışı dosyalara dokunma.
- Testi geçirmek için testi gevşetme. Ölçmediğin şeyi "GEÇTİ" yazma.
- Godot'u adıyla kapatma. Pencereli açarsan `--audio-driver Dummy` kullan.
