## Köy yönetimi ayar değerleri; tümü veridir (`data/ayarlar/koy.tres`). Kurallar: design/gdd/koy-yonetimi.md.
class_name KoyAyarlari
extends Resource

@export_group("Takvim")
## Bir mevsimin gün sayısı; dört mevsim bir yıl.
@export var mevsim_gun: int = 7
## Mevsim sırası (çeviri anahtarı soneki). Sonuncusu kış.
@export var mevsimler: PackedStringArray = ["ilkbahar", "yaz", "sonbahar", "kis"]

@export_group("Ambar")
@export var ambar_taban_kapasite: int = 150
## Her ambar binası bu kadar kapasite ekler.
@export var ambar_bina_kapasite: int = 100
@export var baslangic_kaynak: Dictionary = {"gida": 30, "odun": 20, "tas": 5, "kereste": 4, "alet": 2}

@export_group("Tüketim")
## Kişi başı gecelik gıda.
@export var gida_kisi: int = 1
## Eski denge alanı uyumluluk için korunur; EKO-09 odun_kisi dış JSON verisini kullanır.
@export var kis_odun_hane: int = 1
## Odun yetmezse kışın her gece sağlık kaybı.
@export var soguk_saglik: int = 15
## Gıda yetmezse sağlık ve moral kaybı; verim bu çarpanla düşer.
@export var aclik_saglik: int = 10
@export var aclik_moral: int = 15
@export var aclik_verim: float = 0.5
## Tok ve barınaklı köylünün gecelik sağlık iyileşmesi.
@export var iyilesme: int = 5

@export_group("Akçe")
@export var akce_baslangic: int = 10
## Ham maddelerin kervan fiyatı (akçe / birim).
@export var kervan_fiyat: Dictionary = {"gida": 0.25, "odun": 0.25, "tas": 0.34, "kereste": 1.0, "alet": 3.0, "kurk": 2.0}
## Kervanın sattıkları (akçe / birim).
@export var kervan_satis: Dictionary = {"demir": 2.0, "alet": 5.0, "gida": 0.5, "odun": 0.5}
## Köy tezgâhı kervan fiyatının bu oranından alır; günde en çok bu kadar akçe öder.
@export var tezgah_orani: float = 0.6
@export var tezgah_gunluk_azami: int = 4
@export var kervan_araligi: int = 4
## Haftalık vergi (hafta başı): düz işçi ve usta başına.
@export var vergi_isci: int = 1
@export var vergi_usta: int = 3
## Bu kadar akçe savunma ve lüks harcamalara kilitlidir (iflas koruması).
@export var rezerv: int = 5
## Muhafız başına günlük maaş (haftada 7).
@export var muhafiz_maas: int = 1
@export var muhafiz_azami: int = 2

@export_group("Sur")
## Sur seviyesi başına toplam bedel; taksitle ödenir.
@export var sur_bedel: PackedInt32Array = [12, 20, 32]
@export var sur_taksit: int = 4

@export_group("Kapı kararları")
## Haksız kapı harcı: alınan akçe; köylünün sadakati bu oranda düşer; adalet bu kadar azalır.
@export var harc_akce: int = 2
@export var harc_sadakat_orani: float = 0.3
@export var harc_adalet: int = 8
## Rüşvetle şüpheli kabulü: asayiş riski artışı.
@export var rusvet_asayis: int = 12
## Usta reddedilip zengin alınırsa herkesin morali düşer.
@export var iltimas_moral: int = 6
@export var baslangic_sadakat: int = 60
@export var baslangic_moral: int = 60

@export_group("Husumet")
@export var husumet_gerekceli: int = 1
@export var husumet_haksiz: int = 3
@export var husumet_sonum: int = 1
@export var sizma_esigi: int = 5
@export var sizma_zar: float = 0.25
@export var baskin_esigi: int = 10
@export var baskin_zar: float = 0.4
## Her muhafız zarı bu kadar düşürür.
@export var muhafiz_zar_indirimi: float = 0.1

@export_group("Üretim")
@export var flag_carpanlari: Dictionary = {"usta": 1.3, "olumsuz": 0.7}
@export var carpan_alt: float = 0.4
@export var carpan_ust: float = 1.5
## Morali bu değerin üstündeki çalışana kritik üretim bonusu.
@export var kritik_moral: int = 80
@export var kritik_bonus: float = 0.2
## Boştaki her bu kadar köylü inşaatı bir gün daha kısaltır.
@export var insa_yardim_bolen: int = 3
@export var yikim_iade: float = 0.5

@export_group("Moral ve isyan")
@export var evsiz_moral: int = 8
@export var tok_moral: int = 2
@export var asayis_moral_esigi: int = 50
@export var guvensiz_moral: int = 4
@export var adalet_moral_esigi: int = 30
@export var adaletsiz_moral: int = 3
## Köy huzuru bu değere inince isyan sayacı başlar.
@export var isyan_esigi: int = 10
@export var isyan_gun: int = 3
@export var as_dagit_gida: int = 2
@export var as_dagit_moral: int = 15
@export var vergi_sifirla_moral: int = 10
@export var surgun_moral: int = 8
## Asayiş riski her gece kendiliğinden bu kadar azalır; muhafız başına ek azalma.
@export var asayis_sonum: int = 2
@export var muhafiz_asayis: int = 5

@export_group("Aşamalar ve son")
@export var agalik_nufus: int = 18
## Emniyet kilidi: köy en az bir kez bu nüfusa ulaşmış VE bu gün geçmiş olmalı.
@export var emniyet_nufus: int = 5
@export var emniyet_gun: int = 4
@export var kirilma_nufus: int = 3
@export var harac_araligi: int = 7
@export var harac_akce: int = 10
@export var harac_gida: int = 20
## Tekfur'un baskısı her reddedilen haraçta artar; bu kadar baskı savuşturulunca zafer.
@export var zafer_bask_sayisi: int = 3

@export_group("Izgara")
@export var izgara_boyut: Vector2i = Vector2i(24, 24)
## Köy meydanı (sol üst hücre ve boyut).
@export var meydan: Rect2i = Rect2i(10, 10, 4, 4)
