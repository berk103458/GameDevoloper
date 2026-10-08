# Gece devriyesi ve suçüstü tutanağı — CAS-02

## Overview
Mevcut gece motorunun gerçek fiili aynı devriye ve olay kartında gözlenir; ikinci suç/ceza motoru kurulmaz.

## Player Fantasy
Meşaleli muhafızın gözlediği fiili tutanağa alıp sonraki divan için korumak.

## Detailed Rules
Sağlıklı, tok, yetişkin, uyanık, yerel ve maaşı ödenmiş mevcut muhafız gerekir; isyancı/uzaktaki kervan koruması hariç. ANI-01 gece meşalesi görevin mevcut donanımı kabul edilir; yeni fener envanteri veya konum simülasyonu yok. CAS-01 hedef niyeti yakalanamaz. Aynı gece gerçek hırsızlık/sabotaj fiili varsa gözlenmemiş fiil için mevcut RNG ile şans denenir. Önceden gözlenen fiilde ek zar yok. İlk başarıda en çok bir pending tutanak; mevcut kayıp tekrar uygulanmaz. Gerçek hırsızlıkta mevcut hirsiz bayrağı açılır.

Mevcut Oturum.olay_sec, taşkın kartından sonra tutanağı aynı KoyEkrani olay kartına verir. Sakla veya uyar seçenekleri gözlemi korur, yalnız şerhi kaydeder. Hapsetme/ceza CAS-05…07'ye aittir; bu madde suçlu kararı vermez. Bekleyen tutanak çözülmeden ikinci tutanak üretilmez.

## Formulas
Etkin muhafız yoksa 0; aksi halde min(0.75, 0.15 + 0.10 × etkin muhafız). Denge varsayımı JSON'da. Her gece tek makbuz, en çok bir yakalama. Gerçek fiil başına başarısız denemede tek zar; niyet veya nöbetsiz gece RNG tüketmez.

## Edge Cases
Eski optional kayıt boş; bozuk pending kişi/gün elenir. Aynı gece/JSON restore/çift tıklama/eskimiş kart güvenlidir. Ayrılmış kişi tutanağı ad yerine köyden ayrılmış gösterir. Terminal oturum olay üretmez. Gerçek gözlem kaydı uyarı seçimiyle silinmez; stok/kamu kasası/ikinci zarar değişmez.

## Dependencies
CasusDevriyesi yeni helper; KoyYonetimi gerçek gece fiillerinden sonra tek çağrı ve optional kayıt; Oturum mevcut olay seçme/uygunluk/uygulama ince çağrıları. CAS-01 ledger, MuhafizMaasi, CirakEgitimi, KervanKorumasi, IsKazalari, IsMemnuniyeti. Mevcut ANI meşalesi ve tek olay ekranı.

## Tuning Knobs
Data/casus_devriyesi.json fener_taban, muhafiz_katkisi, yakalama_ust. Asset gerekmedi; mevcut meşale/olay kartı kullanılır. Envanter G kontrol edildi; asset üretimi/indirme yok.

## Acceptance Criteria
Niyet suç değildir; etkin/missing/hasta muhafız ve şans; gerçek fiil tek gözlem/tek stok etkisi; RNG tekrar koruması; iki gerçek UI seçeneği; bekleyen tutanak save/load; çift tıklama; mevcut gece meşalesi. Headless/native gerçek KoyEkrani, CAS/CHR/meslek/kayıt/nöbet/gece/20 gece regresyonu.
