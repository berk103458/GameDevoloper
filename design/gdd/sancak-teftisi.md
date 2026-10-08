# Sancak teftişi — ODA-07

## Overview
Sancak müfettişi belirli gece kapanışlarında muhafızın mevcut kişisel kasasını teftiş eder. Tek sonuç makbuzu, mevcut sabah raporu ve Ana/BilgiEkrani terminal akışı kullanılır; ikinci kasa/HUD veya CHR diyalog motoru yoktur.

## Player Fantasy
Kişisel kazançların gizlenmesi devlet denetimi riskini doğurur; köy ayakta kalsa bile muhafız görevini kaybedebilir.

## Detailed Rules
İlk6. gece ve sonra5 gece aralıkla teftiş. ODA-04 gerçek yozlaşma en az20 ve kişisel kasada akçe veya pozitif adetli eşya kaydı varsa mevcut Oturum RNG akışından tek zar. Bulma şansı%50. Bulunursa yozlaşma70 veya üstünde idam, altında azil. Bunlar kaynak belgede sayı verilmediği için JSON denge varsayımlarıdır.

Kamu parası suç değildir; meşru kişisel para tek başına risk değildir. Kasa kapağının veya oda panelinin açık/kapalı olması dikkate alınmaz. Teftiş para/eşyayı ikinci kez müsadere etmez; bulunan içerik yalnız sonuç makbuzunda özetlenir. Geçmiş yozlaşma temizlenmez. Oda notu sıradaki tarih ve risk kurallarını açıklar.

## Formulas
Gece = r.gun+1. Uygun: gece≥6 ve (gece−6)%5=0, son_gece<gece, mevcut terminal boş. Dolu kasa = muhafiz_akce>0 veya pozitif eşya kayıt sayısı>0. Zar0…9999 < round(olasılık×10000). Tam sayı zar kaydı JSON'da hassasiyet kaybetmez. Yozlaşma tek MuhafizTerazisi okumasıdır.

## Edge Cases
Boş/satılmış kasa veya düşük yozlaşmada zar yok, temiz sonuç. Aynı gece tekrar zar/olay yok. Bulunamama kalıcı geçmişi silmez; yeniden yükleme sonrası sıradaki teftiş devam eder. Önceden köy terminali varsa onu ezmez. Yeni terminal kodları muhafiz_azil/muhafiz_idam; köyün varlık/nüfusunu yok etmez. Optional makbuz eski kayıtta boş, bozuk/bilinmeyen değerler elenir; yüklenmiş sahte makbuz kendi başına terminal yaratmaz. Makbuz akçesi rapor amaçlı1e9 tavanlıdır, gerçek int64 bakiye değiştirilmez. CHR_007 sahte teftiş katibi farklı kaynak hikâyesidir, değiştirilmez. Save-slot taraması ODA-13'e aittir; bu paket mevcut canlı oturumu denetler.

## Dependencies
SancakTeftisi helper ve data/sancak_teftisi.json. Oturum optional kayıt/gece için ince bağlantılar; IflasYoneticisi aynı typed rapor metni; Ana aynı son ekranında özel başlık/metin; OdaTeftisNotu yalnız teftiş sonunda metin altında opak ColorRect okuma zemini, diğer sonlar aynı kalır. OdaTeftisNotu aynı oda listesinde tek Label. KoyEkrani, koy_halk_hareketi, CSV ve CHR kaynaklarına yazılmaz.

## Tuning Knobs
ilk_gece/aralik/yozlasma_esigi/idam_esigi/bulma_olasiligi/zar_cozunurlugu ve son_okuma_sag/son_okuma_renk JSON'dadır. Asset gerekmedi; mevcut bilgi/rapor kartı, oda kutuları ve köy arka planı kullanılır; envanter G kontrol edildi.

## Acceptance Criteria
Gerçek rüşvet sayacı/kişisel bakiye; erken gece, temiz maaş, boş/satılmış eşya, yalnız eşya, azil/idam ve bulunamama. Tek RNG/makbuz, JSON birebir terminal/sonuç, reload sonrası yeni teftiş; eski köy terminalini koruma. Gerçek Oturum gece/sabah raporu, kapalı kasa riskten kaçırmaz, gerçek Ana azil/idam ekranı ve native/mirror kontrolü.
