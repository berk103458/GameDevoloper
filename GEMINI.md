# Gemini — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Gemini — planlama / analiz ajanı (ROADMAP, mimari not, doğrulama).

## Şu an üzerinde çalışılan
- **MESHY-27 (`klip_eksik:*` 44/44 karakter):** Tamamlandı (`0` atlanan karakter; pilot `34` + toplu `618` = **`652` kredi** harcandı, yedek anahtar `...AqQC` kalan bakiye: **`205` kredi**). `ciftci_bekle.res` `SAH-03` adım boyu aşımı nedeniyle reddedilip çıkarıldı; `ayak_zemini_kontrol.tscn` ve `chr_kapi_kontrol.tscn` `RC=0` ile geçti.

## Sonraki plan
Ahmet'in yeni görev veya inceleme talimatı bekleniyor.

## Güncel durum
- Tüm 142 Görev 25/26 Meshy 3B asset'i + tüm 44 MESHY-27 eski karakter iskelet ve klipleri `claude/festive-volta-li1sfm` dalında.
- Kardeş günlükler: `CLAUDE.md`, `codex.md/Codex.md`, `codex.md/Antigravity.md`, isteğe bağlı `codex.md/Muharrir.md`.

## Kural
Bu projede her çalıştığında **önce** bu dosyayı ve `AGENTS.md`’yi oku. Her **commit** ve **pull** sonrası buradaki durum bölümünü güncelle. ROADMAP’te kapattığın adımları `[x]` yap ve satır sonuna `(Gemini)` yaz.

Ajan listesi ve kitleri: docs/AJAN_KITLERI.md. Kalfa = Ahmet'in Codex'i (Berk'in Codex'i değil); kimlik: codex.md/Kalfa.md. Başka ajanın [/] sahipliğine dokunma.

## ENGELDE DURMA YOK (Berk, 16 Kasım 05:20)

ROADMAP ajanları (Claude, Antigravity, Codex) için kalıcı kural:
- Bir maddede engele ya da ön koşula takılan ajan DURMAZ.
- Önce engeli kendisi çözmeye çalışır: ön koşulu tamamlar, hata veren testi düzeltir ya da bağımlı maddeyi önce bitirir.
- Çözemezse engeli kendi günlüğüne kısaca yazar, o maddeyi atlar ve sıradaki boş maddeye geçer; döngü devam eder.
- Hiçbir ajan "engel var" gerekçesiyle durmaz. Artık ENGEL yazıp durmak yok; yalnızca gerçek kullanım limiti dolunca durulur.
- Hiç çalışılabilir boş madde kalmadıysa çıktıya yalnızca tek satır BOS yazılır; döngü bir süre bekleyip pull yapar ve yeniden dener.
