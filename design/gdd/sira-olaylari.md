# Sıra olayları

*Durum: Uygulandı (4 Ekim 2026, kullanıcı isteği). İçerik: `tools/icerik/icerik_uret.py` → `data/sira_olaylari/`.*

## Overview
İki gelen arasında, kapının önünde bekleyen kuyrukta anlık bir olay olur: sıra kapma, kavga, yere yığılan,
vazgeçen, panik. Kamera kuyruğa döner, olay 3D'de oynar, bekçi iki seçenekten birini seçer, sonuç oynar.

## Detailed Rules
1. Bir karar verilip gelen ayrıldıktan sonra, sırada en az bir kişi varsa `sira_olay_olasiligi` ile bir olay seçilir (ağırlıklı).
2. Olaylar gece olaylarıyla aynı veri biçimindedir (OlayVerisi); etkiler aynı uygulayıcıdan geçer (bar, akçe, ambar, gerekli).
3. Ek etkiler: `kuyruk: -1` sıradan birini düşürür (o gece bir kişi az gelir); `geri: true` canlandırmada kişinin yerine dönmesidir.
4. Koşul `kuyruk_min`: olayın çıkması için sırada en az bu kadar kişi.

## Formulas
Seçim: `olasılık = sira_olay_olasiligi` (0.35); aday ağırlıkları: atlama 3, kavga 2, bayılma 2, vazgeçen 2, panik 1.

## Edge Cases
- Sıra boşsa olay çıkmaz. Bar kırılırsa gece orada biter.
- "Su ve ekmek gönder" ambarda 1 yoksa seçilemez.

## Dependencies
Gece olayları uygulayıcısı (Oturum.olay_uygula), Barlar (8), Kapı arayüzü (18), Kapı sahnesi.

## Tuning Knobs
`sira_olay_olasiligi` (0–1), olay ağırlıkları ve etkileri (içerik betiği).

## Acceptance Criteria
- Beş olayın her biri tetiklenince kamera kuyruğa döner, olay oynar, seçenekler çıkar, sonuç oynar. — `production/qa/evidence/sira-olaylari-1/`
- "Bırak gitsin" sıradan bir kişiyi düşürür; "Seslen" düşürmez.
