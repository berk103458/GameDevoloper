# KRI-01 — Veba ve Humma Bulaşma Motoru

KRI-03 hekim/ilaç uzantısı: [Hekim yetkinliği ve ilaç üretimi](hekim-ilac.md).
KRI-04 su kaynaklı tifo uzantısı: [Kuyu kirlenmesi ve kireçleme](kuyu-kirliligi.md). Tifo aynı enfeksiyon/hasar/tedavi motorunu kullanır; kişiler arasında bulaşmaz. Temas ve su vakaları gecelik iki yeni vaka sınırını paylaşır.
KRI-05 ölüm/yas uzantısı: [Toplu mezar ve cenaze töreni](cenaze-yasi.md). Salgın töreni yaşayan katılımcılara mevcut temas kapısıyla ortak temas ekler; üç temas/iki yeni vaka, karantina ve aynı RNG korunur. Ölü kaynak ve ikinci bulaşma sistemi yoktur.

**Durum:** Uygulandı (Codex başlattı, limit dolunca Claude tamamladı) · 9 Ekim 2026
**Dosya:** `src/koy/saglik_yoneticisi.gd` (`SaglikYoneticisi`)

## Amaç
Kapıdan kabul edilen hasta sığınmacının köye gizli bir bulaşma getirmesi; oyuncunun kabul kararının gecikmeli bedeli.

## Kurallar
- **Kaynak:** Kabulde Gelen bayrakları (`veba`, `humma`, CHR_002 dışı `hasta`) gizli `enfeksiyon` kaydı açar. Hikâye metni/hekimin sargısı enfeksiyon sayılmaz.
- **Kuluçka:** Kayıt gizli başlar; ilk gecede belirti (`hasta` bayrağı) açılır. Kartta yalnız açık belirti gösterilir.
- **Bulaşma:** Her gece, ortak *hazır* bina (ev veya iş yeri) paylaşanlar arasında; kaynak başına en çok **3 temas**, köy başına gece en çok **2 yeni vaka**. Risk: veba %30, humma %20. Aynı gece yeni hasta zincirleme kaynak olamaz.
- **RNG:** Yalnız mevcut yönetim RNG'si; enfeksiyon yoksa RNG çekilmez; kayıt/yükleme sonrası birebir aynı sonuç.
- **Hasar:** Ev iyileşmesinden sonra gece başına veba −12, humma −8 sağlık; ölüm mevcut tek ölüm taramasında.
- **İyileşme:** Süre sonunda (veba 6, humma 4 gün) doğal; ya da Şifahane boş kontenjanı + 2 erzak ile (yanık/kış hastalığıyla aynı kontenjan, ikinci Şifahane yok).
- **Hariç:** Zindandakiler ve kervan korumasındakiler temas etmez.
- **Kayıt:** `Koylu.enfeksiyon` ve yönetim `salgin_son_gece` optional; legacy/bozuk kayıt hastalık üretmez.

## KRI-02/03 için açık API
`enfekte()`, `iyilestir()`, `temas_edebilir()` (karantina buraya bağlanır), `tedavi()` (hekim yetkinliği buraya bağlanır).

## Doğrulama
`tests/unit/kvr/saglik_yoneticisi_test.gd`, `tests/oto/saglik_salgini_kontrol.tscn` (kapı → çadır → gece düğmesi → kart → kayıt). Asset gerekmedi.

## KRI-02 — Şifahane karantinası (Codex uygulaması; Claude incelemesi bekleniyor)

Karantina mevcut **Şifahane binasının hizmetidir**. İkinci bina, yeni koğuş türü, hastalık teşhisi veya RNG motoru eklenmez. Oyuncu köylü kartındaki **“Şüpheyle 2 gün karantinaya al” / “Karantinadan çıkar”** düğmesini kullanır. Sağlıklı şüpheli, açık belirtili ve gizli kuluçkadaki köylü aynı kabul koşullarına sahiptir. Karar gizli `enfeksiyon`/bayrakları okumaz; yeni hasta bayrağı oluşturmaz. Gizli kuluçka kartta hastalık adıyla açıklanmaz.

