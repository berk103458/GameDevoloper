# Ücretsiz asset ekleme — 24 Ekim 2026 (Kalfa)

## Karakter — 24 Ekim 2026 (Cursor)

KAR02 ücretsiz zip yalnız FBX. Demirci ve çocuk Godot 4.7.2 ile glTF'ye çevrildi; yeni geometri üretilmedi. Editörde ikisi de ayakta ve dokulu: demirci 1,80 m, çocuk 1,27 m. T-pozu, oyuna bağlanmadı. Avcı zipte var; karşılık gelen ihtiyaç satırı yok, repoya alınmadı. Ücretli çiftçi, oduncu, yaşlı ve tüccar alınmadı. İHT-0431 ve İHT-0357 uyarlama. İHT-0390 ve İHT-0428 açık.

KAR05, C07 ve C10 bu turda indirilemedi. Ücretsiz sayfa açıldı; imzalı indirme adımı engellendi. Atlandı, dosya eklenmedi.

## Çevre ailesi — 24 Ekim 2026 (Cursor)

Yapı ailesi **E02 Quaternius Medieval Village MegaKit, Standard, 0 USD, CC0**. KayKit Medieval Hexagon ve LOKIT yapıları eklenmedi.

Gece ışığında mevcut `ev.glb` ve `kapi.glb` ile yan yana bakıldı. Ham ölçüler: KayKit ev 0,79 × 0,93 × 0,85 m (altıgen masa parçası), KayKit kapı 2,0 × 1,41 m. MegaKit cephe yaklaşık 5,5 × 5,9 × 5,6 m; ev kapısı 1,12 × 2,33 × 0,26 m. LOKIT ahşap duvar 4,82 × 4,0 × 5,0 m, kapı 1,5 × 2,5 m. MegaKit, 6 × 3 × 5 m ev zarfına uyan yürünebilir modül. KayKit yakın planda oyuncak kale gibi duruyor. LOKIT ücretsiz set ayrı bir low-poly aile; tek doku yolu FBX içinde kırık, yapıları karıştırmadım. Doğa parçası bu dilimde alınmadı.

Oyuna bağlanmadı. Mevcut `ev.glb` ve `kapi.glb` yerinde. MegaKit kapısı 4 m kapı kadrajı değil; İHT-0339 açık. İHT-0372 ve İHT-0397 kısmi modül.

## Animasyon kaynağı — 24 Ekim 2026 (Cursor)

Ana kaynak **A01 Quaternius Universal Animation Library, Standard, 0 USD, CC0**. A02 aynı iskelet ailesinin ikinci ücretsiz kitabıdır ve tarım/kılıç klipleri için ona eklenir. KayKit A03 kitaplıkları duruyor; ana kaynak değil ve ikisi birden karaktere bağlanmadı.

Karşılaştırma `chr_001_yuru.glb` üzerinde, global dinlenme farkıyla, Idle klibinde yapıldı. Editör görüntüsünde KayKit Idle_A omuz silkme gibi kolları yukarı kaldırıyor. UAL Idle_Loop kolları indiriyor, sol ve sağ eller kendi taraflarında kalıyor, ayaklar yerde ama duruş geniş. Bu yüzden UAL daha iyi tutuyor. Tam kabul değil: 44 karaktere bağlanmadı, oyun mantığı değişmedi. Tabanca, büyü, araba, telefon, zombi, ninja ve kayma klipleri alınmadı. A02 ücretsiz katmanda çekiç klibi yok; İHT-0453 KayKit Hammering kaydında kalıyor. İHT-0452 orak değil, hasat/tohum/sulama uyarlaması.

Butler `C:\Users\Ahmet\bin\butler.exe` v15.32.0. Ücretsiz yol: itch sayfasında “No thanks, just take me to the downloads”, sonra yalnız Standard.zip. Ham ZIP TEMP’te.

## Kalfa kaydı

Festive pull güncel (75ae24b). İlk öncelik A03 tamamlanan **tedarik dilimi**: 1 ücretsiz CC0 paket, 6 Godot AnimationLibrary, 9 özgün klip, 8 ihtiyaca kısmi/uyarlama katkısı; **oyunda tamamen kapanan ihtiyaç 0**. Diğer paketler henüz denenmedi; engellendi diye gösterilmedi.

## Dosyalar ve kapsam

| Dosya (`assets/animasyon/kaykit/`) | Seçilen klip | İhtiyaç | Durum |
|---|---|---|---|
| general.res | Idle_A, Idle_B, Death_A | İHT-0444, İHT-0456 | eklendi — uyarlama (Kalfa) |
| movement_basic.res | Walking_A, Running_A | İHT-0524, İHT-0450 | eklendi — uyarlama (Kalfa) |
| movement_advanced.res | Sneaking | İHT-0399 | eklendi — kısmi; kuytu bekleme açık (Kalfa) |
| tools.res | Hammering | İHT-0453 | eklendi — uyarlama (Kalfa) |
| combat_melee.res | Melee_1H_Attack_Chop | İHT-0455 | eklendi — uyarlama (Kalfa); yedek, ana kaynak A01 |
| simulation.res | Sit_Chair_Idle | İHT-0451 | eklendi — kısmi; otur/kalk geçişleri açık (Kalfa); yedek, ana kaynak A01 |

Kaynak GLB'leri ve 14,9 MB ham ZIP yalnız Windows TEMP altında. Yaklaşık 285 KB kitaplık, özgün lisans ve dosya bazında SHA-256/kaynak/yazar/indirme tarihi teslim kaydında. Bunlar mevcut Godot kaynaklarının seçilerek dönüştürülmesidir; yeni hareket üretilmedi. Yeni 2D, font, VFX, Quaternius ve ücretli dosya yok.

