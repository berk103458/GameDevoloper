# 01 — Eksik 3D modeller ve animasyonlar

Mevcut 26 model için bkz. `tools/model/meshy_uret.py` → `VARLIKLAR`. Aşağıdakiler yok.
Satırlar **aynı biçimde** yazıldı: `(tür, istem, doku, iskelet, boy_m, poligon)`. Bir satırı `VARLIKLAR`'a
yapıştırıp `--kuru` ile kredi tahmini alabilirsiniz. Ortak `STIL` ve `KARAKTER` önekleri betikte otomatik eklenir.

> Not: Meshy'nin otomatik iskeleti insan biçimli karakterler içindir. Hayvanları `iskelet=False` (duruk) bıraktım.
> Yürüyen at ya da keçi gerekirse ayrı bir hayvan iskeleti/animasyon kaynağı gerekir.

## 1. Olay kişileri (Ö1) — şu an yalnız yazıda varlar
Gece olaylarında kapıya gelen kişilerin modeli yok. Olay açılınca köy ekranında yalnız bir metin paneli çıkıyor.

| Ad | Hangi olay | Meshy satırı |
|---|---|---|
| `cavus` | Selçuklu çavuşu (`miraen_cavus`) | `("karakter", KARAKTER + "A Seljuk sergeant (cavus) on duty: lamellar vest over a kaftan, a tall felt cap, a mace at his belt, holding a folded list. Stern, tired.", True, True, 1.78, 8000)` |
| `tahsildar` | Beyin tahsildarı (`vergi_tahsildari`) | `("karakter", KARAKTER + "A tax collector of a Turkmen bey: fine dark kaftan, small turban, a ledger book held under one arm, a coin pouch at the belt.", True, True, 1.72, 8000)` |
| `tekfur_elcisi` | Tekfur'un elçisi | `("karakter", KARAKTER + "A Byzantine frontier lord's envoy: long dark tunic with an embroidered border, a short cloak pinned at the shoulder, a small round felt hat, clean shaven, a sealed scroll in hand.", True, True, 1.76, 8000)` |
| `dervis` | Gezgin derviş | `("karakter", KARAKTER + "A wandering dervish: tall conical felt hat (sikke), patched wool cloak (hirka), a wooden staff and a begging bowl (keskul) hanging from the belt.", True, True, 1.74, 8000)` |
| `haberci` | Kayseri Ahi habercisi, Ertuğrul'un habercisi | `("karakter", KARAKTER + "A young mounted courier on foot: dusty riding coat, felt cap, a leather message tube slung across the chest, riding boots.", True, True, 1.74, 8000)` |
| `turkmen_bey_adami` | Damgalı atlar (`sorhan_damga`) | `("karakter", KARAKTER + "A Turkmen bey's retainer: fur-lined felt coat, tall felt cap, a horse whip in hand, a bow case at the hip.", True, True, 1.78, 8000)` |
| `bey` | Beyin daveti | `("karakter", KARAKTER + "A local Turkmen bey: rich layered kaftan with a wide sash, fur-trimmed cap, a curved sword in a decorated scabbard, calm proud stance.", True, True, 1.8, 8000)` |

## 2. Yan karakterler (Ö2) — giriş cümlelerinde var, sahnede yok
| Ad | Neden | Meshy satırı |
|---|---|---|
| `cocuk` | Saruca'nın kucağındaki çocuk, Sorhan'ın iki çocuğu, köy kalabalığı (şu an köyde hiç çocuk yok) | `("karakter", KARAKTER + "A small village child of about seven, simple long tunic, wool cap, barefoot wraps.", True, True, 1.1, 5000)` |
| `kiz_cirak` | Ayşe Bacı'nın iki genç kızı | `("karakter", KARAKTER + "A teenage girl apprentice weaver: long dress, headscarf, a bundle of yarn in her arms.", True, True, 1.5, 6000)` |
| `erkek_cirak` | Karaca Usta'nın çırakları, esnaf şablonundaki "genç çırak" | `("karakter", KARAKTER + "A teenage boy apprentice tanner: leather apron, rolled sleeves, a small tool bag.", True, True, 1.55, 6000)` |
| `yasli` | Salgın olayı, nikâhı kıyan "köyün en yaşlısı" | `("karakter", KARAKTER + "An old bearded village elder leaning on a walking stick, long wool cloak, white turban wrap.", True, True, 1.65, 7000)` |
| `sorhan_karisi` | Sorhan'ın 2. gelişi | `("karakter", KARAKTER + "A Kipchak steppe woman: tall felt headdress with a veil, long belted coat, carrying a bundle.", True, True, 1.62, 8000)` |

