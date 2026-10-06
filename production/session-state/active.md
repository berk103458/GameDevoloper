# Session State

## Codex devralması — 2026-10-06 (güncel)

- Claude'un son brifingi `son-devralma.md` içinde; geliştirmeyi Codex devraldı.
- Köy görsel planı: `design/art/koy-gorsel-plani.md`. HUD simgeleri, maliyet kartları, yatay kaydırma, ölçeklenen metin ve duraklatma/1x/2x/3x hazır.
- Köylüler: yol tercih eden A*, bina/arazi engeli, iş/dinlenme/gece ev rutini; yenilemede kimlik/konum korunuyor. Yapı içine giriş ve tam kalabalık kaçınması sonraki işler.
- Kontroller: rota birim testi, köylü hareket entegrasyonu ve HUD entegrasyonu başarılı; Vulkan görünüm kanıtları `production/qa/evidence/koy-hud/` içinde.
- Meshy API kimlik doğrulaması ve görev listesi başarılı; kontrol anında 2 kredi. Anahtar yalnız gitignored yerel dosyada. Ücretli üretim yapılmadı. Web kütüphanesinin oturum erişimi ayrıca doğrulanmadı.
- Çalışma ve `C:\Users\ds\Documents\GitHub\GameDevoloper` kopyaları her değişiklikte eşitlenir. 2026-10-06 güncel kullanıcı talimatı: her tamamlanan geliştirme kontrol edilip iki yerel kopyada eşitlendikten sonra ayrı bir commit istemi beklenmeden commit ve push yapılır.
- Sıradaki geliştirme: mesleğe özgü alet/hareketler ve kalabalık kaçınması, ardından görsel plandaki yapı/çevre iyileştirmeleri.

Önceki oturum kayıtları aşağıda tarihsel bağlam olarak korunmuştur.

- **Task**: karakter-kadrosu GDD
- **Status**: Complete — Designed (pending /design-review in a fresh session); QA findings applied (34 ACs)
- **File**: design/gdd/karakter-kadrosu.md
- **Decisions**: 6 named (Miraen, Sorhan, Thessra, Karaca Usta, Aydoğdu, Saruca Hatun); adsız sınıf şablonları; F1 azalan dönüş p0=0.6 d=0.5 k_azami=4; F2 2–4 gece; F3 Sorhan 3 / Saruca 2; kaldı/gitti eşlemesi Karar (7)'ye; two RNG streams (dönüş, ad)
- **Open**: Osmanoğulları anakronizmi (Sonlar 15); imza şekilleri art-director onayı bekliyor
- **Previously done**: #1 oyun durumu, #2 içerik veri hattı, #3 girdi ve odak — Designed
- **Next**: Ayarlar ve erişilebilirlik (17) — user requested; then Barlar (8)
- **Done**: ayarlar-ve-erisilebilirlik GDD (#17) — Designed; MVP subset: ses, ekran modu, metin ölçeği, belirme hızı; VS: tuş atama, iki adımlı onay, imleç, azaltılmış hareket, ekran okuyucu. QA applied (24 ACs, injected storage + window adapter, key classes etkin/bilinen-pasif/bilinmeyen).
- **Next**: Barlar (8)

## Prototype: kapi-dongusu-concept
- **Phase**: 6 — Playtest debrief (built, auto-run OK on Godot 4.7.2 under xvfb; waiting for user to play)
- **Path**: Engine (Godot), separate project in prototypes/kapi-dongusu-concept/
- **Hypothesis**: Önce sohbet sonra karar → kararlar ağır, bar kırılınca "bir gece daha"
- **Assumptions**: bars break at 0 and 10; rüşvet/kışla = kaldı; rüşvet hakkı auto-spent
- **Tooling**: Godot 4.7.2 linux binary at /tmp (session-local), xvfb-run + opengl3 for screenshots

## Dikey dilim 1 (ana proje) — 2026-10-04
- **Durum**: Oynanabilir; Godot 4.7.2'de xvfb altında otomatik oynatıldı (perde 1 → köy oturdu → perde 2 → son); ekranlar production/qa/evidence/dikey-dilim-1/
- **Kod**: src/veri (Resource sınıfları), src/cekirdek/katalog.gd, src/sistemler (oturum, barlar, köy, kadro, kayıt, ayarlar), src/arayuz (ana, kapı, köy, HUD, bilgi, ayarlar)
- **İçerik**: tools/icerik/icerik_uret.py → data/ (.tres + metinler.csv); sanat: tools/art/uret_yer_tutucu.py → assets/art/
- **GDD'siz geçici kurallar**: bar yalnız 0'da kırılır; rüşvet/kışla = kaldı; köy oturma eşiği 12; perde 2 = 10 gece; saldırı/savunma formülü oturum.gd
- **Sırada**: ses, Barlar/Sohbet/Karar GDD'leri, gdUnit4 testleri, sonlar, daha çok içerik
