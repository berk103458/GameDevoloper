# Dünya kitabı (YAZ-01)

Oyuncu bu kitabı görmez; yazar ve doğrulayıcı görür. Oyun metni dönem bilgisini buradan alır. Kitap hiçbir oyun makinesi (salgın, mevsim, tüccar, divan, yozlaşma, harita, çift kasa, cenaze, üretim) için ikinci kural yazmaz; o makineler `ROADMAP.md` içindedir, kitap yalnız onların dönem ağzını besler.

## Dosya biçimi

- Konu başına bir dosya; on dört dosya kapanış sayısıdır.
- Olgular `- **anahtar:** metin (kesinlik)` biçimindedir. Anahtar küçük harf ve alt çizgidir; iki dosyada aynı anahtar farklı metinle geçerse doğrulayıcı çifti listeler ve ikisi de oyuna girmez.
- Kesinlik: `kesin` (kaynakta açıkça var), `gelenek` (anlatı ya da sonraki dönem kaydı; oyunda "denir ki" ağzıyla kullanılır), `yaklaşık` (tarih ya da sayı tartışmalı).
- `## Kaynaklar` boş olamaz. Künyesi olmayan kaynak yok hükmündedir.
- Dosyanın sonunda `## Onay` iki satırdır: `Anlatı yönetmeni:` ve `Ahmet:`. İkisi de "bekliyor" iken dosya `data/soz/` altına alınmaz (YAZ-04).

Doğrulayıcı: `python -B tools/dunya_kitabi_dogrula.py`.

Bu README konu sayımına girmez.
