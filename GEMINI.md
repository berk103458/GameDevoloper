# Gemini — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Gemini — planlama / analiz ajanı (ROADMAP, mimari not, doğrulama).

## Şu an üzerinde çalışılan
`OGR-14` (`[/] (Antigravity)`): Beyan defteri ilk çelişkide tanıtılır. `src/kapi/defter_tanitimi.gd`, `src/arayuz/chr_kapi_adaptoru.gd` (oyun akışı: `kapi_ekrani.gd:337` ve `chr_kapi_adaptoru.gd:42` → `chr_kapi_adaptoru.gd:85`), `data/metin/metinler.csv` ve `tests/unit/kapi/defter_tanitimi_test.{gd,tscn}` güncellendi. Hedefli headless testler (`--quit`, `defter_tanitimi_test.tscn`, `ilk_saat_test.gd`, `celiski_goster_kontrol.tscn`) ve `tools/metin_dogrula.py` GEÇTİ. Güncel kural gereği madde `[/] (Antigravity)` bırakıldı.

## Sonraki plan
Sıradaki açık madde: Faz 1 (Bölüm 35) `AYR-29` / `AYR-33`.

## Güncel durum
- ROADMAP push’lu (`4f7c460`); festive ana dal.
- festive+keen WIP **unstaged** olabilir — bu commit’e alınmadı.
- Kardeş günlükler: `CLAUDE.md`, `codex.md/Codex.md`, isteğe bağlı `codex.md/Muharrir.md`.

## Kural
Bu projede her çalıştığında **önce** bu dosyayı ve `AGENTS.md`’yi oku. Her **commit** ve **pull** sonrası buradaki durum bölümünü güncelle. ROADMAP’te kapattığın adımları `[x]` yap ve satır sonuna `(Gemini)` yaz.

Ajan listesi ve kitleri: docs/AJAN_KITLERI.md. Kalfa = Ahmet'in Codex'i (Berk'in Codex'i değil); kimlik: codex.md/Kalfa.md. Başka ajanın [/] sahipliğine dokunma.
