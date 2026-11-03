# Söz Veri Şeması ve Geçiş Belgesi (DIY-01a / DIY-16)

Bu doküman, Kapı Muhafızı Söz motorunun (`SozMotoru`) konuştuğu JSON veri biçimini ve eski diyalogların yeni sisteme eşleme kurallarını tanımlar.

---

## 1. Söz Veri Şeması Kuralları (DIY-01a)

1. **Zorunlu Alanlar:** `konusmaci`, `cekirdek`, `dugumler`.
2. **Çekirdek Türleri (`cekirdek`):**
   - `durust`: Karakter açık sözlüdür. Heybe ipucu veya yüzleşme şartı aranmaz; ipucusuz doğrulamadan geçer. Boş `sir` alanı yazılmaz.
   - `koruma_yalani` / `baskasinin_sirri` / `tehlikeli_yalan`: Karakter bir şey gizler. En az bir ipucu (`ipucu_id`) ve bir yüzleşme çifti (`celiski` / `yuzlesme`) zorunludur.
3. **Düğüm Kısıtları:**
   - Tek giriş noktası (`giris`) olmalıdır; ikinci bir giriş düğümü şema hatasıdır.
   - Hiçbir düğüm kendine kenar veremez (`hedef == id` yasaktır).
   - Seçenek kimlikleri dosya ve düğüm içinde tekildir; çift kimlik reddedilir.
   - Düğüm sayısı `data/soz/kurallar.json` içindeki `derinlik_tavani` (12) değerini aşamaz; 13. düğüm şema hatası verir.
4. **Etki Alanları:**
   - İzin verilen etki anahtarları: `bar`, `akce`, `ambar`, `bayrak`, `tansiyon`, `ziyaret`.
   - `altin` gibi tanınmayan veya eski anahtarlar 1 şema hatası üretir.

---

## 2. Eski Diyalog Geçiş ve Eşleme Tablosu (DIY-16)

| Eski Sistem / Alan | Yeni Söz Motoru Karşılığı | Açıklama / Kural |
|---|---|---|
| `acilis` (otomatik uzun tirad) | Yalnızca `selam` düğümü | Karakter kapıya varınca önce kısa selam verir; uzun hikâye otomatik anlatılmaz. |
| İlk soru `"Kimsin?"` | `tasinmaz` / konu merkezi | Robotik "Kimsin/Nesin" yerine konu merkezi (`nereden`, `ne_is_bilirsin`) açılır. |
| `sorular` dizisi | Konu ve Katmanlar (DIY-03/04) | Sabit konular ve aynı konuda üsteleme katmanlarına ayrılır. |
| `SohbetVerisi.giris` | `selam` evresi | Tekil karşılama. |
| CHR `DUGUM_00` ve 3 dal | `giris` -> `konular` -> `yuzlesme` | Modüler Söz düğümlerine haritalanır. |
| `Clue_*` ve `Flag_*` | `ipucu_id`, `bayrak` | Kimlikler birebir korunur. |
| `karar_matrisi` | KOP-10 Karar Matrisi | Karar sonuçları motor dışı karar çubuğuna aktarılır. |
| `diyalog_sira` | `tasinmaz` | Sıra sabrı ve Söz motoru yürütücüsü dinamik çalışır. |

---

## 3. Örnek Dosyalar

- `data/soz/ornek_durust.json`: Dürüst rençber, ipucusuz geçerli.
- `data/soz/ornek_koruma_yalani.json`: İpucu ve yüzleşme içeren geçerli sır düğümü.
- `data/soz/ornek_hatali.json`: Çift seçenek, kendine kenar ve 13 düğümlü tavan aşımı içeren test dosyası.