## 3. Tekfur askeri (Ö1)
Şu an `koy_sahnesi.gd → _tekfur_kur()` Selçuklu `asker` modelini derin maviye boyuyor. Sanat kitabına göre Tekfur yalnız siluet olarak görünür, ama siluetin **farklı okunması** gerekir: mızrak, uzun kalkan ve miğfer.
```
"tekfur_askeri": ("karakter", KARAKTER.replace("No armour plates, no helmets with horns. ", "") + "A Byzantine frontier foot soldier (akritai): conical iron helmet with a mail aventail, long kite shield, tall spear, padded coat. Readable spiky silhouette.", True, True, 1.8, 8000),
```

## 4. Hayvanlar (Ö2) — duruk, dokulu
| Ad | Neden | Meshy satırı |
|---|---|---|
| `at` | Sorhan'ın 3 atı, Nogay'ın atı, haberci, Ertuğrul'un atlıları, kervan | `("nesne", "A lean steppe horse standing still, simple saddle cloth, rope halter, side view.", True, False, 0, 4000)` |
| `keci` | Yusuf'un keçisi ve sürüsü (`yusuf_keci`) | `("nesne", "A small Anatolian black goat standing, long hair.", True, False, 0, 1500)` |
| `koyun` | Aydoğdu'nun obası, 30 koyun | `("nesne", "A small woolly sheep standing, low poly.", True, False, 0, 1200)` |
| `okuz` | Kağnıyı çeken öküz; çiftçi şablonu "öküzü yok" der | `("nesne", "A thin grey ox standing, wooden yoke on its neck.", True, False, 0, 2500)` |
| `deve` | Halep kervanı (`kervan`) | `("nesne", "A loaded Bactrian camel standing, wool bundles and saddlebags tied on its back.", True, False, 0, 3000)` |
| `kopek` | Köy ortamı, gece bekçiliği | `("nesne", "A lean Anatolian shepherd dog (kangal) lying down.", True, False, 0, 1500)` |

## 5. Çevresel anlatım propları (Ö2) — sanat kitabı 6.4 "her iz bir kişiye"
Dokusuz (düz palet rengi) olabilirler. `Dunya3B.NESNE_RENK`'e renk eklenmeli.

