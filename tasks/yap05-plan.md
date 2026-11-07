# YAP-05 — Kalfa uygulama planı

6 Kasım 2026. ROADMAP_2.md tüm asıl kabul kapsamıdır. Küçük dilimler bu kapsamı daraltmaz.

1. Mevcut defter verisinde süre/tek sonuç ve tek kamu bedeli; K1 oda katalog satırı ve veri doğrulayıcı. YAP-05 özel oda şartı yalnız bu bir yapı kimliğini ekler; mevcut bina, savaş, değirmen ve mevsim türleri değişmez. İsim etiketi/kutu; yeni asset yok.
2. Aynı anda tek etkin iş ve kuyruk. İkinci aynı gün başlamaz. Oda/defter/yetişkin sağlıklı işçi ve bedel doğrulanmadan mutasyon yok. Kamu bedeli başlarken bir kez alınır. İkinci tahsilat yok.
3. Mevcut atama/gece/mevsim kaydı ve optional kayıt. İşçi ölünce/ayrılınca/işten alınınca veya oda yıkılınca durur; defter/ilerleme korunur. İşçi dönünce aynı ilerleme sürer. Kış çarpanı mevcut mevsim kaydından, ikinci kış sayısı yok.
4. Süre ve tek hedef çarpanı veriden. Sonuç bir kez; defter çözüldü işareti mevcut eşyada. Yapı bilgisi aynı mevcut kişi/bilgi sözleşmesinde. Bildirim tek satır, ikinci sahne yok. Mevcut yapı kartında başlat/durum/kuyruk; uzun kart kayar.
5. Hedefli model/gerçek UI ve ilgili regresyonlar, headless import/parse; tam sanity yok. Envanter YAP05-ODA ve Türkçe raporlar. Son kabulten sonra[x], ayrı commit/push/masaüstü FF. ds yolları yokluğu doğru raporlanır. DEN-54 regresyonu ayrıca tekrar sınanır, geçmeden çözüldü denmez.

Rutin karar: köy araştırması kamu kasasından tek bedel alır; kişisel defter aynı heybe listesinde kalır. İlk defterin hedefi mevcut hızarhane üretimidir; yeni üretim motoru açılmaz. Oda bilgisi/erişimi K1 bilgi kaynağıyla test edilmeden kabul edilmez. kota görünmüyor.
