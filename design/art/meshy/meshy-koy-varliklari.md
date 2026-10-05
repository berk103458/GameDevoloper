# Meshy köy varlıkları — ayıklama ve hazır varlık listesi

Kaynak: kullanıcının iki Meshy koleksiyonu (*Game development* 95 model, *Karakter assetleri* 16 model) ve Meshy topluluğunda dönem için yapılan arama. **Hepsi CC0** (lisans her model için API'den okundu). Hiçbir varlık üretilmedi.

Ölçütler: 13. yüzyıl Anadolu Selçuklu ucu, Türkmen (art bible 5.2, 6.1); kapı sahnesiyle aynı gerçekçi PBR üslup (elle boyanmış, çizgi film, parlak doygun model yok); köy sisteminin yuvaları (`src/dunya/koy_sahnesi.gd`: ev/çadır, sur 0–3, pazar, kervansaray, konak, kuyu, tarla, iş yerleri).

Kod: **O** = Game development koleksiyonu, **K** = Karakter assetleri, **A/B** = topluluk aramasından ek öneri. Seçilenlerin görünümü: `meshy-secim.png`.

## İndirme ve oyuna ekleme

Topluluk modelleri herkese açık hâlde yalnız Meshy görüntüleyicisinde duruyor; **GLB indirmek oturum açmayı gerektiriyor**, bu yüzden buradan çekilemedi. İndirilen GLB'ler `assets/model/yapi/` (bina) ya da `assets/model/nesne/` (eşya) altına tablodaki adla konursa sahne kodu `Dunya3B.nesne(ad, boy)` ile hemen kullanır.

- **Üçgen sayısı:** 100 binin üstündekiler Blender *Decimate* ile 20–50 bine indirilmeli (köy sahnesinde onlarca kopya var).
- **Üslup birliği:** hepsi aynı gece ışığında, aynı ton çarpanıyla (`albedo_color`, kapı sahnesindeki gibi) gösterilir; parlak renkli olanlar (O65, K04) koyulaştırılır.

## 1. Doğrudan oyuna eklenebilir (animasyon gerekmez)

### Sur ve kapı (seviye 1–3)

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| O37 | [Ahşap palisat (kazık sur)](https://www.meshy.ai/posts/019b1ed6-3215-798e-a0d4-d6749ae41429) | sur 1 — `nesne/kazik_cit.glb` yerine | 2.990 | Hafif (3 bin üçgen), hemen kullanılır. |
| O17 | [Sivri kazık çit](https://www.meshy.ai/posts/019e71ab-9a69-70ca-b62b-9560c66b0469) | sur 1 — alternatif kazık | 769.860 | Ağır, azaltılmalı. |
| O81 | [Yürüme yollu ahşap palisat](https://www.meshy.ai/posts/019fa44a-8f21-7e5e-a3e3-b559a4253b67) | sur 2 — palisat + nöbet yolu | 650.912 |  |
| O25 | [Ahşap palisat kapısı](https://www.meshy.ai/posts/019d9fe0-e799-7bac-b798-ee83be415d85) | sur 1–2 — kapı kanadı | 1.599.643 | Ağır, azaltılmalı. |
| A113 | [Sazdan çatılı ahşap gözetleme kulesi](https://www.meshy.ai/posts/0194098f-52be-79a1-88e3-c7cfb5e4fc8b) | sur 2 — kule | 25.449 |  |
| O90 | [Taş sur duvarı](https://www.meshy.ai/posts/0196bd5a-afd9-7643-b1e6-a6b800393850) | sur 3 — taş sur modülü | 51.117 |  |
| O92 | [Taş çerçeveli demir parmaklıklı kapı](https://www.meshy.ai/posts/019634c9-7289-7392-af5b-f4fed9e537f8) | sur 3 — taş kapı | 75.028 |  |
| O72 | [Taş-ahşap kule](https://www.meshy.ai/posts/0194dd03-5e18-76ba-8b36-8c8c5947b415) | sur 3 — burç | 320.119 |  |

### Barınma: ev ve çadır (konak seviyesine göre)

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| O26 | [Toprak damlı kerpiç ev](https://www.meshy.ai/posts/019d7fc0-510b-7a97-b744-ecd8dafead74) | `yapi/ev.glb` — konak 0 | 7.890 | Orta Anadolu toprak damı; hafif (8 bin). |
| A117 | [Düz damlı kerpiç ev](https://www.meshy.ai/posts/019ec7a5-3009-78a3-a897-2d7ffe063f9a) | ev — konak 1 | 984.892 |  |
| A116 | [İki katlı düz damlı kerpiç ev](https://www.meshy.ai/posts/019ec7a5-98c6-7d1f-a282-51496ed64b45) | ev — konak 2 | 575.656 | Koleksiyondaki O12 ile aynı model. |
| O16 | [Avlulu kerpiç ev](https://www.meshy.ai/posts/019e739d-8712-7a14-9736-fa75dd5246fc) | konak (ağa evi) — seviye 1–2 | 3.149.762 | Çok ağır (3,1 milyon), azaltılmalı. |
| O31 | [Keçe yurt (topak ev)](https://www.meshy.ai/posts/019cecc0-28c7-77c3-9005-49e1b16b5f3b) | `yapi/cadir.glb` — Türkmen çadırı | 1.116.380 | Ağır, azaltılmalı. |
| O67 | [Yurt (hafif)](https://www.meshy.ai/posts/01956c84-e0eb-7356-854a-05f2d691a1c6) | çadır — uzak/küçük kopyalar | 17.841 | 18 bin üçgen. |
| B065 | [Tepe taş kulübesi](https://www.meshy.ai/posts/019faf36-df11-7954-89ab-7c6fc4d15cb5) | çoban kulübesi — köy kenarı | 3.834 | 4 bin üçgen. |

### Köy merkezi ve ortak alan

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| O21 | [Taş kuyu (çıkrıklı)](https://www.meshy.ai/posts/019df7fa-387b-7dc3-8d56-3781e375959c) | `nesne/kuyu.glb` yerine | 809.733 |  |
| O05 | [Demir mangal (nöbet ocağı)](https://www.meshy.ai/posts/019f8a6f-8691-7814-bc20-b28c04ad7571) | kapı/sur nöbet yeri — asker izi | 4.254 | 4 bin üçgen. |
| A060 | [Taş halkalı ocak](https://www.meshy.ai/posts/019680e1-1b07-7aac-a71b-a22449eee96d) | ocak taşı — barınma izi | 3.000 |  |
| A228 | [Sacayak üstünde kazan](https://www.meshy.ai/posts/019f9566-5b55-7733-b8b7-0ca7045913bd) | ocak + kazan (ortak sofra) | 6.296 |  |
| B071 | [Kuru taş duvar köşesi](https://www.meshy.ai/posts/01999573-4cea-7882-be3a-ecc7a149b581) | ağıl / bahçe duvarı | 4.518.708 | Çok ağır (4,5 milyon), azaltılmalı. |
| O64 | [Örme çubuk çit (çeper)](https://www.meshy.ai/posts/019667ff-f5a3-74d0-b3f3-79c558f21e1b) | bahçe ve tarla çiti | 307.734 |  |
| O03 | [Kuru taş yıkık duvar](https://www.meshy.ai/posts/019fce2f-fd27-704b-9639-e5629be4c4fa) | köy kenarı, yıkık ev izi | 20.159 | 20 bin üçgen. |
| O20 | [Taş oturak](https://www.meshy.ai/posts/019e093e-c464-7c5e-9276-6093c15ab9c2) | kuyu başı | 396.660 |  |

### Pazar ve kervansaray

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| B021 | [13.–14. yy Anadolu kervansarayı](https://www.meshy.ai/posts/0195321e-ca4a-76ec-96d8-5d669b069289) | `yapi/kervansaray.glb` yerine | 452.962 | Dönem için en uygun aday; 450 bin, azaltılmalı. |
| A073 | [Sazdan çatılı pazar tezgâhı (çuvallı)](https://www.meshy.ai/posts/01960d12-91d4-737c-b518-9195368ce590) | `yapi/pazar_tezgahi.glb` — pazar 1 | 635.056 |  |
| A077 | [Örtülü pazar tezgâhı](https://www.meshy.ai/posts/01960d17-683a-7481-a5ec-92a1ef4c7c59) | pazar 2–3 | 566.952 |  |
| O65 | [Renkli çarşı tezgâhı](https://www.meshy.ai/posts/0195cdea-6ca5-7374-938b-b6b6cf322275) | pazar 3 (zengin) | 184.169 | Renkleri koyulaştırılmalı. |
| O49 | [Kervan konak yeri (örtü + yük)](https://www.meshy.ai/posts/0199df3f-6b69-7bd6-9917-b9977d6a78e0) | kervansaray avlusu, yük ve denk | 951.487 |  |
| A242 | [Çömlekçi tezgâhı (çömleklerle)](https://www.meshy.ai/posts/0198e561-6a2d-7e22-b0af-9d2120a5d9be) | pazar — çömlekçi | 55.641 |  |

### Kap kacak ve küçük eşya (iz propları)

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| O07 | [Toprak çömlek](https://www.meshy.ai/posts/019f6b0b-1222-7d3f-b4d9-31e0147f7b48) | küp/çömlek | 761.834 |  |
| O48 | [Toprak testi](https://www.meshy.ai/posts/0199f738-2a88-706f-9543-671d0d0d3ead) | testi | 446.726 |  |
| O82 | [Küp (amfora)](https://www.meshy.ai/posts/019f0538-5faf-7303-a014-9905dbfa5336) | kiler, pazar | 66.962 |  |
| O83 | [Eski küp](https://www.meshy.ai/posts/019f0535-787f-7656-b0c1-a022848aea2a) | kiler | 104.748 |  |
| O84 | [Kapaklı bakır tencere](https://www.meshy.ai/posts/019cdc18-105f-7c0f-8b43-57d2b3e4743a) | ocak, pazar | 374.832 |  |
| A227 | [Bakır kazan](https://www.meshy.ai/posts/0199e982-1ed3-7e81-b0e1-5f032da0b4a1) | ocak | 617.352 |  |
| O32 | [Toprak kandil](https://www.meshy.ai/posts/019cc572-9e2d-7d3b-b305-7c6f9e5a2e26) | ev içi ışık | 364.307 |  |
| O19 | [Asma toprak kandil](https://www.meshy.ai/posts/019e2e2b-dd0e-7964-9a33-32e51c5e50af) | pazar/kervansaray | 316.518 |  |
| O01 | [Hasır sepet](https://www.meshy.ai/posts/01a097c1-cdf4-7488-bb70-e04817c5a9f9) | pazar, tarla | 229.763 |  |
| O51 | [Saplı sepet](https://www.meshy.ai/posts/019942d0-4ca7-7b6c-9527-f03a56eaec18) | pazar | 9.969 |  |
| O14 | [Yumurta sepeti](https://www.meshy.ai/posts/019e8fd3-5da3-76e3-8ee4-e1c6b0d98f3f) | pazar, köy | 28.037 |  |
| A241 | [Çömlek takımı](https://www.meshy.ai/posts/0199fc55-49eb-7c16-96c2-03f4bbaccd33) | pazar | 680.172 |  |
| A081 | [Ağzı açık un çuvalı](https://www.meshy.ai/posts/01970960-ba22-78fe-b02c-101a9e854616) | ambar, değirmen | 473.038 |  |
| A190 | [Tahıl çuvalı](https://www.meshy.ai/posts/0196cb9b-1fdf-7294-a3fa-8d56cb1de6f5) | ambar | 477.522 |  |

### Tarla ve çiftçi izleri

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| A202 | [Tınaz (saman yığını)](https://www.meshy.ai/posts/01992dfd-0009-73dc-9900-fe2a38f40a33) | harman yeri | 33.259 |  |
| A220 | [Karasaban](https://www.meshy.ai/posts/0195e78a-61a0-74b9-82da-cbe87281f245) | tarla kenarı | 86.388 |  |
| A211 | [Orak](https://www.meshy.ai/posts/019ba4e8-cb95-7e06-92b4-bf116eb74377) | tarla, ırgat izi | 105.180 |  |
| A209 | [El değirmeni](https://www.meshy.ai/posts/019d6827-7584-7026-ab82-5a24a359b9ea) | ev önü / değirmen | 874.267 |  |
| A205 | [Değirmen taşı](https://www.meshy.ai/posts/0194b2f7-1810-71be-8a79-423ff62e6ab7) | değirmen | 158.967 |  |
| A186 | [Saman kovan](https://www.meshy.ai/posts/019628d9-da46-7aee-a166-9788d7592b43) | bahçe | 9.991 |  |
| O58 | [Saman arabası](https://www.meshy.ai/posts/019807f6-839f-7b28-98a1-da117255d146) | harman | 24.880 |  |
| O93 | [Öküzlü saman kağnısı (duran)](https://www.meshy.ai/posts/01945ac6-f2bc-78ea-8862-60da36999465) | köy yolu, durağan dekor | 21.219 | Öküz hareketsiz; yalnız dekor. |
| O30 | [Ahşap yalak](https://www.meshy.ai/posts/019cfc6c-a5b0-7b45-8644-dd5e8ba06498) | hayvan suluğu | 179.416 |  |
| A095 | [Taş yalak](https://www.meshy.ai/posts/019bed55-b1af-7626-82a5-89a1e92e8574) | kuyu başı | 520.224 |  |
| O00 | [Odun yığını + kütük](https://www.meshy.ai/posts/01a0aa72-b482-76c3-9893-d9c5ffb9bd8e) | ev önü | 30.415 | 30 bin üçgen. |
| O23 | [Raflı odun istifi](https://www.meshy.ai/posts/019de3e9-e96e-7060-9c51-9a07bd64b593) | ev önü | 2.954 | 3 bin üçgen. |
| O18 | [Taş yığını](https://www.meshy.ai/posts/019e4507-432d-73b0-8069-f5355da00473) | köy kenarı | 5.220 |  |

### İş yerleri ve esnaf izleri (karakter sayfalarıyla bağlı)

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| O78 | [Çömlekçi fırını sundurması](https://www.meshy.ai/posts/01a0513e-7c42-726b-a5f9-5a6f8184beb4) | çömlekçi Rasim (CHR_027) — pazar | 3.077.942 | Çok ağır (3 milyon), azaltılmalı. |
| O79 | [Debbağhane (deri gerdirme)](https://www.meshy.ai/posts/019fb342-ac80-7a92-abf5-b0c143bc78df) | saraç Salih (CHR_026), Ahi izi | 549.278 |  |
| A040 | [Kütük üstünde örs](https://www.meshy.ai/posts/019e95fa-824d-7ddf-98d9-db1056257359) | çivi ustası Basri (CHR_029), demirci izi | 1.157.354 |  |
| A042 | [El körüğü](https://www.meshy.ai/posts/01975afc-f0e7-776b-b6b9-002a8dda80e9) | demirci izi | 36.986 |  |
| A236 | [Kilim dokuma tezgâhı](https://www.meshy.ai/posts/019ee401-6930-71ce-bfbd-b839a92d255a) | bezci Hulusi (CHR_028) | 583.962 |  |
| A181 | [Tandır](https://www.meshy.ai/posts/01952084-f386-751f-b8f9-e3f7b17a441d) | fırın — ekmek; değirmen kalfası Latif (CHR_030) ile | 20.387 |  |
| A177 | [Kubbeli toprak fırın](https://www.meshy.ai/posts/01993a03-cf14-7f7e-8e40-508060a008db) | fırın | 9.960 |  |
| O76 | [Su değirmeni](https://www.meshy.ai/posts/0193fc1f-52e8-70ca-aa3f-5e5e48dae7e7) | değirmen (dere kenarı) | 25.162 | Çatısı biraz Avrupai; uzak planda uygun. |

### Asker ve kışla izleri (kışla bina değil, iz)

| Kod | Varlık | Oyundaki yeri | Üçgen | Not |
|---|---|---|---|---|
| A016 | [Mızrak sehpası](https://www.meshy.ai/posts/019514e9-eccc-7284-a498-9b57bb778b1a) | kapı ve sur yakını nöbet yeri | 222.356 |  |
| A002 | [Ahşap yuvarlak kalkan](https://www.meshy.ai/posts/01941a9d-b53d-778b-bbe9-9f6ef274dd2c) | nöbet yeri | 164.889 |  |
| A012 | [Mızrak](https://www.meshy.ai/posts/0198be5d-1df4-7411-9823-1390d7ce41c7) | sehpa, duvara dayalı | 24.786 |  |

## 2. Animasyonlu, eklenebilir

| Kod | Varlık | Kullanım | Üçgen |
|---|---|---|---|
| K05 | [At](https://www.meshy.ai/posts/019bda52-db6a-7a2d-9b17-0bd27fffc3dc) | Animasyonlu. Kervan, atlılar (2. perde), ahır. | 47.468 |
| K13 | [Koyun](https://www.meshy.ai/posts/01987a05-4049-7032-a6b2-23062286fca7) | Animasyonlu. Ağıl, çoban, sürü. | 9.802 |
| K12 | [Ortaçağ tüccarı](https://www.meshy.ai/posts/019b0a84-3beb-79ff-a2fc-2a08d617d659) | Animasyonlu insan. Kervansaray avlusunda dolaşan tüccar. | 29.944 |
| K04 | [Tavuk](https://www.meshy.ai/posts/019c25e2-2e6b-7054-8937-1fadff411526) | Animasyonlu. Renkleri parlak, koyulaştırılmalı. | 235.964 |
| K09 | [Okçu (Pers)](https://www.meshy.ai/posts/01951ea9-ffa3-7480-a1b0-6ab6dc15e5de) | Animasyonlu insan. Asker okçu için aday; kıyafet dönemle karşılaştırılmalı. | 257.376 |

## 3. Animasyonu eksik — ayıklandı (doğrudan eklenemez)

İnsan modelleri bizim hattımızla (Meshy otomatik iskelet + hazır hareket kütüphanesi, `tools/model/meshy_uret.py`) canlandırılabilir; bu kredi harcar ve kullanıcı onayı ister. Dört ayaklılar için Meshy'de otomatik iskelet yok; ayrı animasyon gerekir.

| Kod | Varlık | Durum | Üçgen |
|---|---|---|---|
| K02 | [Kıpçak / Kuman savaşçısı](https://www.meshy.ai/posts/019f3610-76c2-7929-8cf2-1342eebd0b47) | Türkmen asker için en uygun model. İnsan: Meshy otomatik iskelet + hazır hareketler (bizim hattımızla). 1,26 milyon üçgen. | 1.257.156 |
| K10 | [Kışlık giysili tüccar (T-poz)](https://www.meshy.ai/posts/0193e214-e48c-755e-9625-d54a546df5d2) | T-pozda; iskelete hazır. Tüccar. | 19.410 |
| K14 | [Gezgin tüccar](https://www.meshy.ai/posts/0194fd29-73ec-776b-9767-835d64751522) | İnsan, iskelet + hareket gerekir. Kervan. | 217.307 |
| K15 | [Gezgin tüccar (sepetli)](https://www.meshy.ai/posts/0194fd28-cc4c-776a-8e47-336081f355ee) | İnsan, iskelet + hareket gerekir. Pazar. | 171.460 |
| B092 | [Kapüşonlu köylü](https://www.meshy.ai/posts/019f91c4-d9ce-7c70-99ba-f23cca54a497) | İnsan, iskelet + hareket gerekir; hafif (10 bin). Köy figürü. | 10.214 |
| B104 | [Savaşçı](https://www.meshy.ai/posts/01978297-dc48-766c-b39c-175a23eb4bb0) | İnsan, iskelet + hareket gerekir. Asker. | 9.999 |
| K07 | [Ayı](https://www.meshy.ai/posts/019b913d-aa4e-7eeb-b2d9-f256117d2306) | Dört ayaklı: Meshy otomatik iskelet yalnız insan içindir; ayrı animasyon gerekir. Kapı olayı/dağ tehlikesi. | 1.546.078 |
| B019 | [Kangal (Anadolu çoban köpeği)](https://www.meshy.ai/posts/019dc99d-b2b2-72de-bcb4-fa9fc2efd3ef) | Dört ayaklı; animasyon gerekir. Çoban, ağıl. | 388.371 |
| A140 | [Deve](https://www.meshy.ai/posts/019421a5-5c84-7bc3-98fe-7c3156e0ae97) | Dört ayaklı; animasyon gerekir. Kervansaray. | 21.286 |
| A157 | [Eşek](https://www.meshy.ai/posts/0198bdf3-9941-7a00-a8d5-cc79b349ddd5) | Dört ayaklı; animasyon gerekir. Yük hayvanı. | 9.999 |
| A163 | [Keçi](https://www.meshy.ai/posts/0194bd12-a83b-739d-a727-6c64d02a7608) | Dört ayaklı; animasyon gerekir. Kara keçi, ağıl. | 19.452 |
| A172 | [Öküz](https://www.meshy.ai/posts/0199e26d-d26d-729a-9764-f2b0da180842) | Dört ayaklı; animasyon gerekir. Kağnı, saban. | 19.401 |
| A146 | [Tavuk (gerçekçi)](https://www.meshy.ai/posts/01940e29-8c62-763f-b33c-f396611251a3) | Animasyon gerekir; K04'e gerçekçi alternatif. | 19.499 |
| B117 | [Çoban ve koyun (heykel)](https://www.meshy.ai/posts/019b723e-707b-77fa-84a2-fb99bf7c3a3c) | Tek parça heykel: yalnız durağan dekor olabilir. | 1.084.178 |

## 4. Elenenler (dönem ya da üslup dışı)

| Kodlar | Neden |
|---|---|
| O10, O11, O28, O94 | Çöl kubbeli ve Akdeniz evleri: kiremit çatı, sıva, kubbe; 13. yy Orta Anadolu köyü değil. |
| O36, O47, O73, O74, O75, O87, O76* | Avrupa yarım-ahşap (fachwerk) yapılar, Diablo tarzı demirhane. *O76 uzak planda istisna. |
| O44, O45, O46, O53, O66 | Eski Mısır / taş devri / Afrika kulübesi: dönem dışı. |
| O54, O55, O59, O60, O02 | Diorama (zemini ve birden çok yapı tek parça): tek tek yerleştirilemez. O02 yalnız 2. perde uzak plan için. |
| O13, O69 | Dokusuz (gri) model. |
| O22, O40, O41, O42, O52, O61 | Avrupa şatosu dişli surları, kuleleri: oyunun sur dili kazık → kaba taş; şato yok. |
| O27, O33, O68, O71, O86, O89, O09 | Elle boyanmış / stilize / çizgi film üslubu: gerçekçi sahneyle uyuşmaz. |
| O08, O70, O34, O85, O38, O39 | Avrupa/Roma çeşmesi, gotik ve Roma bankı, modern mezar taşı, fantastik mangal. |
| O35, O43, O57, O63 | Uzakdoğu çatısı, kiremitli kutu ev, modern tuğla ev, Kayrevan Camii (Tunus, ölçek ve dönem dışı). |
| O91, O88 | Kızılderili çömleği; desenli çöl amforası (üslup). |
| O56, O62 | Fıçı: Anadolu'da küp ve tulum daha yaygın; yalnız kervan yükü olarak, azıcık. |
| O04, O33 | Kuyu ikizleri: O21 seçildi (O04 de olur, 720 bin). |
| O06, O24, O80, O29 | Yosunlu duvar, ikinci yıkık duvar, uçurum duvarı, yeşil çadır: gereksiz tekrar ya da üslup. |
| O15, O16† | Sazdan damlı çamur ev (O15) Akdeniz havası; †O16 avlulu ev konak olarak seçildi. |
| K00, K01, K03, K06, K08, K11 | Çibi çocuklar, Roma askeri, düz Avrupa kılıçları (Türkmen kılıcı hafif eğri), fantastik yeşil yay, alakasız figür. |

## 5. Eksik — hazırı bulunamayan, eklenmesi gereken varlıklar

| Varlık | Durum | Oyundaki yeri |
|---|---|---|
| Selçuklu taçkapılı kervansaray (sivri kemer, boş kitabe) | B021 dışında hazır yok; B021 süslü, sadeleştirme gerekebilir. | kervansaray 1–3 |
| Konak / ağa evi (iki katlı, taş alt kat, ahşap cumbasız üst kat) | Hazır CC0 yok; O16 avlulu ev geçici. | konak 1–3 |
| Kara çadır (keçi kılı) | Hazır yok; bulunanlar kamp çadırı. | çadır çeşitliliği |
| Eğri Türkmen kılıcı, sadak + kısa yay | Hazır yok; bulunanlar Avrupa kılıcı / fantastik yay. | asker eşyası, el eşyası |
| Mescit (küçük, düz damlı, tek kubbe yok) | Bulunanlar büyük camiler. | köy merkezi (perde 2) |
| Keçe/kilim yaygısı ve yer minderi | Bulunan kilimler koltuk ya da duvar halısı. | çadır içi, pazar |
| Dövme (döven) harman aleti | Bulunamadı. | harman mini oyunu |
| İğ ve öreke (el ile yün eğirme) | Çıkrık bulundu ama Avrupa tipi; Anadolu'da iğ yaygın. | ev önü |
| Gerçekçi köy kadını / çocuk (iskeletli) | Koleksiyondakiler çibi. | köy figürleri |

## Meshy koleksiyonu

Koleksiyon oluşturmak Meshy hesabına giriş ister; buradan yapılamadı. Önerilen: **"Kapı Muhafızı — Köy (seçilmiş)"** adlı yeni koleksiyona 1. ve 2. bölümdeki bağlantıları ekle; 3. bölüm ayrı bir **"— animasyon bekleyen"** koleksiyonuna.
