# Çınar altı köy meclisi — KRI-07

KRI-08 genişletmesi: aktif batıl inanç histerisi güven puanını seviye×8 azaltır; mağdur ve aynı açık toplumsal gruptaki seçmenler bu cezadan muaftır. Mevcut seçenek listesi, anonim oy kaydı ve önceden verilmiş oylar değişmez; meclise sürgün oyu eklenmez. Ayrıntı: [Batıl inanç histerisi](batil-inanc-histerisi.md).

Uygulama: Codex; proje yöneticisi ve kapanış incelemesi: Claude Code. ROADMAP mevcut `[/]` işaretinde kalır.

Köy HUD'undaki **Çınar altı meclisi** düğmesi aktif krizleri ve son meclisin sonucunu açar. Ayrı olay/RNG kuyruğu yoktur: OlayVerisi, Oturum.olay_sec ve mevcut gece olay kartları aynı davranışı korur. Açık rapor/olay/gece geçişinde meclis düğmesi kilitlidir. Oy sonuç kartı mevcut KoyEkrani kart yardımcılarını kullanır; HUD'dan yüklenen panel yalnız Node ile çalışır, KoyEkrani veya Ses autoload'una statik bağımlılık kurmaz.

| Kriz | Somut seçenekler | Uygulama API'si |
|---|---|---|
| Kıtlık kaynaklı aktif isyan | Ambarı aç/aş dağıt; bu hafta vergiyi kaldır | KoyYonetimi.as_dagit / vergi_sifirla |
| Açılmış salgın belirtileri | Karantinayı genişlet; aş dağıt | KarantinaYoneticisi.al / as_dagit |
| Kirli kuyu | 2 kireçle dezenfeksiyon; aş dağıt | KuyuKirliligi.kirecle / as_dagit |
| Aktif yas, cenaze kararı bekliyor | Cenaze töreni; ücretsiz toplu mezar; aş dağıt | CenazeYasi.sec / as_dagit |
| Aktif yas, cenaze kararı verilmiş | Anma için aş dağıt; bu hafta vergiyi kaldır | as_dagit / vergi_sifirla |

KRI-05'in rapor içindeki zorunlu cenaze kararı korunur. Normal oyun önce cenaze kararını tamamlar; devam eden yasın meclisi iki destek seçeneği sunar. Üç seçenekli bekleyen cenaze bağlamı model API'sinde desteklenir; meclis bir kez verilmiş cenaze kararını değiştirmez. Meclis için ayrı ağaç/model/ses gerekmedi; mevcut HUD, Button ve Label yeterlidir. Asset üretilmedi veya indirilmedi.

Oylar deterministiktir. Sağ yaşayan yetişkin ve yaşlılar katılır; çocuk, zindan ve dış görev hariçtir. Karantinadaki seçmen temsil yoluyla oy verir; meclis temas/bulaşma veya iş ataması yaratmaz. Kimlik, gizli_bayraklar, gizli_egilim, gizli enfeksiyon veya fail okunmaz. Salgın çağrısı ve etkilenme puanı yalnız mevcut açık `hasta` belirtisini kullanır. KanDavasi.toplumsal_bag alanı grup adı üzerinden imtiyaz vermeden aynı gruptaki açık açlık ve hastalık dayanışmasını hesaplar. Düşmanlık, kan davası üretim engeli ve adli kanıtlar aynen korunur.

