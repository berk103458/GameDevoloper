# Ajan düzeni — Kapı Muhafızı

Kısa kontrol listesi. Ayrıntı ve yasaklar `AGENTS.md` içindedir. Çelişirse `AGENTS.md` üstündür.

## Tek ana dal

- Oynanabilir oyun yalnız `claude/festive-volta-li1sfm` (festive) üzerindedir.
- `claude/keen-cerf-42meo7` ikinci ana dal değildir. PR #1 (festive→keen) entegrasyon yolu sayılmaz.
- Özellik dalı güncel festive’ten açılır. Festive ilerleyince özellik dalına festive alınır; PR böyle yaklaştırılır.
- Merge kararı Ahmet’tedir. Açık PR #2 (SYS-09) ve PR #4 (QuestSystem) kendiliğinden merge edilmez.

## Kod

- Yeni özellik = yeni dosya + çekirdekte ince adaptör. Sınıfı silip yeniden yazmak yasaktır.
- Kök HUD tektir (`Hud`, `KoyEkrani`). İkinci HUD yazılmaz; panel `src/arayuz/koy_hud/` veya `src/arayuz/kapi/` altındadır.
- Korunan çekirdek (`AGENTS.md` bölüm 2) iki dalda aynı anda değişmez.
- `koy_sahnesi.gd` ve `KoyYerlesimi` yasaktır. Standart `KoyYonetimSahnesi` + `KoyYonetimi`. Yasak dosya yoksa ağaca dokunulmaz; varsa ana yola alınmadan kaldırılır, `.gitignore` ile gizlenmez.

## İş bitince

1. ROADMAP: festive’te kilitli/bitmiş madde `[x]` ve satır sonu `(AjanAdı)`. Uydurma `[x]` yok. KAP-01 kilitliyse korunur. Merge edilmemiş iş `[x]` olmaz; `PR #N bekliyor` yazılır.
2. Kendi status dosyası: kimlik, bu iş, sonraki adım, festive HEAD. Codex → `codex.md/Codex.md`, Gemini → `GEMINI.md`, Cursor → `codex.md/Cursor.md`.
3. Commit mesajı neyi neden değiştirdiğini söyler (`type(scope): açıklama`).
4. PR hedefi festive’tir.

## Ahmet yerel çekme

Bulut veya GitHub ajanı şu klasörlere yazamaz. PR veya push sonrası Ahmet her iki kopyada festive çeker:

- `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper`
- `C:\Users\ds\Documents\GitHub\GameDevoloper`

Komut (her iki klasörde, festive dalındayken): `git pull origin claude/festive-volta-li1sfm`
