# Gemini — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Gemini — planlama / analiz ajanı (ROADMAP, mimari not, doğrulama).

## Şu an üzerinde çalışılan
- `OGR-14` (`[/] (Antigravity)`): Beyan defteri ilk çelişkide tanıtılır. Canlı yol `kapi_ekrani.gd:337` ve `chr_kapi_adaptoru.gd:42` → `chr_kapi_adaptoru.gd:93` (`DefterTanitimi.oturumda_kontrol_et`). `defter_tanitimi_test.tscn` ve `ilk_saat_test.gd` GEÇTİ.
- `OGR-43` (`[/] (Antigravity)`): Yedi persona ilk saati geçer. `tools/python_test_runner.py --yedi-persona` eklendi, `tests/oto/otomatik_oyuncu.gd` `MUHAFIZ_GECMISI`/`son`/`ambar` raporlar, `src/sistemler/karakter_kadrosu.gd:122` eksik anahtar koruması eklendi. 7/7 koşu (`hepsini_kabul`..`comert_ciftci`) `gece=6, son=0, ambar=11..37` ile GEÇTİ. Kural gereği madde `[/] (Antigravity)` bırakıldı.

## Sonraki plan
Sıradaki açık madde: Faz 1 `OGR-23` / `OGR-57` (veya Faz 2 açık maddeleri).

## Güncel durum
- ROADMAP push’lu (`4f7c460`); festive ana dal.
- festive+keen WIP **unstaged** olabilir — bu commit’e alınmadı.
- Kardeş günlükler: `CLAUDE.md`, `codex.md/Codex.md`, isteğe bağlı `codex.md/Muharrir.md`.

## Kural
Bu projede her çalıştığında **önce** bu dosyayı ve `AGENTS.md`’yi oku. Her **commit** ve **pull** sonrası buradaki durum bölümünü güncelle. ROADMAP’te kapattığın adımları `[x]` yap ve satır sonuna `(Gemini)` yaz.

Ajan listesi ve kitleri: docs/AJAN_KITLERI.md. Kalfa = Ahmet'in Codex'i (Berk'in Codex'i değil); kimlik: codex.md/Kalfa.md. Başka ajanın [/] sahipliğine dokunma.
