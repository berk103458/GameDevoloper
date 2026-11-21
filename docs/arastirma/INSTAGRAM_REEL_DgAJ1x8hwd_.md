# Instagram reel DgAJ1x8hwd_

Tarih: 21 Kasım 2026. Kaynak: https://www.instagram.com/reel/DgAJ1x8hwd_/
Bu not UI kit taramasından ayrıdır. Kod, satın alma ve repoya asset yok.

## Reel ne anlatıyor

Hesap `@neyapiyoruzburak`, görünen ad **Burak Kaykın | Teknoloji • İpuçları**. Süre 43,07 saniye. yt-dlp zaman damgası `1795261506`, yani **21 Kasım 2026, 11:45:06 UTC**. Beğeni 152, yorum 19. İzlenme sayısı yt-dlp çıktısında yok; uydurulmadı.

Konu bir oyun aracı, Godot eklentisi veya arayüz kiti değil. Konu **Türkticaret.net** adlı alan adı ve barındırma firmasının öğrenci kampanyası.

Açıklama metni (yt-dlp, olduğu gibi):

> Üniversite öğrencisiysen kendi web siteni, portfolyonu veya projeni hayata geçirmek için harika bir fırsat!
>
> Türkticaret.net’in öğrencilere özel kampanyasıyla 1 yıllık hosting paketine hiç ücret ödemeden sahip olabilirsin. (Videoda heyecanla domain demişim ama kampanya 1 yıllık ücretsiz hosting paketi için geçerli, düzeltmeyi buraya bırakıyorum)
>
> Kampanya sayfasına ve başvuru detaylarına direkt ulaşmak için yorumlara ÖĞRENCİ yazman yeterli, linki hemen DM’den gönderiyorum!
>
> #İhtiyacı olabilecek üniversiteli arkadaşlarına göndermeyi ve lazım olunca bulabilmek için kaydetmeyi unutma!
> #üniversite #öğrenci #yazılım (#reklam değildir tavsiyedir)

Etiketler: `#üniversite`, `#öğrenci`, `#yazılım`. İlk `#İhtiyacı` bir etiket değil, cümlenin başı. Parantezdeki ifade reklam olmadığını söylüyor; çağrı yine de yoruma `ÖĞRENCİ` yazıp özel mesajdan link almak.

## Nasıl çıkarıldı

- `python3 -m yt_dlp` (2026.10.26) videoyu ve sesi indirdi, ffmpeg birleştirdi: `/tmp/reel/reel.mp4`. İndirme başarılı olduğu için gallery-dl ve instaloader çalıştırılmadı.
- Gömülü sayfa `https://www.instagram.com/reel/DgAJ1x8hwd_/embed/captioned/` açıldı (248 KB). Metin JavaScript içinde; hesap adı ve açıklama yt-dlp kaydından alındı.
- Kareler: ffmpeg, 4 saniyede bir, 11 JPEG. Üçü `/opt/cursor/artifacts/` altında: `reel_kare_01_hosting.png`, `reel_kare_07_sartlar.png`, `reel_kare_09_paket.png`. Repoya konmadı.
- Ses dökümü: faster-whisper `small`, Türkçe, CPU. PyAV `metadata_errors` anahtarını tanımadığı için wav dosyası `wave` ile okundu. Tiny model bozuk çıktı; rapordaki döküm `small` modelidir.

## Ekranda yazanlar ve konuşma

Ekran yazıları (karelerden):

| An | Görüntü |
|---|---|
| 0 sn | Yüz. Üst yazı: «öğrencilere ücretsiz hosting paketi». |
| ~8 sn | Google’da `turkticaret.net` araması. Alt yazı: «turkticaret.net yazıyoruz.» Sayfada Natro reklamları da var; onlar kampanyanın parçası değil. |
| ~20 sn | Türkticaret.net kampanya kartı: «Öğrenci Olmak TURKTICARET.NET ile Daha Güzel!», «Lise ve Üniversitelilere Özel 3050 TL Değerinde ÜCRETSİZ HOSTING». Alt yazı: «hosting kampanyasını bulup». |
| ~24 sn | Sayaç o anda 40 gün 22 saat 56 dk 14 sn. «Fırsatı Kaçırmayın!» Altta üyelik ve öğrenci belgesi şartı, onay maili, domain alınca 1 yıllık hostingin sepete ücretsiz ekleneceği yazıyor. |
| ~32 sn | Paket listesi (aşağıda, resmi sayfayla aynı). Alt yazı: «ve üniversite öğrencilerine». |
| ~40 sn | «düşündüğün üniversiteli arkadaşına» |
| ~43 sn | «sana hemen» |

Konuşma (faster-whisper small). Son iki cümlede model bir iki sözcüğü bozdu; köşeli parantez ekran yazısından:

1. «Üniversite öğrencisiysen domain'e tek kuruş para ödemene gerek yok. Nasıl mı?»
2. «Gel anlatıyorum.»
3. «Öncelikle Google'a giriyoruz ve arama yerine turk ticaret.net yazıyoruz.»
4. «Turk ticaret.net adresini bulduktan sonra ekranın sağ üstündeki kampanyalar butonuna tıklıyoruz.»
5. «Biraz aşağıya kaydırdıktan sonra öğrencilere ücretsiz hosting kampanyasını bulup incele butonuna basıyoruz.»
6. «Açılan pencerede de yine fırsatı kaçırmayın butonuna basıp giriş yaparak kampanyadan faydalanabilirsiniz.»
7. «Ekranda gördüğünüz her şey [model burada bozdu; ekranda «ve üniversite öğrencilerine»] tamamen ücretsiz.»
8. «[İhtiyacı] olabileceğini düşündüğün üniversiteli arkadaşına videoyu göndermeyi unutma.»
9. «Yorumla öğrenci yaz. Sana hemen linki göndereyim.»

Konuşma ilk cümlede **domain bedava** diyor. Açıklama bunu düzeltiyor: bedava olan hosting. Ekrandaki şart metni de hostingi bir domain tesciline bağlıyor.

## Türkticaret.net

Resmi sayfalar bu turda doğrudan açıldı (arama kredisi bittiği için arama motoru kullanılmadı):

- https://www.turkticaret.net/ — HTTP 200
- https://www.turkticaret.net/hosting — HTTP 200
- https://www.turkticaret.net/ogrenci-kampanyasi — HTTP 200, sayfa `iso-8859-9`
- `/ogrenci` ve `/kampanya` — HTTP 410, kampanya bu kısa yollarda değil

Sayfa başlığı: «Öğrenci Kampanyası – Turkticaret.Net». Kısa açıklama: üye olun, öğrenci belgesini gönderin, domain tesciline 1 yıllık hosting hediye.

Kampanya şartları, sayfadaki cümleler:

- Türkticaret.Net’e üye olunur, öğrenci belgesi formla gönderilir.
- Onay durumu e-posta ile gelir.
- Onaydan sonra **bir adet domain tesciline** otomatik olarak **1 yıllık hosting** hediye edilir.
- Her öğrenci kampanyadan **bir kez** yararlanır.
- Afiş lise ve üniversite diyor. «3050 TL değerindeki» paket «tüm öğrencilere ücretsiz» yazıyor.

Listelenen paket: 3 web sitesi, sınırsız disk (yanında yıldız var; yıldızın açtığı dipnot bu çekimde metne düşmedi), sınırsız aylık trafik, 100 e-posta, 2 çekirdek, 2048 MB RAM, 10 MySQL, 50 MB MsSQL, Cloudlinux, Litespeed, Litespeed Cache, ücretsiz SSL, 10 alt alan adı, Windows veya Linux.

Aynı sayfanın menüsünde domain ayrıca ücretli: «0,69$'dan başlayan» kayıt, belgesiz .tr 2,89$, belgesiz com.tr 0,99$. Bunlar hediye değil, menü fiyatı.

Firma satırı sayfada: Uludağ Üniversitesi Görükle Kampüsü Ar/Ge Binası yanı, Nilüfer, Bursa. `info@turkticaret.net`, 444 4 886, +90 850 224 86 40. Alt bilgi «Copyright 1999-2026 Turkticaret.Net».

İşe yarıyor mu: sayfa duruyor ve şartlar yazılı. Kayıt olunmadı, öğrenci belgesi gönderilmedi, sepette hostingin sıfırlandığı görülmedi. Bu yüzden «hediye kasada gerçekten uygulanıyor» denemez. Konuşmadaki «domaine tek kuruş yok» cümlesi hem açıklamayla hem sayfayla çelişiyor; ona göre hareket edilmez.

Bu bir yazılım lisansı değil. CC0 veya CC-BY asset yok. Paket PHP, e-posta, MySQL ve panel barındırması. Godot oyununun kaynağı veya modeli değil.

## Kapı Muhafızı

İlgisiz. Oyun Godot 4.7.2, 3B, açık depo. Çalıştırmak için cPanel, MySQL veya öğrenci hostingi gerekmez. Depo zaten GitHub’da. Kampanya bir web sitesi veya portfolyo içindir; oyun koduna, arayüze, 3B assete ve lisans kuralına katkısı yok.

Öğrenci belgesi, ücretli domain ve Instagram yorumuyla DM linki bu proje için yol değil. Barındırma dosyası repoya konmaz.

Ayrı bir tanıtım sitesi istenirse o başka iştir. Oyun sayfası için eldeki yer GitHub’dır; PHP hosting şart değil.

## Öneri

Kampanyayı oyuna bağlama. Satın alma, kayıt ve `ÖĞRENCİ` yorumu yok. Reel bir araç tanıtmıyor; düzeltilmiş haliyle «domain alana 1 yıl hosting hediye» diyen bir öğrenci ilanı.