- **Süre:** Giriş günü D ise D ve D+1 gecelerinde izole kalır; ikinci gecenin sonunda gün D+2 olduğunda otomatik çıkar. Bulaşma ve üretim işlemlerinden **sonra** çıkış yapılır. Erken çıkış hemen teması açar. Süre eklenmez; tekrar giriş atomik reddedilir. Çıkıştan sonraki gecede doğal bulaşma ve normal iş yeniden mümkündür.
- **Temas:** İki yönde yalnız `SaglikYoneticisi.temas_edebilir()` üzerinden kapanır: izole kişi bulaştırmaz/bulaşmaz, ev/iş yuvasını paylaşması temas sayılmaz. Karantina iyileştirme değildir; doğal hastalık süresi ve sağlık hasarı devam eder. Bulaşıcı hastalığın mevcut Şifahane tedavisi izolasyon sırasında uygulanmaz. Yanık/kış tedavisi kendi mevcut yolunu korur.
- **Kontenjan:** Hazır, isyan/kan davası engeli olmayan ve en az bir uygun, çalışabilir cerrah/otacısı bulunan Şifahane başına `min(4, BinaSeviyesi.kapasite(2, seviye))`: seviye1=2, seviye2–3=3, seviye4+=4. Aynı hekim uygunluğu tedavide de kullanılır. Bu **yer kapasitesidir**; yanık/kış/salgının ortak günlük tedavi makbuzunu ikinci kez tüketmez. Birden çok mevcut Şifahane varsa kimliğe göre ilk boş yer seçilir; dolu yataklar bina bazında sayılır. KRI-13 triyajı kapsam dışıdır.
- **İşlerlik azalınca:** Yeni kabul durur; mevcut kişiler süreyi tamamlar, zorla dışarı çıkarılmaz. Seviye düşerse doluluk boşluk hesabını sıfıra sınırlar. Bina yoksa/hazır değilse, kişi ölmüşse/zindana alınmışsa/dış göreve geçmişse geçersiz kayıt gece sınırında veya yüklemede temizlenir; hayalet izolasyon kalmaz.
- **Bedel:** Başarılı girişte bir kez **1 erzak ve yalnız kişinin moralinde −2** (0'a sınırlı). Günlük ek gider yok; mevcut nüfus tüketimi sürer. Erken çıkış iade yapmaz, yeniden giriş yeni karar/bedeldir. Dolu/yetersiz kaynak/bayat kart/eksik kişi/bitmiş oturum reddi kaynak, süre, moral veya RNG değiştirmez.
- **İş/ev:** `is_yeri`, `ev` ve iş yuvası rezervasyonu korunur. İzole kişi üretim, danışmanlık/eğitim, inşaat yardımı, Şifahane hekimliği, Gözcü, etkin savunma/nöbet ve kervan kiralamasına katılmaz. Atama/boşaltma ve mevsim kaydırması bekler; dönüşte normal kurallar işler. Çalışılmayan nöbete yeni maaş/borç yazılmaz, önceki borç silinmez. Evsiz köylü izolasyonda yeni eve atanmaz; mevcut evin normal koruma/tüketim kuralları korunur. İşyerindeki kan davasına ve gece ambar hırsızlığına katılmaz. Mevcut bina yıkımı atamayı geçersiz kılarsa eski bina yeniden yaratılmaz.
- **Görsel:** Aynı figür mevcut Şifahane durağına gider; iş/devriye/sinsi rutin ve eldeki iş nesnesi kapatılır. Kart kalan günü ve temassızlığı açıklar. Yeni görsel, ses, model ve animasyon gerekmedi; mevcut bina/figür/yüzey kullanılır, asset envanterinde yeni ihtiyaç yok.
- **Kayıt:** Köylünün optional `karantina = {baslangic, bitis, bina}` sözlüğü. Yalnız sonlu tam sayılar, pozitif bina kimliği ve tam iki günlük süre kabul edilir; yönetim yüklemesi gün/bina bağlamını doğrular. Eksik/bozuk/gelecek/süresi geçmiş/olmayan bina kaydı etkisizdir; kayıt sürümü değişmez. Gizli hastalık yaratılmaz, ücret yeniden alınmaz. Aynı kayıt ve RNG ile iki gece raporu/mekanik durum eşittir.

Yeni dosyalar: `src/koy/karantina_yoneticisi.gd`, `src/arayuz/koy_hud/karantina_paneli.gd`, `src/koy/gorsel/karantina_rutini.gd`. Birim: `tests/unit/kvr/karantina_yoneticisi_test.gd`; gerçek otomasyon: `tests/oto/karantina_kontrol.tscn` (kart giriş/erken çıkış/dolu kart → gece düğmesi → rapor/sabah → bulaşma engeli → ikinci sabah dönüş → gerçek üretim → GuvenliKayit). Aktif ve bitmiş süre ayrı kayıt turuyla doğrulanır. Birim otomatik keşifte, sahne `tools/sanity_check.py` listesinde. ROADMAP `[/] (Codex)` kalır; kapanış, commit ve push Claude'un sonraki incelemesindedir.
