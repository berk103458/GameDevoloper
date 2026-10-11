# BUG-18 — Tehdit alışma süresi (Kalfa)

`data/tehdit_takvimi.json` içindeki `tehdit_baslangic_gunu` varsayılanı 14'tür. Motor tamamlanan gün sayısını kullanır: 0–13 kapalı, 14 ve sonrası açık. Eşik oyun koduna gömülmez. Mevcut `Oturum.gun` / `KoyYonetimi.gun` okunur; ikinci takvim, doğal geliş sayacı veya kayıt alanı yoktur. Eski kayıtta gün 25 ise 25 olarak devam eder.

Adlı adaylar ve ağırlıklar HAR-11'in mevcut `risk_profilleri` kümesini okur. Bu küme CAS-01'in gerçek yedi suç profilini kapsar; sırf eski `casus_suphesi` etiketi var diye kadı veya masum yolcu yeni bir tehdit listesine alınmaz. Kuyrukta yalnız yasak adaylar kaldığında normal figür yolu kullanılır. Sıfır ağırlıklı havuz zar tüketmeden boş döner; üst zar sınırı sıfır ağırlıklı son adayı seçmez. Süre dolunca mevcut güvenlik/ticaret ağırlıkları aynen döner.

Doğal kundaklama, kuyu zehirleme, casus hedef planı, bu profillerin erzak hırsızlığı ve husumet/intikam baskınları aynı eşiği okur. Erken gecede fiil/teslim makbuzu üretilmez. Mevcut husumet sönümü devam eder; baskın zarı atılmaz. Süre sonunda geçerli gecikmiş fiil kendi mevcut tek uygulama makbuzunu kullanır.

Moğol (HAR-02), HaberciAgi, SancakAskerTalebi ve DiplomatikHeyet bu kapıya bağlanmaz. Resmi haber veya diplomatik ziyaret, mevcut kendi ön koşullarıyla çalışır. Debug karakter/kriz çağrısı takvimi ileri taşımaz. Mevcut debug baskın stres koşusu için geçici, kayda yazılmayan izin vardır; koşu bitince kaldırılır. Stres koşusunun açıkça istediği gerçek gece ilerlemesi mevcut ZamanMakinesi işidir; tehdit enjekte etmek için ayrıca gün eklenmez.

`tests/unit/sistemler/tehdit_takvimi_test.gd`: 13. gün sıfır ağırlık/gerçek kuyruk, boş havuz RNG'si, üst zar sınırı, gerçek geceyle Moğol ilerleyişi, ilk gün resmi ulak/heyet, 15. gün taban ağırlık/gerçek kuyruk, ayarı 20'ye değiştirme, erken fiil/makbuz yokluğu, ertelenmiş fiil ve intikamın tek uygulanması, debug/kayıt ve eski günün korunması.

Eski CAS tur-offset/kanıt/RNG ve HAR-08 anlaşma süresi/ganimet testleri kendi süreçlerinde alışma ayarını sıfıra indirerek kaynak mekaniklerini ayrı denetler. HAR-11 ve savunma eşik testleri süre sonrası koşar. Bu fixture değişiklikleri mevcut sonuç ve kayıt eşitliği iddialarını kaldırmaz. Üretim JSON'u 14 olarak kalır; yeni takvim testi ve gerçek oyun koşusu bu varsayılanla çalışır.

Asset gerekmedi. ds ayna yolu bu bilgisayarda bulunmadığından eşitleme yapılamadı.

Doğrulama: 29 hedefli birim/sahne kontrolü ve nihai UTF-8 tam sanity 330 PASS / 0 hata / 20 gece. Hedefli loglar `work/bug18-target-final`, tam loglar `work/sanity-bug18-final-2` içindedir. İlk kısa tam koşu, eksik HAR-08 fixture denetimi için erken durduruldu; başarı kanıtı değildir ve `work/sanity-bug18-final` içinde korunur.
