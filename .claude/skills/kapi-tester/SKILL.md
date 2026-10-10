---
name: kapi-tester
description: "Kapı Muhafızı tester turu: güncellen, sanity, değişen ROADMAP maddelerini kenar durumlarla test et, otomatik oyuncu koşuları, elle oyna, BULGULAR / DEGISIKLIK_ONERILERI / GELISIM_RAPORU yaz, Claude'a bildir. Kullan: 'test turu', 'tester başla', 'oyunu test et', 'bulgu yaz', 'gelişim raporu'."
argument-hint: "[tur | madde <KIMLIK> | dogrula <TST-xxxx> | rapor]"
user-invocable: true
---

# kapi-tester

Önce `docs/tester/TESTER_REHBERI.md` dosyasını baştan sona oku. Bu skill o rehberin kısa uygulama sırasıdır, rehberin yerine geçmez.

## Kipler

- **`tur`** (varsayılan): rehber §4'teki 8 adımlı tur.
- **`madde <KIMLIK>`**: tek bir ROADMAP maddesine odaklanır (ör. `madde KRI-14`). Maddeyi ROADMAP'te bul, `design/gdd/` içinden GDD'sini ve `src/` dosyasını oku. Kenar durumları listele ve her birini oyunda ya da akış testinde dene.
- **`dogrula <TST-xxxx>`**: `DÜZELTİLDİ` durumundaki bulgunun adımlarını yeniden uygula. Sonuca göre `DOĞRULANDI` ya da `YENİDEN AÇILDI` yaz.
- **`rapor`**: test yapmaz. Sadece `GELISIM_RAPORU.md` girişini günceller ve açık bulguların sayımını yapar.

## Sabitler

- Godot konsol: `C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`
- Pencereli: aynı klasördeki `Godot_v4.7.2-stable_win64.exe`
- Kanıt klasörü: `work/tester/tur<N>/`. Bu klasör git'e girmez.
- Sanity: önce `--headless --editor --import --quit`, sonra `python -B tools/sanity_check.py --godot <konsol> --logs work/tester/tur<N>/sanity`.

## Sert kurallar

1. Sadece `docs/tester/` ve `codex.md/Tester.md` yazılır. `src/`, `data/`, `tests/`, `ROADMAP.md` yazılmaz.
2. Her bulguda şunlar bulunur: adımlar, beklenen, gerçek, tekrar sayısı, kanıt yolu. Tekrar üretilemeyen bulgu "kararsız" olarak işaretlenir.
3. Beklenen değer GDD'den ya da ROADMAP tanımından alınır. Kaynak gösterilmeyen bir "beklenen" yazılmaz.
4. Aynı sorun ikinci kez açılmaz; mevcut kayda not eklenir.
5. P0 bulgu (çökme, kayıt bozulması, sanity FAIL) hemen Ajan Masası'na (issue #11) `[Tester → Claude] [SORUN]` olarak yazılır.
6. Commit sadece rapor dosyalarını içerir. Mesaj kalıbı: `tester: tur N — X bulgu, Y öneri`. Force-push yapılmaz.

## Tur sonu çıktısı (Claude'a)

```
Tur N · commit <kısa> · sanity <PASS>/<FAIL>
Yeni bulgu: TST-.. (P1) …, TST-.. (P2) …
Doğrulanan: TST-..   Yeniden açılan: TST-..
Yeni öneri: ONR-.. …
Sonraki tur odağı: …
```
