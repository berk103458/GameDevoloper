# Eksikler — oyunda henüz olmayan, üretilmesi gerekenler

*Hazırlandı: 4 Ekim 2026. Plan belgesi: [../plan/URETIM-PLANI.md](../plan/URETIM-PLANI.md).*

Bu klasör kodu, verileri ve 3D sürümün ekran görüntülerini (`production/qa/evidence/3d-1/`) tarayarak
çıkarıldı. Her madde ya **kodda doğrulanmış bir boşluk** ya da **tasarım belgelerinin istediği ama oyunda
olmayan** bir şeydir; hangisi olduğu yanında yazıyor.

| Dosya | Kapsam |
|---|---|
| [01-3d-modeller-ve-animasyon.md](01-3d-modeller-ve-animasyon.md) | Eksik karakterler, hayvanlar, iz propları, animasyonlar. İçinde **Meshy'ye hazır istem satırları** var |
| [02-ses.md](02-ses.md) | Müzik, ortam, efekt, ses imzası |
| [03-gorsel-2d-ve-arayuz.md](03-gorsel-2d-ve-arayuz.md) | Yer tutucu 2D sanat, son ekranları, logo |
| [04-hikaye-ve-diyalog.md](04-hikaye-ve-diyalog.md) | Yarım kalan hikâye kolları, prolog, epilog, diyalog derinliği |
| [05-mekanlar.md](05-mekanlar.md) | Yeni sahneler ve mevcut iki sahnenin eksikleri |

## Öncelik özeti

**Ö1 — oyunun şu anki hâlinde açık bir delik**

1. **Yarım kalmış 5 hikâye kolu.** Olaylar `thessra_kirgin`, `miraen_sadik`, `turkmen_kin`, `dervis`, `baci_tezgah` bayraklarını koyuyor, ama kod bunları hiçbir yerde okumuyor. Oyuncunun seçimi sonradan hiçbir şeyi değiştirmiyor (→ 04).
2. **Prolog yok.** Oyun "1. gece"yle açılıyor. Kösedağ'ı, muhafızın kim olduğunu ve neden bu kapıda durduğunu anlatan bir şey yok (→ 04, 05).
3. **Olaylardaki kişilerin modeli yok.** Çavuş, tahsildar, Tekfur'un elçisi, derviş ve haberci yalnız yazıda var (→ 01).
4. **Tekfur askeri gerçek bir model değil.** Selçuklu asker modeli maviye boyanıp kullanılıyor (→ 01).
5. **Karakterlerin yalnız yürüme animasyonu var.** Dururken yürüme döngüsünün ilk karesinde donuyorlar (→ 01).
6. **Sesin hepsi koddan sentezlenmiş yer tutucu**, ve tek bir müzik döngüsü var (→ 02).
7. **Savunma gecesi görünmüyor.** 2. perdedeki saldırı yalnız "güç X, savunma Y" yazısı olarak çıkıyor (→ 05).

**Ö2 — tasarım belgelerinin istediği ama yapılmamış şeyler**

- Sanat kitabının "her iz bir kişiye" kuralındaki iz propları: mızrak sehpası, örs, tarla, reddedilenlerin sönen ateşi (→ 01, 05).
- Köyde hayvan yok. Sorhan'ın atları, Yusuf'un keçisi ve Aydoğdu'nun koyunları yazıda var, sahnede yok (→ 01).
- Adlı karakterlerin imza şekilleri modellerde seçilmiyor, örneğin Miraen'in kuyruklu külahı ve kırık kını (→ 01).
- Kararın ardından karaktere özel bir tepki cümlesi yok. Herkese aynı genel satır çıkıyor (→ 04).
- Son ekranları yalnız yazı. Arka planları 2D yer tutucu (→ 03, 05).
- 2. perdenin içeriği az. Bu perdeye özel 4 olay var ve Tekfur'un bir yüzü ya da adı yok (→ 04).

**Ö3 — derinlik ve cila**

- Mevsim/kış, köy uğultusunun nüfusla artması, karakter ses imzaları, oyunun adı ve logosu, mağaza görselleri.

## Kilitte hâlâ açık olan kararlar (kullanıcının vermesi gerekir)
`design/gdd/kapi-konsept.md` → "Açık":
- Oyunun adı.
- Bar adları (Halk, Soylular, Tüccarlar, Ordu) onaylanmadı.
- Sonların adı ve koşulları. Kodda 9 son var ama bunlar geçici.
- Osmanoğulları anakronizmi: 1243'te Osman Bey henüz doğmamıştı, şu an son Ertuğrul ve Söğüt üzerinden kurulu.
- Sohbet adım sayısı (şu an en çok 2 soru).
- Dört karar düğmesi kilitte "sonra değişecek" diye geçiyor.
