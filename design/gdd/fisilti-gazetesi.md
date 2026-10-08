# İmzasız pusula / Fısıltı gazetesi — CAS-09

## Overview
Sabah mevcut gece raporu ve olay kartında tek imzasız şüphe pusulası; söylenti gerçek suç kanıtı değildir.

## Player Fantasy
Köyün dolaşan sözlerini dinleyip hüküm vermeden kanıt beklemek veya söylentiyi reddetmek.

## Detailed Rules
İlk gece ve her üç gece aralığında, önceki pusula çözülmüşse yeni iddia gelir. Yaşayan çocuk olmayan, zindanda/dış görevde olmayan mevcut nüfustan halka açık kişi adı seçilir. Gizli CHR kimliği, kaynak sır/Clue, niyet veya gözlenmemiş fiil seçim kaynağı değildir. Ad/yaş/nüfus dışında suç bağlantısı kurulmaz. İddia metni tırnak içinde ve söylenti etiketiyle gösterilir.

Mevcut olay kartında arşivle/kanıt bekle veya reddet seçimi, yalnız pusulanın seçim makbuzunu yazar. Suç bayrağı/itiraf/divan adayı, para/stat/stok/RNG etkisi yok. Gerçek taşkın/suçüstü kartı önceliklidir; genel rastgele olaydan önce pusula. Çözülmemiş pusula yeni gecede ezilmez. CAS10 haksız yargı yolu ayrı açık madde; bu paket mahkûmiyet kaynağı kurmaz.

## Formulas
gün mod aralık_gece=0; kişi indeks=(gün/aralık) mod uygun_nüfus; metin indeks aynı bölüm mod metin_sayısı. Sıralama kişi kimliğidir. Denge varsayımı aralık3; mevcut ana ve gece RNG akışını yeni pusula zarıyla değiştirmez.

## Edge Cases
Nüfus yoksa uydurma isim yok. Yaşlı kişi de söylentiye konu olabilir; çocuk hariç. Ölmüş/ayrılmış kişiyle eski pusula köyden ayrılmış kişi diye kalır; hâlâ kanıt değildir. Bozuk metin/kişi/gün pending yaratmaz. Geçersiz/foreign seçim, eski kart ve çift tıklama etkisiz; terminal oyunda kart yok. Optional eski kayıt boş, JSON pending kimlik/seçimi korur.

## Dependencies
FisiltiGazetesi yeni helper, mevcut OlayVerisi/KoyEkrani kartı ve gece raporu. KoyYonetimi gece/save/load ve Oturum olay seçimi/uygunluk/uygula ince adaptörleri. CasusGeceTakibi/DivanKanıt deposuna yazılmaz; KAP01/CSV/çekirdek HUD/koy_halk_hareketi değişmez.

## Tuning Knobs
data/fisilti_gazetesi.json aralık ve üç imzasız iddia. Asset gerekmedi; mevcut kart/rapor, G envanteri kontrol edildi. Görsel/ses/asset üretimi veya indirme yok.

## Acceptance Criteria
Masum mevcut isim için pusula, gizli kimlik/fiilden bağımsız aynı metin, kasa/stok/RNG/kişi/gerçek kanıt koruması. Tek pending/gece/çift seçim, iki seçim, bozuk kayıt ve JSON pending restore; gerçek suçüstü önceliği, boş nüfus/terminal reddi. Native/headless mevcut arşiv düğmesi, ilgili CAS/kayıt/gece ve 20 gece regresyonu, iki ds kopyası.