| Ad | Hangi kararın izi | Meshy satırı |
|---|---|---|
| `mizrak_sehpasi` | Kışlaya yazılan asker (kışla bina değil, nöbet izi) | `("nesne", "A wooden spear rack holding four spears and one round wooden shield leaning against it.", False, False, 0, 1500)` |
| `nobet_ocagi` | Asker nöbet yeri | `("nesne", "A small ring of stones for a guard campfire with a log seat beside it, no flame.", False, False, 0, 800)` |
| `ors` | Esnaf / Ahi izi, pazar | `("nesne", "A blacksmith anvil on a tree stump with a hammer and tongs.", False, False, 0, 1200)` |
| `tarla` | `tarla` bayrağı (Saruca'nın tohumu ekildi) | `("nesne", "A small plowed field patch with straight furrows, flat, square, a few sprouts.", False, False, 0, 600)` |
| `dokuma_tezgahi` | Ayşe Bacı, `baci_tezgah` bayrağı | `("nesne", "A simple upright wooden carpet loom with a half-woven kilim.", True, False, 0, 2000)` |
| `ilac_kutusu` | Thessra'nın kutusu; olayda kilitlenir | `("nesne", "A small wooden medicine box with brass hinges and small clay vials inside.", True, False, 0, 800)` |
| `kirik_kin` | Miraen teslim edilirse "kırık kınını kapının dibine bıraktı" | `("nesne", "A broken curved sword scabbard lying on the ground.", True, False, 0, 500)` |
| `sancak` | `bey_dostu` bayrağı: "Bey'in sancağı kapının üstüne asıldı" | `("nesne", "A plain cloth banner (no symbols, no text) hanging from a horizontal wooden pole.", False, False, 0, 600)` |
| `ahi_kusagi` | `ahi_ocagi`: "Ocağın kapısına bir kuşak asıldı" | `("nesne", "A long woven cloth sash hanging from a wooden door beam, knotted.", False, False, 0, 400)` |
| `sonen_ates` | Reddedilenlerin uzak ateşi (sanat kitabı 6.4-4) | `("nesne", "A small dying campfire: a few charred logs and embers, a bedroll beside it.", False, False, 0, 600)` |
| `hasta_cadiri` | Salgın, "hastaları ayır" | `("nesne", "A small low patched cloth tent, ragged, tied with ropes.", False, False, 0, 1500)` |
| `mezar` | Saldırıda ölen köylü | `("nesne", "A simple grave mound with an unmarked upright stone (no text).", False, False, 0, 400)` |
| `yanik_ev` | "Tekfur'un adamları köyün kıyısını yaktı" | `("yapi", "A burned ruined small mud-brick hut, collapsed roof, charred beams.", True, False, 0, 3000)` |
| `dizili_taslar` | Nogay'ın uyarısı, Moğol öncü işareti | `("nesne", "A short line of five small stones placed deliberately on the ground.", False, False, 0, 300)` |
| `gozetleme_kulesi` | 2. perde, sur seviyesi | `("yapi", "A wooden frontier watchtower on four log legs with a ladder and small roofed platform.", True, False, 0, 3000)` |
| `kervan_yuku` | Kervansaray avlusu, "yük ve denk" | `("nesne", "A pile of tied cloth bales and saddlebags.", False, False, 0, 800)` |
| `davul_zurna` | Düğün | `("nesne", "A large wooden davul drum and a zurna pipe resting on a wooden bench.", True, False, 0, 1000)` |

## 6. Mevcut modellerde düzeltme (Ö2)
- **İmza şekilleri seçilmiyor.** 3D ekran görüntüsünde Miraen'in kuyruklu keçe külahı ve kırık kını görünmüyor. Meshy istemdeki ayrıntıyı atmış. Sanat kitabı 5.4'teki imza şekli her adlı karakterde 64 px siyah dolgu testinden geçmeli. Geçmeyenler `--sadece ad` ile istemi güçlendirip yeniden üretilmeli. (İmza şekilleri hâlâ art-director onayı bekliyor.)
- **Kapı sahnesinde kapı modeli kullanılmıyor.** `kapi_sahnesi.gd` kapıyı ve kanatları düz kutularla kuruyor. `kapi.glb` yalnız köyde kullanılıyor. Kapının **içeriden** görünen bir modeli gerekir (açık iki kanat, taş ve kazık duvar, nöbet yeri).
- Ağaçlar ve kayalar tek tip. 2–3 çeşit (`agac_02`, `kaya_02`) tekrarı azaltır.

## 7. Animasyonlar (Ö1)
Şu an her karakterde yalnız Meshy'nin **yürüme** animasyonu var. `karakter_model.gd → dur()` dururken
yürüme döngüsünü ilk karede donduruyor; bu yüzden karakter kapıda heykel gibi duruyor.

| Animasyon | Nerede | Not |
|---|---|---|
| **Bekleme / nefes** | Kapıda dururken, köyde | En gerekli olanı. Şu an yok |
| **Konuşma jesti** | Sohbette cevap verirken | Elle işaret, baş sallama |
| **Bakış kaçırma / başını çevirme** | Miraen "gözlerini kaçırıyor", Aydoğdu "yola bakıyor" | Diyalogdaki sahne yönergeleri |
| **Koşma** | Gece kaçanlar, haberci | Meshy iskelet sonucu koşmayı da döndürüyor, ama `meshy_uret.py` yalnız `walking_glb_url`'yi indiriyor. Betiğe `running_glb_url` eklenmeli |
| **Oturma, çalışma** (orak, çekiç, dokuma) | Köy | Köyün "yaşıyor" görünmesi için |
| **Nöbet / mızrağa dayanma** | Asker, 2. perde | |
| **Saldırı, düşme** | 2. perde savunma gecesi | bkz. 05 |

Kaynak önerisi: Meshy'nin animasyon kütüphanesi ya da Mixamo (insan biçimli iskelete aktarılabilir).
Godot tarafında `AnimationPlayer` + `AnimationTree` ile durum geçişi (`dur` → `konus` → `yuru`) kurulmalı.
