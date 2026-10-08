# Köy içi gece takip motoru — CAS-01

## Overview
Mevcut köylü/gece motorları üzerinde gizli ambar/kuyu/cephanelik hedef bayrakları ve gerçek fiil geçmişi tutulur.

## Player Fantasy
Oyuncunun sonraki devriye/divan sistemi niyet ile gözlenen fiili ayıran, gerçek köy gecesine bağlı bir kayda dayanır.

## Detailed Rules
CHR kaynakları değiştirilmez. İncelenen gece davranışları ayrı veri adaptöründe eşlenir: CHR001/006 ambar/değirmen; CHR002/009 kuyu/su arkı/Şifahane; CHR004/005/010 mevcut muhafız kışlası cephanelik hedef grubu. Gece sağlıklı, tok, uyanık, yerel ve nöbetçi olmayan yaşayan kişilerde hazır bina kimliği sırasıyla hedef seçilir. Kuyu hedefi için hazır kayıtlı yapı yoksa mevcut SuDengesi meydan kuyusu bina−1 ile temsil edilir; yeni kuyu/cephanelik binası üretilmez. Diğer hazır hedef yoksa plan yok. Masum CHR003/011–030 gizli davranışı yüzünden suçlu ilan edilmez.

Tek gece makbuzu planı kaydeder; plan stok/sağlık/para/RNG değiştirmez. GizliEgilimler gerçek hırsızlık başarısı/yakalanma ve IsMemnuniyeti gerçek sabotaj sonucu tek satırlık hook ile aynı geçmişe yazılır. Aynı kişi/gece/hedef planı gerçek fiille güncellenir. Var olan fiil niyetle ezilemez. Yeni zehir/yangın/ikinci hırsızlık simülasyonu kurulmaz; CAS03/04 bu kayıt API'sine bağlanacak. Oyuncuya gizli kişi/kanıt sızdırılmaz; yalnız gözlenen gerçek fiil acik_izler sorgusuna girer. Niyet suç kanıtı değildir.

## Formulas
Plan seçimi kararlı hazır bina kimliği; yeni risk zarı yok. Tutulan geçmiş7 gece, en fazla100 satır; kişi/gece/hedef başına tek satır. Fiil kayıp miktarı mevcut motorun gerçekten azalttığı miktardır; kayıt tekrar azaltmaz. Hırsızlık/yakalama/sabotaj olasılıkları mevcut GizliEgilimler/IsMemnuniyeti değerleridir.

## Edge Cases
Eski optional kayıt boş; bozuk tür/negatif/tamsayı olmayan/sonsuz sayılar ve geçersiz hedef/fiil/gözlem satırları elenir. Kayıt/query kopya döndürür. JSON ve tekrar gece makbuzu korunur; integer/float JSON eski yapı bedelleri testte kanonik karşılaştırılır. Hayat/uyku/hastalık/uzakta koruma/nöbet adaylığı mevcut yardımcılarla belirlenir. Yıkılan bina yeni hedef olamaz; tarihsel fiil kaydı silinip geçmiş inkâr edilmez. Gözlenmemiş stok eksilmesi kişinin adını açığa çıkarmaz. Genel uyumsuz işte alet sabotajı cephanelik grubuna, gıda kaybı ambar grubuna bağlanır; bina−1 ortak stok anlamındadır.

## Dependencies
CasusGeceTakibi, KoyYonetimi gece/kayıt üç ince çağrı; GizliEgilimler iki gerçek sonuç hook'u, IsMemnuniyeti bir sonuç hook'u. Koylu/CHR sözleşmesi, CirakEgitimi sağlamlık, IsKazalari uyku, MuhafizMaasi ve KervanKorumasi mevcut API'ler. ANI10 salt görsel sinsi rutini, CAS02 yakalama ve CAS03/04 zarar motorları ayrı sorumlulukta; çift sistem yok.

## Tuning Knobs
Data/casus_gece_takibi.json profil/hedef türleri, meydan_kuyusu, gecmis_gece7, iz_azami100. Asset gerekmedi; bu madde takip/veri motorudur. G envanteri kontrol edildi; üretim/indirme yok.

## Acceptance Criteria
Üç hedef grubu, masum kişi, hazırlık/hastalık/ölüm/nöbet/yıkım filtreleri, ortak kuyu, niyet kanıt değildir, kopya sorgu, aynı gece ve JSON restore, bounded geçmiş/bozuk eski kayıt. Gerçek gece eşitliği; birçok kararlı seed üzerinde gerçek yakalanan/yakalanmayan hırsızlığı ek RNG/stok azaltmadan kaydetme; mevcut gerçek iş sabotajını takip. İlgili gizli eğilim/meslek/CHR/kayıt/gece/sinsi/nöbet/20 gece regresyonu.