## Retarget deneyi ve kabul sınırı

Godot 4.7.2 GLTFDocument ile özgün rig ve gerçek `assets/model/karakter/chr_001_yuru.glb` yüklendi. Idle_A kopyasının izleri ad eşleme tablosuyla gerçek hedef Skeleton3D yoluna çevrildi: **19/21 iz (%90,48)** çözüldü; `handslot.r` ve `handslot.l` karşılıksız. Mevcut %80 iz eşiği sayısal olarak aşılır. **Bu sonuç poz/omuz/bilek, dinlenme pozu ve gövde oranı uyumu kabulü değildir.** KayKit'in 23 kemikli hiyerarşisi ile Meshy'nin 24 kemikli hiyerarşisi farklıdır; gerçek retarget için dinlenme pozu dönüşümleri ve görsel hareket kabulü gerekir. Sadece iz adlarını değiştirerek mevcut oynatıcıya bağlamak güvenilir kabul edilmedi; deney kopyası kaydedilmedi. 44 karakterin tümünde çalışır denmedi. Geçerli mevcut hareketler korunur.

Kaynaklar yalnız animasyon kitaplığı olduğundan görünür geometri, malzeme, pivot ve metre ölçeği değiştirilmedi; mankenler oyuna eklenmedi. Hedef rig ölçeği aynen korunur. Net, kabul edilmiş yer tutucu eşleşmesi bulunmadığı için oyun mantığı veya sahne bağlantısı değiştirilmedi. ROADMAP maddesi kapatılmadı.

## Sıradaki dilimler

KAR02 ücretsiz Blacksmith/Hunter/Child ve KAR05 ücretsiz üç kadın; sonra ESY01–04, çevre, hayvan, ses. Bunlar **bekliyor**, indirme engeli tespit edilmedi. HYV08 gibi döneme uygun eşleşme vermeyen içerik zorlanmayacak. Kullanıcının hariç tuttuğu kaynaklar ve ücretli katmanlar alınmayacak.

### Bekleyen kapsamın açık kaydı

- Karakter: KAR02 **yalnız ücretsiz** Blacksmith/Hunter/Child; KAR05 **yalnız ücretsiz** üç kadın.
- Eşya: ESY01, ESY02, ESY03, ESY04 (yalnız tarihî silahlar).
- Çevre: CEV01, CEV02, CEV03, CEV06, CEV12, CEV14, E04, E05 (modern parçalar hariç), E08.
- Hayvan: HYV03, HYV02 (zürafa vb. hariç), HYV08 (yalnız uygun türler).
- Ses: S01, S02, S04, S05, S07, ORT14, FOL11, FOL14, UIS03, UIS08, UIS09, UIS11, MIR01, MIR02, MIR03, MIR04.
- Bu dilimde bu kaynakların hiçbiri için indirme denemesi yapılmadı; **engellenen paket yok**. Yalnız A03 edinildi.
- Son Ahmet/Muharrir düzeltmesi: **Quaternius ücretsiz sürümleri ve VFX01/04/13/14/15 artık izinli**; bu ilk dilimde henüz indirilmedi. VFX yalnız duman, kar, yağmur, kıvılcım, ateş ve meşale ışığı; diğer UI/ikon/çerçeve/imleç/portre/harita ve yeni fontlar kapsam dışı. Ücretli Source/Extra/Pro katmanları alınmayacak.
- Quaternius kuyruğu: E02, E03, E06, E07, A01, A02, C02, C01, C03, C04, C05, C08, C09, CEV10, CEV11. Her paketin edinim anındaki özgün **CC0 veya QAL v1.0 metni ve tarihi** ayrı saklanacak. Repo içi ekip kullanımı onaylandı; dışarı dağıtım planlanmıyor.
- **Ana animasyon kaynağı henüz seçilmedi.** A03 ile A01/A02 gerçek mevcut iskelet üzerinde karşılaştırılacak; yalnız en iyi tutan aile ana kaynak olacak. Mevcut A03 kitaplıkları karşılaştırma adayıdır, aktif oyuna bağlanmadı.
- Çevre ediniminden önce E02 Medieval Village MegaKit ile KayKit/LOKIT karşılaştırılıp tek görsel aile seçilecek ve gerekçesi yazılacak; aynı ihtiyaca körlemesine çift alım ve karışık stil yok. Önceden depoda bulunan kaynaklara dokunulmadı.

## Doğrulama

- Kaynak GLB yükleme, dokuz seçili klibin süre/iz varlığı, altı `.res` kayıt: geçti.
- Retarget deneyi: 19/21 ad eşleşmesi; görsel kabul bekliyor, oyun bağlantısı yok.
- Tek tam sanity, başka yerel değişiklikleri içermeyen 75ae24b tabanlı ayrı TEMP proje kopyasında çalıştı. **Ahmet’in son talimatıyla durduruldu; tamamlandı/geçti denmez.** Durdurma öncesi 313 kontrol logu oluştu; temiz import ve 186 Python testi (1 atlanan) geçti. İlk teslimin hedefli 6 kitaplık/9 klip denetimi geçti.

[Dosya bazında kaynak ve deney çıktısı](UCRETSIZ_ASSET_TESLIM_2026-10-24.json) · [Atıflar](../credits/HAZIR_ASSET_ATIFLARI.md)
