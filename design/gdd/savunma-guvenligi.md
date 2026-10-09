# Savunma hazırlığı ve Güvenlik — HAR-15

## Amaç ve kapsam
HAR-10'un gerçek kapı mızraklısı / sur okçusu atamaları ile ANI-02'nin mevcut devriyesi, ikinci perde/ağalıkta canlı Güvenlik katkısı verir. İlk perde ve bitmiş oturumda katkı sıfırdır. Yeni savaş, NPC, stat, kayıt alanı veya gece işlemi kurulmaz. Bu uygulama HAR-10 belgesindeki önceki kanıtsız formül iddiasının yerine geçer; ROADMAP kapanışı Claude Code incelemesini bekler.

## Tek kaynak ve formül
Mevcut `KervanKorumasi.guvenlik(y)` tek 0–100 Güvenlik hesabı olarak kalır:

```
rol_payı = devriye: 1, kapı: 3, sur: 4
hazırlık_i = floor((clamp(stat_i, 1, 10) + rol_payı_i) × clamp(sağlık_i, 0, 100) / 100)
net_i = max(0, hazırlık_i − max(0, y.a.muhafiz_asayis))
katkı = min(20, Σ net_i)
Güvenlik = clamp(100 − asayis_riski + katkı − dış_görev_sayısı × mevcut_kervan_kaybı, 0, 100)
Oturum.gosterge(3) = floor(Güvenlik / 10)
```

`Koylu.stat` mevcut 1–10 beceri alanıdır; ayrı hayalî savaş statı eklenmez. Sağlık mevcut 0–100 alanından alınır. Varsayılan temel nöbet payı `muhafiz_asayis=5`; stat5/sağlık100 nöbetçi devriyede +1, kapıda +3, surda +4 verir. Stat10/sağlık100 surda +9; stat5/sağlık75 surda +1; stat10/sağlık50 surda +2. Kişi başına aşağı yuvarlama yapılır, kesirler biriktirilmez.

Gerekçe: mevcut etkin muhafız sayısı gece sonunda zaten `asayis_riski`ni kişi başına 5 azaltır. Yeni hesap bu temel payı hazırlıktan çıkarır; aynı muhafızın düz nöbet katkısını tekrar eklemez. Rol payı sabit konumun yerel denetim avantajıdır; sur kapıdan bir puan yüksek, devriye en düşük. Sağlık ve beceri değeri zayıf nöbetçiye otomatik tam rol bonusu vermez. 20 puanlık tavan, bir kadronun HAR-11'in tüm risk eşiğini tek başına ortadan kaldırmasını sınırlar. Bunlar belgelenmiş ilk denge değerleridir; oynanış geri bildirimiyle değişebilir.

## Uygunluk ve çift sayım
Gerçek `y.koylular` kadrosu dolaşılır. HAR-10'un uygunluk ve kontenjanları kullanılır: yetişkin, sağlık≥50, canlı hazır muhafız/kışla görevi, borçsuz, tok, sağlıklı, uyanık ve iş isyanında olmayan kişi. Açık/gizli yaralı veya zindan bayrağı, aktif yaralanma kaydı (bayrak eksik olsa da) ve tedavi bekleyen yanık katkıyı engeller. Kervana kiralanmış kişi aynı nüfus/atamada kalır fakat katkı vermez.

Bir ID yalnız bir rol ve bir katkı alır. Kapı en çok2, sur en çok4; sur işlevli olmalıdır. Etkin taktik rolü olmayan gerçek uygun muhafız mevcut devriyede sayılır. İşlevsiz sur / kontenjan dışında kalan rezervasyon için HAR-10'un devriyeye dönüş davranışı korunur; sur bonusu verilmez. Kayıt defterinde var olup gerçek kadroda bulunmayan kişi sayılmaz. Rol mantıksal görev atamasıdır; formül kamera, animasyon fazı veya görsel Node konumuna bağlı değildir.

ANI-02 yalnız rota üretir, HAR-10 yalnız rol/konum/donanım üretir; bu dosyalara ikinci bonus konmaz. Gece asayiş hesabı ve `savunma_gucu()` değiştirilmez. Kervan korumasındaki eski geçici -5 bir kez uygulanır; yerel hazırlık katkısının kalkması aynı kişiye ikinci -5 eklemek değildir. Örneğin baz76, stat5/sağlık100 sur nöbetçisi: yerelde80, kiralanınca71, dönüşte80. Kiralama bilgi notu iki etkiyi açıkça belirtir.

## Kayıt, RNG ve sunum
Katkı her okumada mevcut kadro, HAR-10 optional defter, stat, sağlık, bordro, dış görev ve sur durumundan yeniden türetilir. Yeni kalıcı alan, cache veya kayıt sürümü yok; eski ağalık kaydındaki uygun muhafız devriye olarak değerlendirilir. Okuma RNG çekmez, asayiş/kasa/savunma veya görev kayıtlarına yazmaz; tekrar okumak katkı biriktirmez. `Oturum.gosterge(3)`, `StatEnjektoru`, HAR-11, Gözcü'nün izole kayıt kopyası ve mevcut pazar bilgi alanı aynı kaynağı kullanır.

Mevcut köylü kartının konuşlanma alanında Güvenlik/100 ve toplam hazırlık katkısı görünür. Rol düğmesi kartı mevcut yenileme yoluyla açar; ikinci HUD yok. Gizli sağlık/niyet bayraklarının kendisi açıklanmaz. HAR-11 ağırlık değişimi kesin varış veya suç kanıtı değildir. Asset gerekmedi; mevcut metin/kart/yer tutucular kullanılır, envantere yeni ihtiyaç yok.

## Doğrulama
`tests/unit/kvr/savunma_guvenligi_test.gd`: sayısal rol/stat/sağlık sınırları, 20/100 ve 0/100 tavanları, uygunluk/kayıt/terminal, gerçek kiralama/dönüş, legacy/JSON, tekrarlı okuma saflığı, gerçek gece temel asayiş/RNG eşitliği ve HAR-11'in 3/4 ile7/8 eşikleri.

`tests/oto/savunma_guvenligi_kontrol.tscn`: gerçek Ana→KoyEkrani→KoyluKarti kapı/sur/devriye düğmeleri; görünür metin77→79→80→77, aynı gerçek sur rotası/modeli, kayıt dönüşü, sağlık/yaralı/zindan güncellemesi ve gerçek pazar kiralama düğmesiyle71→80. `tools/sanity_check.py` listesinde; birim test otomatik keşifte.

İlgili HAR-10, Güvenlik, ANI-02, kervan koruma ve Gözcü birim/UI regresyonları headless çalıştırılır. Tam editor import `.import` dosyalarını değiştirebildiğinden bu görevde kullanıcı talimatıyla çalıştırılmaz; `.import` SHA-256 karşılaştırması yapılır. Native görsel render doğrulaması bu headless teslimin dışındadır.
