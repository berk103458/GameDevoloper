# 05 — Eksik mekânlar ve sahneler

Oyunda şu an **iki 3D mekân** var: kapı (`kapi_sahnesi.gd`) ve köy (`koy_sahnesi.gd`). Kapı sahnesi menüde de arka plan
olarak kullanılıyor. Olaylar, perde geçişi ve sonlar düz panel ya da 2D yer tutucu arka plan üzerinde açılıyor.

## 1. Yeni sahneler

| Sahne | Öncelik | Ne için | İçerik önerisi |
|---|---|---|---|
| **Savunma gecesi** | Ö1 | 2. perdenin kalbi. Şu an saldırı yalnız "güç X, savunma Y" yazısı | Köy sahnesinin varyantı: Tekfur siluetleri sura gelir, meşaleler yanar, oklar ve bağırışlar duyulur. Sonuç: geri döndüler / kıyı yandı (`yanik_ev`, `mezar`). Refleks yok (anti-sütun), yalnız izlenir |
| **Prolog** | Ö1 | Oyunun açılışı (bkz. 04) | Kösedağ sonrası yol: devrilmiş kağnı, söndürülmüş kervan ateşi, uzakta duman. Kamera yürüyerek kapıya gelir, kapı ilk kez açılır |
| **Olay sahnelemesi kapıda** | Ö2 | Çavuş, tahsildar, elçi, derviş, haberci, kervan kapıya **gelir** | Ayrı mekân gerekmez: kapı sahnesi yeniden kullanılır, olay kişisi yürüyerek gelir (modeller: 01 §1) |
| **Son sahneleri** (5) | Ö2 | Sonlar şu an yalnız yazı | Ertuğrul: şafakta batıdan atlılar. Ahi kasabası: kalabalık pazar günü. Haraç: kese Tekfur'un adamına verilir. Beyin uç köyü: kapıda sancak, yerinde başka bir muhafız. Uç tutundu: kar sonrası boş yol, sabah |
| **Perde geçişi** | Ö2 | "Köy oturdu" | Kamera köyün üstünden yükselir, bütün meşaleler tek kadraja girer (sanat kitabı 2.6) |
| **Ağanın yeri** | Ö3 | 2. perdede oyuncu ağa olur ama hâlâ kapıdan bakıyor | Kapının üstünde bir nöbet odası ya da köyde küçük bir divan; olay kararları buradan verilir |
| **Kervansaray avlusu** | Ö3 | Kervan olayı, kervansaray seviyeleri | İç avlu, develer, yük denkleri |
| **Ahi ocağı / pazar meydanı** | Ö3 | Ahi ocağı ve Kayseri haberi olayları | Örs, tezgâhlar, kapıda kuşak |

## 2. Mevcut iki sahnenin eksikleri

### Kapı
- Kapı ve duvar düz kutularla kurulu; `kapi.glb` burada kullanılmıyor (01 §6).
- **Reddedilenlerin sönen ateşi yok.** Sanat kitabı 6.4-4 bunu kullanıcı kararı olarak istiyor: reddedilen biri kuyruğun uzağında küçük bir ateş yakar, ateş geceler geçtikçe söner.
- Kapıda muhafızın kendi izi yok: nöbet ocağı, mızrağı, fener.
- 2. perdede kapı sahnesi değişmiyor. Sur ve gözetleme kulesi kapının yanında da görünmeli.

### Köy
- **İz propları yok** (sanat kitabı 6.4): Kışlaya yazılan askerlerin mızrak sehpası ve nöbet ocağı, esnafın örsü, çiftçinin tarlası, `tarla` bayrağı gelince sürülmüş toprak. Şu an köy yalnız ev, çadır ve meşaleyle büyüyor.
- **Adlı karakterlerin köyde bir yeri yok.** Thessra'nın ilaç kutusu, Ayşe'nin tezgâhı, Hasan'ın defteri, Yusuf'un keçileri görünmüyor (sanat kitabı 6.4-3: "özel karakterin izi kendi imza şeklini tekrar eder").
- **Hayvan, çocuk ve yaşlı yok.** Köy yalnız yetişkin figürlerle doluyor.
- **Yol ve patika yok.** Evler kuyunun çevresinde boşlukta duruyor.
- **Olay sonuçları sahnede görünmüyor:** düğün ateşi, salgında köy dışındaki hasta çadırı, kaçanlar, kapıya asılan sancak ya da kuşak, ölenin mezarı.
- **Mevsim yok.** Kış eklenirse kar örtüsü ve donmuş kuyu.
- 32 figür sınırı büyük köylerde kalabalığı kesiyor. Uzak figürler için ucuz bir billboard ya da LOD gerekir.

## 3. Uzak manzara
- Tepeler düz kutu. 2. perdede **Tekfur kampının ateşleri** (anlatıda "Uzakta Tekfur'un adamlarının ateşleri görüldü" diye geçiyor) ufukta görünmeli.
- "Ufukta duman" olayı için doğu tepelerinin ardında bir duman sütunu.
- Moğol öncülerinin dizili taşları yol kenarında (Nogay olayı).
