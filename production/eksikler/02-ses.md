# 02 — Eksik sesler

**Durum:** `assets/ses/`'teki 15 dosyanın hepsi `tools/ses/ses_uret.py` ile koddan sentezlenmiş **yer tutucu**.
Gerçek kayıt **aynı dosya adıyla** konunca oyunda hiçbir şey değişmez. (Gerçek sesler gelince bu betik
yeniden çalıştırılmamalı, yoksa onların üzerine yazar.)

## 1. Mevcutların gerçeği (Ö1)
| Dosya | Önerilen gerçek ses |
|---|---|
| `muzik_gece_dongu` | Gerçek ney + kudüm ya da bendir, Hicaz makamı, 60–90 s dikişsiz döngü |
| `ortam_mesale_dongu` | Gerçek meşale çıtırtısı + hafif rüzgâr |
| `sfx_kapi_acilir` / `_kapanir` | Ağır ahşap kapı gıcırtısı, sürgü |
| `sfx_kese` | Deri kese, sikke şıngırtısı |
| `sfx_adim` | Toprak yolda çarık adımı (2–3 çeşit, tekrar etmesin) |
| Diğerleri | Kaydedilmiş Foley ile değiştirilmeli |

## 2. Müzik (Ö1 — şu an tek parça var)
| Ad | Nerede | Not |
|---|---|---|
| `muzik_menu` | Ana menü | Yalnız ney, sade |
| `muzik_perde2_dongu` | 2. perde | Daha gergin: davul nabzı, düşük tel. Tekfur yaklaştıkça katman eklenebilir |
| `muzik_perde_gecisi` | "Köy oturdu" ekranı | 20–30 s, tek sefer |
| `muzik_saldiri` | Savunma gecesi | Kısa, sert |
| `muzik_son_*` (5 adet) | Ertuğrul, Ahi kasabası, haraç, beyin uç köyü, uç tutundu | Her sonun kendi tonu. Ertuğrul ve uç tutundu "şafak" hissi taşır |
| `muzik_kirilma` | 4 kırılma sonu | Tek, kasvetli |
| `stinger_olay` | Olay açılınca (şu an `sfx_olay`) | **İyi ya da kötü işareti vermemeli** (Sütun 2) |

## 3. Ortam (Ö2)
| Ad | Neden |
|---|---|
| `ortam_ruzgar_dongu` | Issız uç; kapı sahnesinin temel katmanı |
| `ortam_gece_hayvan` | Uzak baykuş, çakal, köpek |
| `ortam_kuyruk_mirilti` | Kapıdaki kuyruktan gelen alçak konuşma |
| `ortam_koy_dongu` (3 katman: az / orta / kalabalık) | **Köy nüfusla büyür** kuralının sesi; sanat kitabı 6.5'teki meşale sayısının işitsel karşılığı |
| `ortam_pazar` | Pazar seviyesi > 0 iken çekiç, örs, pazarlık |
| `ortam_kervansaray` | Deve çanı, yük indirme |
| `ortam_perde2_gerilim` | Uzaktan Tekfur kampının sesi, yaklaştıkça yükselir |
| `ortam_kis_dongu` | Kar ve fırtına, mevsim eklenirse (bkz. 04) |

## 4. Efektler (Ö2)
| Ad | Hangi an |
|---|---|
| `sfx_at_kisneme`, `sfx_at_nal` | Sorhan, Nogay, haberci, Ertuğrul'un atlıları |
| `sfx_keci`, `sfx_koyun` | Yusuf'un keçisi, Aydoğdu'nun obası |
| `sfx_oksuruk` | Salgın olayı |
| `sfx_davul_zurna` | Düğün (kısa) |
| `sfx_dokuma` | Ayşe Bacı'nın tezgâhı |
| `sfx_tekfur_boru` | Saldırı başlıyor |
| `sfx_ok`, `sfx_kilic`, `sfx_nara` | Savunma gecesi (şu an tek `sfx_saldiri` var) |
| `sfx_yangin` | "Köyün kıyısını yaktı" |
| `sfx_rusvet_harcandi` | Bar kırılmak üzereyken kese gidiyor (`anlati.rusvet.harcandi`). Şu an buna özel bir ses yok |
| `sfx_perde_gong` | Perde geçişi |
| `sfx_sayfa` | Olay ve son metni açılırken |
| `sfx_defter_yak` | Hasan'ın defteri yakılırsa |

## 5. Ses imzası / seslendirme (Ö3)
Tam seslendirme önermiyorum: kapsamı çok büyütür ve metin anlatı-konuşma ayrımıyla zaten çalışıyor.
Bunun yerine **her adlı karaktere 2–3 kısa ses** öneriyorum, gelişte ve cevapta çalar:
- Nefes, "hı", kısa bir "bilmem" gibi. Dil ipucu verebilir: Miraen'den Gürcüce, Nogay'dan Moğolca, Thessra'dan Rumca tek bir kelime.
- Kadın, erkek, yaşlı ve çocuk için adsız figürlere genel ses setleri.
