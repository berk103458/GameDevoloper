# Kapıda hastalık teşhis ibresi — KRI-11

## Overview
Kapıdaki açık fiziksel belirtiler incelendiğinde ziyaretin `IpucuYoneticisi` servisine sağlık ipucu kaydedilir. İbre enfeksiyon şüphesi bildirir; kesin hastalık veya suç teşhisi yapmaz. Şüpheli ziyaretçiyi içeri almak mevcut Şifahane karantinasını gerektirir.

## Player Fantasy
Muhafız yüzü ve yükü dikkatle inceler, hastalık şüphesini görür ve yerleşmeden önce güvenli izolasyon sağlar. Şifacıların sargısını, yaralıların kanını veya yabancı kimliğini hastalıkla karıştırmaz.

## Detailed Rules
- Kaynak `data/kapi_hastalik_teshisi.json` içindeki açık belirti bayraklarıdır. `belirti_irin` ve `belirti_ates` yüz incelemesinde; `belirti_kanli_oksuruk` heybedeki öksürük bezinde görülür. Açık `veba`, `humma`, `hasta` mevcut sağlık kabul API'siyle uyumlu alternatiflerdir. CHR_002'nin eski `hasta` etiketi bulaşıcı değildir. Kimliği gizli bir hastalığı açığa çıkarmak için kullanmak yasaktır.
- Gizli bayraklar, portre dosya adı, serbest hikâye/obje metnindeki sözcükler ve başka karakterin nişan kanıtı okunmaz. Mevcut CHR kaynakları bulaşıcı semptom tanımlamıyor; sargı, yara ve hasta yakını anlatısı bu paketle semptom kazanmaz. Yeni gerçek semptom içeriği bu açık veri sözleşmesine bağlanmalıdır; rastgele hasta üretimi eklenmez.
- Her yüzey aynı ziyaret servisinde tek `Clue_Enfeksiyon_*` kaydı üretir. CHR'de mevcut servis/sinyal kullanılır; adsız ziyaretin servis kapsamı yalnız o `Gelen` örneğidir. İbre metni yüz düğmesi sonucunda, heybe/CHR panelinde görünür. İnceleme diyalog, tansiyon, RNG, gizli kimlik veya sağlık durumunu değiştirmez.
- Açık semptom varsa kabulden önce en az bir sağlık ipucu keşfedilmelidir. `kabul`, `harc`, `rusvet`, `kisla` aynı model ve UI kilidinden geçer. Ret/elkoy özgürdür. Heyet ve ticari ziyaretçi mevcut kendi karar API'sini sürdürür.
- Şüpheli kabul: mevcut hazır/işler Şifahane, uygun çalışan hekim, boş karantina yatağı ve 1 erzak gerektirir. Kabul normal bar/kasa/işlem etkilerini korur; hemen KRI-02 izolasyonu başlar (2 gün, kişisel moral −2). Şüphe tek başına enfeksiyon oluşturmaz. Gerçek hastalık KRI-01 kabulüyle taşınır.
- Kilit karar uygulanmadan denetlenir. Eksik kaynak, yatak, hekim, isyan, terminal veya tamamlanmış şüpheli ziyaret yeni kişi, akçe, eşya, eğitim, karar sayacı veya ücret üretmez. Her UI onayı güncel model koşulunu yeniden denetler. Başarılı şüpheli ziyarette tekrar kabul engellenir.
- Normal kayıt mevcut köylünün `karantina`/`enfeksiyon` alanlarını kullanır. Debug kapı snapshotında adsız sağlık ipucu optional alan olarak devam eder; CHR servisi mevcut snapshotta sürer. Eski snapshot keşif sayılmaz; bozuk/yabancı/uyuşmayan sağlık Clue'ları elenir.

## Formulas
`şüphe = keşfedilen ve halen açık belirti profiline uyan sağlık Clue sayısı > 0`. İbre ikili ve deterministiktir; olasılıkla kesin teşhis verilmez. Bedel/süre/kapasite hesapları KRI-02'nin tek `KarantinaYoneticisi` API'sindedir; burada ikinci katsayı veya yatak hesabı yoktur.

## Edge Cases
Gizli kuluçka sağlıklı kişiyle aynı inceleme ve karar metnini verir. Sağlıklı ateş/irin şüphesiyle izolasyon mümkündür, hastalık yaratılmaz. Hekim hizmeti durduğunda mevcut izolasyon korunur, yeni kabul kapanır. Yataksız ve erzaksız ret mümkündür. Heybesi olmayan kişide tek yüz/belirti düğmesi iki yüzeyi inceler; inceleme zorunluluğunda kilitlenme olmaz. CHR panik kilidi teşhisle açılmaz. Bayat onay ve çift tık nüfus/bedel çoğaltmaz.

## Dependencies
`Gelen`, `IpucuYoneticisi`, `ChrSorgusu`, `KapiEkrani`, mevcut heybe/CHR inceleme paneli, `Oturum.karar_ver`, KRI-01 `SaglikYoneticisi`, KRI-02 `KarantinaYoneticisi`, `KapiAnlikGoruntusu`, `GuvenliKayit`. Yeni autoload, global class, CSV değişikliği veya rutin yok. Yeni görsel/ses/model/animasyon gerekmedi; mevcut Button/Label ve inceleme portresi kullanılır, asset gerekmedi.

## Tuning Knobs
Belirti → inceleme yüzeyi → Clue → metin ve bulaşıcı olmayan eski hasta kimlikleri dış JSON'dadır. Karantina dengesi KRI-02'den devralınır. Belirti eklemek gerçek kaynak veri kararıdır; serbest metinden çıkarılmaz.

## Acceptance Criteria
Üç semptom/yüzey, idempotent kayıt ve CHR sinyali, gizli kuluçka/şifacı/deri etiketi, tüm kabul kararları ve atomik kilit, dolu/yataksız/hekim yok/erzak yok/isyan/terminal, sağlıklı şüphe ve gerçek enfeksiyon, çift kabul, optional debug snapshot ve normal kayıt birim testlerinde doğrulanır. Gerçek kapı yüz/heybe/CHR düğmeleri ve iki basışlı karar, sonuç metni, temas engeli, güvenli kayıttan devam otomasyon sahnesinde doğrulanır; tam sanity ve 20 gece hatasız geçer.
