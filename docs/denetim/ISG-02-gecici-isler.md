# ISG-02 — Geçici işler (Kalfa)

Durum: tamamlandı (Kalfa). Uygulama commit’i 54ac3789; yalnız commitli dosyalardan oluşturulan, başlangıçta .godot içermeyen kabul kopyasında import/parse, gerçek ana menü ve canlı iş kartı doğrulandı.

Dokuz iş `data/gecici_isler.json` içindedir; verim %50 ve iş başına çıktı/yorgunluk seçimleri buradan okunur. Kişide yalnız iş kimliği, atama gecesi ve son gece makbuzu saklanır; havuz veya sıra kayda gömülmez. Aynı gece ikinci iş yok. Bina/nöbet ataması geçici işi bırakır; yıkılan binanın işçisi boşta kalır, kendiliğinden iş seçilmez.

Kararlar: taş mevcut TasYatagi üretiminden geçer, yeni ocak açılmaz. Yol/hendek ve inşaat yardımı mevcut `_insaat` hesabına katkıdır, kendiliğinden yol/bina kurmaz. Su mevcut ambara yazılır, ANI-03 yeniden kurulmaz. Ot/mantar yalnız erzak yazar, afyon yazmaz. Yün işi yaşayan ağıl sürüsü ve hazır ev ister; iplik için yeni stok türü açılmaz, mevcut `kumas` tekstil kaynağı kullanılır. Uygun kadın kimlikleri CHR_002/008/012/015/017/018 kaynak dosyalarının açık Tag_Array bilgisinden gelir; yaşlılar da uygundur, isimden cinsiyet çıkarılmaz. Bakım mevcut çocuk/hastanın moraline katkıdır, hastalığı iyileştirmez veya karantina sayacını değiştirmez. Yorgunluk mevcut UZM-14 kaydıdır, ikinci bar/sayaç yoktur.

Kart: mevcut köylü kartında yapı/geçici iş sekmeleri; mevcut KoyluSuruklemeKulpu kaynak, aynı kartın iş satırları hedef. Klavye düğmesi aynı atama yoluna gider. Yeni atama penceresi yok. İş adları CSV anahtarlarından gelir, ham kimlik gösterilmez.

Kontroller: modelde dokuz iş/tek bilanço satırı; çocuk-yaralı-nöbetçi/bina çalışanı retleri; çift iş; tek erzak payı; kış otu sıfır; tükenmiş taş; kişi kaydı; aynı tohum iki gece; gerçek meclis gecesinde geçici iş ve bina üretimi. Canlı kart sürükle-bırak, diğer oturum reddi ve tekrar açmanın salt okunurluğu. Mevcut köylü kartı, atama, köy yönetimi, 55 taş yatağı, 29 nöbet ve yorgunluk regresyonları geçti. API sözleşmesi, filesystem kaynak denetimi, CSV kaynak kontrolü ve son recovery headless import geçti. Loglar `work/isg02_*`.

İlk denemelerde JSON int/float mevsim üyeliği, testte raporun yanlış katmanından okuma ve aktif sürükleme dışı preview çağrısı teşhis edilip düzeltildi. İlk importlarda engine MD5 ve bir CowData iç hata logu korundu; son `isg02_import_kabul_son.log` temiz. Son canlı kart logunda sızıntı yok. Tam sanity/görünür Godot yok.

Asset: özel kürek/kirmen/sepet/su kabı/bakım bezi eksik, ISG02-ALETLER envanteri gerçek duruma ve metre ölçülerine güncellendi. Özel alet henüz bağlanmadı; mevcut figür/kart iş adı kullanılır, ANI-11 entegrasyon noktası korunur. Yeni asset/font/ikon/portre üretilmedi veya indirilmedi.

Söz motoru beklemede. ds yolları bulunmuyor; eşitlenmedi. kota görünmüyor.

## Commitli kaynak kabulü

`work/isg02_kabul_54ac3789` git archive ile kuruldu; başlangıçta .godot yoktu. Arşivin CRLF satır sonları dışında 22 paket dosyası commit ile aynıdır. İlk soğuk import CSV aşamasında Godot erişim ihlaliyle (3221225477) durdu; betik/eksik kaynak hata satırı görülmedi, bu koşu kabul sayılmadı. Aynı kaynak kopyasında import tekrarı temiz bitti (`work/isg02_cold_import_tekrar.log`). `isg02_cold_model.log`, `isg02_cold_kart.log`, `isg02_cold_menu.log` tamamlandı ve başarı işaretleri doğrulandı; son loglarda SCRIPT ERROR/ERROR veya kaynak sızıntısı yok. Özgün çalışma kopyasının .godot önbelleği taşınmadı. İlk çökme logu korunur. Tam sanity çalıştırılmadı.

## Su koşulu regresyonu — 2 Kasım (Kalfa)

ISG-01 incelemesinde `su_tasima` koşulunun gerçek katalogda olmayan `kuyu` türünü istediği görüldü. Önceki model fikstürü bu türü sentetik kurduğu için ilk kabulde kaçmıştı; madde yeniden açıldı. Sentetik yapı kaldırılıp her veri koşulunun en az bir gerçek kurulabilir katalog türüne bağlandığı test edildi ve RED alındı. Su işi mevcut kulübe/çadır yerleşiminden erişilir; kaynak zaten var olan meydan kuyusudur. `SuDengesi.isci_tasidi` aynı günlük akış/rezerv makbuzuna ince adaptördür. İki taşıyıcı kuyunun kalan son bir birimini aşamaz; ikinci kuyu/akış veya elle doldurma akçe bedeli yoktur.

Genişletilmiş model (`work/isg02_su_fix.log`), mevcut su/yaz/yangın testi (`isg02_su_regresyon.log`), gerçek kurulabilir kulübeyle canlı kart (`isg02_su_kart_dugme.log`), API sözleşmesi ve son recovery import (`isg02_su_import_son.log`) geçti. Canlı kartta su hedefi açık ve düğme alternatifi doğru işi atar. İlk soğuk kabulün kapsamı/çökme kaydı yukarıda korunur; bu düzeltme ayrıca hedefli denetlendi. Tam sanity yok.