İlk denge formülü (pozitif tam bölmeler aşağı yuvarlanır): ihtiyaç = (100−moral)/5; güven = sadakat/10 + adalet/20. Aynı gruptaki aç kişi başına 4, tavan12 dayanışma; belirtili kişi başına4, tavan12 sağlık dayanışması. Grup boşsa dayanışma0. Aş puanı12+ ihtiyaç + açsa25 + açlık dayanışması; vergi16+(100−sadakat)/5+ihtiyaç/2; karantina12+güven+belirtiliyse20+sağlık dayanışması; kireç26+güven+sağlık<70 ise10+sağlık dayanışması; tören20+güven+ihtiyaç+yas için6; toplu mezar12+(100−sadakat)/10+açsa18. Her seçmen en yüksek puanlı tek seçeneğe oy verir; eşitlikte listedeki ilk seçenek. En çok toplam oy kazanır, eşitlikte yine ilk seçenek. Köylü dizisi sırası veya RNG bu sonucu değiştirmez. Oy dağılımı toplam ve yuvarlanmış yüzde olarak gösterilir; bireysel tercihler/gruplar/kimlikler saklanmaz veya gösterilmez.

Her kriz döneminde tek meclis; tüm krizler arasında2 gün bekleme. Kesintisiz salgında kaynak kişinin/vaka sayısının değişmesi yeni dönem değildir. Kuyu/yas başlangıç günü değişmesi veya kapanıp yeniden başlayan kriz yeni dönemdir. KRI-06 erzak gelişi kıtlık sayacını sıfırlar; meclisin izlediği kıtlık kaynaklı isyan, mevcut isyan bitene kadar sürer. Böylece halk aş seçtiyse oyuncu erzak tedarik edip kararı uygulayabilir. Genel moral isyanı kendiliğinden kıtlık meclisi açmaz.

Oylama, mevcut stoktan bağımsız tercihi kaydeder. Başlangıç kartı gereklilikleri gösterir; seçilen kararın bedeli ve uygunluğu uygulama anında yeniden doğrulanır. Eksik kaynakta bedel, ödül, ret cezası veya karar makbuzu üretilmez. Karantinada mevcut boş yatak ve erzak kadar açık belirtili aday küçük ID sırasıyla seçilir; çalışan Şifahane hekimi seçilmez, aynı işlem içinde kontenjan kapanmaz. Yeni kontenjan, ikinci sağlık sistemi veya gizli hasta seçimi yoktur.

Halkın kararı uygulanırsa mevcut API'nin etkisine ek olarak tüm mevcut köylülerde sadakat+4 ve moral+3 (tavan100). Muhafız kararıyla reddedilirse adalet−5 ve sadakat−6 (taban0); kriz seçeneği/bedeli uygulanmaz. Karar kimliği `(gun, tur, sira)` ve tek makbuz çift tık/bayat çağrıyı engeller. Karar en fazla2 gün bekler; kriz kapanır, dönem değişir veya oyun biterse karara ek etki verilmez. UI bekleyen kararı tamamlamadan geceye geçmez; doğrudan model/debug gün ilerlemesi süreyi doldurabilir. Sonuç kartından köye dönülürse HUD'dan aynı karar yeniden açılır.

Kayıt `cinar_alti_meclisi` optional alanındadır; KAYIT_SURUMU değişmez. Dört sınırlı dönem izi, son gün ve yalnız son anonim oylama/makbuz saklanır. Legacy/null/bozuk/gelecek kayıt güvenli varsayılana iner. Sayılar, seçenek listesi, oy toplamı, kazanan, dönem ve karar durumları doğrulanır. Pending yükleme gerçek köyde sonucu yeniden açar; kayıt yükleme bedel/ödül/ceza uygulamaz.

Doğrulama: `tests/unit/kvr/cinar_alti_meclisi_test.gd`; `tests/oto/cinar_alti_meclisi_kontrol.tscn` sanity listesindedir. Birim dört kriz, oy/gizlilik/RNG, API bedelleri, seçim kilidi, legacy/bozuk kayıt, süre/yeni dönem ve izolasyon sınırlarını kapsar. Gerçek akış debug kuyu → HUD → oy → pending GuvenliKayit yükleme → uygulama/ret; gerçek iki açlık gecesi → kıtlık → meclis → erzak tedariki → aş dağıtımını kapsar. Test işareti GEÇTİ olsa bile SCRIPT ERROR/Parse Error başarısızlıktır.
