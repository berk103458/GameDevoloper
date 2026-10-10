# KRI-09 — Krizde levent firarı

Yeni `src/koy/levent_firari.gd`, gerçek `KoyYonetimi.gece()` içinde mevcut `_isyan` sonrasında çalışır. Mevcut nüfus, nöbet, isyan ve tek `KervanKorumasi.guvenlik` hesabı genişletilir.

## Tetik ve önleme

Ağır kriz: devam eden KRI-06 kıtlık isyanı, kamuya açılmış belirtili bulaşıcı hastalık, KRI-04 kirli kuyu veya mevcut moral isyanı. Gizli kuluçka/casus kimliği kriz oluşturmaz. Kesintisiz kriz sebeplerinin birbirine dönüşmesi yeni dönem değildir.

Levent, adsız ve yetişkin; sınıfı asker veya birincil zanaatı asker olan yaşayan kişidir. Sadakat en fazla30 ve moral en fazla35, gerçek açlık veya mevcut bordro borcundan en az biri aranır. Yüksek sadakatli asker, yalnız nöbete atanmış çiftçi, adlı CHR hikâye kişisi, çocuk/yaşlı, tutuklu, karantinadaki veya dış görevdeki kişi korunur. Maaş, erzak, moral ve sadakat desteği mevcut önleme araçlarıdır. Gizli suç/özellik, ad veya grup hedef puanı değildir.

## Denge kararı ve formüller

İlk sayısal varsayım: kesintisiz ağır kriz başına en fazla3 kişi, sadakat30, moral35, kişi başına asayiş riski+12 (tavan100). Adaylar düşük sadakat, düşük moral, sonra ID sırasıyla seçilir; RNG çekilmez. Aday yoksa dönem hakkı tüketilmez, sonraki gecede risk eşiğine gelen levent ayrılabilir. Firar gerçekleşince yeni dalga için krizsiz bir gece gözlenmelidir. Aynı gece, kayıt yüklemesi, kriz sebebi değişmesi veya yeni levent kabulü tekrar dalga üretmez. Terminal köy değişmez.
Bu dört denge düğmesi `data/koy/levent_firari.json` içindedir. Ayrılan sayısı `n = min(azami_firar, uygun aday sayısı)`; yeni risk `min(100, eski risk + n × asayis_kaybi)`. Güvenlik mevcut formüldür: `clamp(100 − risk + canlı savunma hazırlığı − dış görev kaybı, 0, 100)`.

Kişi mevcut nüfustan kaldırılır, taktik görev temizlenir; mevcut model yenilemesi onu sahneden kaldırır. İş/ev kapasitesi, asker sayısı, savunma gücü, etkin nöbet, vergi ve sonraki bordro gerçek nüfustan türetilir. Önceki bordro tarihsel makbuzu korunur, ayrılana sonraki maaş/borç yazılmaz. Asayiş riski mevcut Güvenliği düşürür; HAR-15 kişinin canlı hazırlık katkısı da kalkar. Ek Güvenlik cezası kaydı tutulmaz. Boş köyde mevcut emniyet/son kuralları geçerlidir.

Eski rastgele moral isyanı firarı korunur; helper kalan adayları değerlendirir. Aynı gece eski isyan firarı ve yeni en fazla3 levent ayrı olaylar olabilir. KRI-06 tetik gecesinin eski rastgele firar/RNG kilidi korunur, yeni levent dalgası deterministiktir. Yeni firar erzak çalmaz, yağmayı yinelemez, sürgün husumeti/adalet/vicdan cezası üretmez. Ölüm/cenaze değildir; önceki tüketim, üretim ve bordro geri alınmaz.

## Kayıt ve sunum

Optional `levent_firari`: `son_gece`, `kriz`, `firar_edildi`. `KAYIT_SURUMU` değişmez. Legacy kayıtta geçmiş uydurulmaz; bozuk tip, kesir, NaN/Inf, geçersiz bileşim ve gelecek tarih reddedilir. JSON/GuvenliKayit aynı sonraki gerçek geceyi üretir.

Mevcut gece raporu isimleri, açık kriz sebebini, Güvenlik önce/sonra değerlerini ve gerçekten eklenen asayiş riskini gösterir. HUD asayiş/nüfus ve kapı/kervan Güvenlik göstergeleri ortak değeri okur. Asset gerekmedi; envanter G kontrol edildi, yeni görsel/ses/model/animasyon ihtiyacı yok. Yeni panel/CSV/hareket rutini eklenmez.

## Bağımlılıklar

KoyYonetimi gerçek gece/nüfus, Koylu meslek/sadakat, KitlikIsyani, KuyuKirliligi ve SaglikYoneticisi açık krizleri; MuhafizMaasi borcu/nöbeti, DivanHukmu, KarantinaYoneticisi ve KervanKorumasi uygunluk sınırlarını sağlar. SavunmaKonuslanmasi/HAR-15 yaşayan kişiden görev katkısını, IflasYoneticisi olay adaptörü mevcut rapor metnini sağlar. Yeni mimari kurulmaz.

## Doğrulama ve yayın

`tests/unit/kvr/levent_firari_test.gd`: sıralama/tavan/eşik, korunan kişiler, dört kriz, gizli enfeksiyon, terminal/boş köy, dönem/aynı gece kilidi, JSON/legacy/bozuk kayıt, gerçek gece/RNG, nöbet/savunma ve kasa/ambar/husumet.

`tests/oto/levent_firari_kontrol.tscn`: gerçek Ana → köy → gece düğmesi → rapor → sabah, model/HUD, iki güvenli kayıt, restore ile aynı gece, aynı krizde ikinci dalga olmaması ve ayrılana yeni maaş yok. Birim otomatik keşifte, gerçek sahne sanity listesinde.

Git yasağı ve yeni kaynakların da denetlenmesi için açılış kaynak kontrolünün `--filesystem` seçeneği tam sanity'de kullanılır. Korumalı API denetimi git yerine `tools/api_sozlesmesi_baseline.json` imza manifestini okur; manifest dört değiştirilmemiş çekirdek dosyanın API sözleşmesidir. Boş satırla başlayan const/var bildiriminin körlüğü regresyonla kapatıldı. Git kullanan eski bağımsız denetim seçenekleri korunur, bu görevde çağrılmaz. Windows Python3.13 test fixture klasörleri çalışma alanının ACL'ini devralır; yalnız test koşucusu tempfile fabrikasını geçici değiştirir. Üretim kayıt/tempfile davranışı değişmez. Yayın/ayna döngü betiğinin sorumluluğunda, Claude test/onayı beklenir.
