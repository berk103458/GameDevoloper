<!-- PROTOTYPE - NOT FOR PRODUCTION -->
<!-- Question: Önce sohbet, sonra karar — kapıdaki kararlar ağır hissettiriyor ve "bir gece daha" dedirtiyor mu? -->
<!-- Date: 2026-10-04 -->

# Kapı döngüsü — prototip

**Durum:** in-progress (oynanmayı bekliyor)

## Sınanan soru
Kapıya gelenle önce konuşup sonra karar vermek kararları ağır hissettiriyor mu ve bir bar kırılınca oyuncu "bir gece daha" diyor mu?
**Sinyal:** adlı karakterlerin en az yarısında karar öncesi duraksama / ikinci soruyu sorma; ilk oyun bitince oyuncunun kendiliğinden "Yeniden başla"ya basması.

## Nasıl çalıştırılır
1. `git pull`
2. Godot 4.7.2 → Proje Yöneticisi → **İçe Aktar** → `prototypes/kapi-dongusu-concept/project.godot`
3. **F5** (Projeyi Çalıştır).

Kontroller: fare ya da ok tuşları + Enter. Kararda **1–4** seçer; **aynı düğmeye ikinci kez basmak onaylar**; **Esc** seçimi bırakır.

## İçinde ne var
- Her gece 3 kişi: 6 adlı karakter (Miraen, Sorhan, Thessra, Karaca Usta, Aydoğdu, Saruca Hatun) + adsız figürler.
- Kişi başı en çok 2 soru, sonra karar (karaktere göre değişen seçenekler), iki adımlı onay.
- 4 bar (Halk, Soylular, Tüccarlar, Ordu; adlar onaylanmadı), 0'da ya da 10'da kırılır; ilk 3 kırılmayı rüşvet hakkı kurtarır.
- Köy nüfusu (asker / esnaf / çiftçi); gece sonunda çiftçi azsa Halk düşer, 4. geceden sonra asker azsa Ordu düşer.
- Dönüş kuralları (Karakter kadrosu GDD): hiç dönmez / azalan olasılıkla döner / birden çok gelir.
- Skor: hayatta kalınan gün.

## Prototip varsayımları (GDD'de henüz karar yok)
- Bar iki uçta da kırılır (Reigns gibi) — Barlar (8) tasarlanınca karar verilecek.
- Rüşvet ve kışla karakteri köyde tutar, yalnız ret gönderir — Karar (7) karar verecek.
- Rüşvet hakkı otomatik harcanır (kırılan bar 5'e döner).
- Sayılar elle konuldu; denge yok.

## Otomatik deneme (geliştirici notu)
Godot 4.7.2 ile sanal ekranda rastgele oynatıldı: hata yok, rastgele oyuncu 6 gece dayandı ("Halk kırıldı"). Ekran görüntüleri `ekran/` altında.

## Bulgular
_(Oynandıktan sonra doldurulacak.)_
