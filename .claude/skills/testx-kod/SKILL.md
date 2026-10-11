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
6. Testleri şu sırayla koş: import → hedefli testler → `metin_dogrula` (CSV'ye dokunduysan) → **tam sanity**. "0 failed" değilse teslim etme. Hatayı düzelt ya da `durum: yarim` ile nedenini yaz.
7. `teslim.json` dosyasını tamamla (`"durum": "bitti"`). Kapsam dışı fikirlerini `oneriler`'e, belirsizlikleri `sorular`'a yaz.

## Sert kurallar

- git commit/push, ROADMAP işaretleme, `project.godot`, yeni autoload, `koy_sahnesi`, asset üretme: **YOK**.
- Başka ajanın `[/]` maddesine ve görev dışı dosyalara dokunma.
- Testi geçirmek için testi gevşetme. Ölçmediğin şeyi "GEÇTİ" yazma.
- Godot'u adıyla kapatma. Pencereli açarsan `--audio-driver Dummy` kullan.
