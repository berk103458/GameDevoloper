# Codex — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Codex — Godot kodu, araçlar, testler ve uyumlu entegrasyon üzerinde çalışan ajan.

## Şu an üzerinde çalışılan
6 Ekim 2026: kullanıcının pull ve günlük okuma talebi. Her iki yerel kopya festive 0edaa90 commitine güncellendi; AGENTS.md, CLAUDE.md, ReadmeGrok.md ve bu günlük okundu. Bu çalışma yalnız günlük güncellemesidir; oyun kodu değişmedi.

## Sonraki plan
- SYS-09 paketi: feature/sys09-csv-dogrulama @ ee9d314, PR #2: https://github.com/berk103458/GameDevoloper/pull/2. Festive entegrasyonu bekleniyor.
- Entegrasyon sonrası SYS-09 kabul durumunu doğrula; ancak kapandığında ROADMAP satırını [x] ve (Codex) ile işaretle.
- Sonraki olası bağımsız işler SYS-06/07/08; şu an sahiplenilmedi.
- KAP-01 kilitli; başka ajanın aktif KAP-02/KAP-03 paketlerine girme. CHR alanları için KVR-01…10 ve CSV isimleri için SYS-09 sözleşmesine uy.

## Güncel durum
- Aktif dal: claude/festive-volta-li1sfm; pull tabanı 0edaa90.
- Çalışma ve C:\Users\ds\Documents\GitHub\GameDevoloper kopyaları eşitlenir. SYS-09 çalışması özellik dalında korunur; eski keen/WIP dosyaları festive'ye kopyalanmadı.
- SYS-09: salt okunur CSV doğrulayıcısı, 10 başarılı test ve mevcut CSV için başarılı kontrol; PR henüz festive'ye birleştirilmedi.
- Bu günlük güncellemesi docs: update Codex journal after festive pull commit'iyle gönderilir; git diff --check ile doğrulanır.

## Kural
Her çalışmanın başında bu dosyayı ve AGENTS.md'yi oku. Her commit/pull sonrasında durum ve sonraki planı güncelle. Kapanan ROADMAP maddelerine [x] ve (Codex) ekle; inceleme/entegrasyon bekleyen işi kapalı sayma. Kullanıcının kalıcı talimatı: tamamlanan değişiklikleri kontrol et, iki yerel kopyaya uygula, ayrı commit istemi beklemeden commit ve push yap. İlgisiz işleri ve sırları koru.
