# Muhafız kaderi — ODA-10

## Overview
Aynı Ana/BilgiEkrani köy sonuna tek muhafız epilogu eklenir. Köy sonucu aynen kalır; yeni terminal motoru, HUD, kayıt veya ekonomi yoktur.

## Player Fantasy
Köy zaferi yozlaşmayı aklamaz; köy yenilgisi adil muhafızın hatırasını silmez.

## Detailed Rules
Gerçek teftiş idam/azil hükmü önce gelir. Diğer dört mevcut köy sonunda yozlaşma en az70 ve kişisel nakit en az50 ise Venedik kaçağı; nakit yetmezse parasız sürgün. Adalet en az80 ve yozlaşma en fazla20 ise adil kahraman. Geri kalan evine dönüş. Sayılar kaynakta verilmediğinden dış JSON denge varsayımıdır. Meşru servet suç değildir. Kasa bakiyesi geçmiş rüşvet/zimmet makbuzunun yerini almaz.

## Formulas
Öncelik: idam → azil → yoz70/özel50 kaçak veya sürgün → adalet80/yoz≤20 kahraman → evine dönüş. MuhafizTerazisi tek skor kaynağı. Eşya için uydurma satış değeri/kamu nakdi kullanılmaz. Saf anlatı nakit harcamaz, RNG kullanmaz.

## Edge Cases
Null/boş/unknown son epilogue üretmez. Kayıt dönüşü aynı makbuzlardan aynı kaderi seçer. Serveti harcamak ağır yozlaşmayı kahramanlığa çevirmez. Teftiş hükmü kaçış tarafından geçersiz kılınmaz. ODA-15 bu seçicinin tamamlayıcı sözleşme denetimidir; ikinci dal seçici yazılmayacak.

## Dependencies
MuhafizEpilogu + data/muhafiz_epilogu.json; MuhafizTerazisi, SancakTeftisi, Oturum mevcut alanları. Ana yalnız metin helperi ve sunum çağrısı. MuhafizEpiloguSunumu aynı label/düğmelerin kadrajını düzenler; aynı metinler kaydırılabilir, iki düğme sabit ve %150 yazı ölçeği korunur; teftiş okuma zeminini yeniden kullanır. CSV/CHR, oda kaydı ve köy halk rutinleri değişmez.

## Tuning Knobs
kahraman_adalet/kahraman_yoz_azami/kacak_yoz/kacak_akce; insan metinleri aynı JSON. Okuma zemin rengi/genişliği, üst boşluk ve font boyutları. Asset gerekmedi; envanter G kontrol edildi, aynı düz renk okuma zemini/mevcut köy kadrajı kullanılır.

## Acceptance Criteria
Her köy sonucu için bağımsız kahraman/kaçak, eşikler/gerçek zimmet/tek rüşvet sayacı, teftiş önceliği, nakit-kamu-eşya ayrımı, JSON/purity/RNG. Gerçek Ana/BilgiEkrani headless/native, okunabilir kadraj ve iki eski son düğmesi; genel kapı/gece/kayıt/oda regresyonu.

### ODA-15 tamamlayıcı denetimi
Dal seçici tek MuhafizEpilogu.durum; tüketici Ana metin helperi. Köy zafer/yenilgi bağımsızlığı, adalet80/yoz20 ve yoz70/nakit50 sınırları, gerçek günlük zimmet/rüşvet kaynakları, meşru servet, kamu/eşya nakit değildir, azil/idam önceliği, JSON/saf okuma ve unknown terminal doğrulandı. Altı source/API/epilogue/terazi/teftiş/gerçek son UI kontrolü kapanış kanıtı; yeni dal motoru veya kayıt alanı yok. Asset gerekmedi, G kontrol edildi.
