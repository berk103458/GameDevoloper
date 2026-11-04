# MECLIS-ARA-01: Çınar Meclisi İnteraktif Dava Sistemi — Diyalog Taslağı

Haftalık periyotlarda veya köydeki krizlerden sonra Çınaraltı meydanında köylülerin Muhafız'ın hakemliğine getirdiği 4 interaktif dava sahnesidir.

---

## 1. Dava: Karaca Usta vs Çiftçi Yusuf — "Kırılan Balta ve Odun Hakkı"
- **Olay:** Karaca Usta'nın dövdüğü kaliteli çelik baltayı Yusuf kış odunu kırarken çatlatmıştır.
- **Karaca Usta:** "Ağam! Bu baltayı iki gün ocakta tavladım. Yusuf kütüğe değil taşa vurup çatlatmış! Ya baltanın iki akçelik demir hakkını ödesin ya da kış boyu demirhaneme kömür taşısın!"
- **Yusuf:** "[Boynunu büker] Ağam, donmuş meşe kütüğü taştan beterdi. İki akçem olsa çocuklara çarık alırdım. Kasten kırmadım!"
- **Hüküm Seçeneği 1 (Adalet & Ahilik Nizamı):** "Yusuf kasten kırmamış amma emanete riayet esastır. Yusuf demirhaneye 5 gün çıraklık edip körük çekecek, akçe ödemeyecek." -> `adalet +2`, `moral +1`, `meclis_balta_cozuldu = true`.
- **Hüküm Seçeneği 2 (Muhafız'ın Cebinden Karşılama):** "Karaca Usta'ya köy kasasından bir akçe demir parası, Yusuf'a da dikkat etmesi için nasihat." -> `akce -1`, `moral +2`.

---

## 2. Dava: Ayşe Bacı vs Gezgin Çuhacı — "Sahte Çivit Boyası ve Bozuk Kilimler"
- **Olay:** Kayserili çuhacının sattığı mavi çivit boyası yağmurda akmış, Bacıyan tezgâhındaki üç kıymetli kilim ziyan olmuştur.
- **Ayşe Bacı:** "Bu kilimleri Sivas panayırına hazırlıyorduk! Yağmur değdi, boya dereye aktı! Bu çivit değil, çamurla karıştırılmış mürekkep tortusudur!"
- **Çuhacı:** "Ben tüccarım bacım, boyayı Tebriz kervanından aldım! İçi beni yakar dışı seni!"
- **Hüküm Seçeneği 1 (Tüccara Malları Geri Aldırma ve Tazminat):** "Tüccar bozuk boyanın parasını iade edecek ve dokumacılara iki top temiz yün verecek; aksi halde köy pazarından men edilir." -> `adalet +2`, `koy_uretim +1`, `meclis_boya_cozuldu = true`.
- **Hüküm Seçeneği 2 (Zararı Yarı Yarıya Bölme):** "Kervan malında ikiniz de pay sahibisiniz. Zarar ortak karşılansın." -> `adalet +0`, `moral -1`.

---

## 3. Dava: Çoban Aydoğdu vs Molla Şükrü — "Mera Yazımı ve Pınar Hakkı"
- **Olay:** Molla Şükrü, beylik vakıfnamesini öne sürerek güney pınarını kendi himayesine yazmak istemiş, Aydoğdu'nun koyun sürüsünü pınardan kovmuştur.
- **Aydoğdu:** "Bu pınar yüz yıldır Avşar obasının sürüsünü sular! Kâtip efendi gelmiş, 'kâğıtta mühür var, pınar vakfındır' diyor! Koyun kâğıttan mı su içer muhafız?"
- **Molla Şükrü:** "Nizam kâğıtla kurulur çoban! Kadı defterine kayıtlı olmayan su haramdır!"
- **Hüküm Seçeneği 1 (Geleneksel Mera Hakkını Koruma):** "Kâğıt halkın suyunu kesemez! Pınar hem obaya hem köye açıktır. Molla Şükrü kütüğü buna göre düzeltsin!" -> `adalet +3`, `moral +2`, `asayis +1`, `meclis_mera_cozuldu = true`.
- **Hüküm Seçeneği 2 (Kâtibin Vakıf Yetkisini Onaylama):** "Vakıf kuralı bozulmaz, çoban başka dereye gitsin." -> `asayis -2`, `adalet -2`, `koy_ayriligi = true`.

---

## 4. Dava: Thessra vs Otacı Miraen — "İlaç Kazanı ve Ortak Şifahane"
- **Olay:** Thessra'nın Rum usulü damıtma yağları ile Miraen'in dağ otları karışımı konusunda iki tabip köy meydanında sert bir tıp tartışmasına tutuşur.
- **Thessra:** "Benim tentürgülüm ateşli hummayı üç saatte düşürür. Miraen Nine köylülere 'yabancı ilacı içmeyin' diye korku salıyor."
- **Miraen:** "O tentürgülün içinde afyon ruhu var kızım! Hastayı uyutur amma içini kurutur! Biz bin yıldır bu dağın kekliğiyle yara sağalttık!"
- **Hüküm Seçeneği (Ortak Köy Şifahanesi Kurma):** "İkinizin de ilmi bu köye lazımdır. Thessra cerrahlığı ve ateşi alsın, Miraen dağ otlarını ve kırıkları. Eski kireç ocağını köy şifahanesi yapıyoruz!" -> `koy_saglik +3`, `moral +2`, `meclis_sifahane_kuruldu = true`.
