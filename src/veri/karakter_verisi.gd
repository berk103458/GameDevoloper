## Bir adlı karakterin değişmez verisi (design/gdd/karakter-kadrosu.md, Core Rules 14).
class_name KarakterVerisi
extends Resource

## CHR metinleri ayrı kaynakta: SYS-09 birleşene kadar CSV yazılmaz.
@export var metinler: Dictionary = {}
@export var spawn_kosulu: String = ""
@export var persona_maskesi: String = ""
@export var gizlenen_gercek: String = ""
@export var sfx: String = ""
@export var kosullu_etkiler: Array[Dictionary] = []

## KVR-09: on_accept/on_reject/on_bribe/on_jail -> {entity_id, offset}.
@export var sonraki_spawns: Dictionary = {}

## KVR-08: tur_offset/hedef_bina/olay_id/stat_etkisi; isteğe bağlı karar/kosullar.
@export var gecikmeli_etkiler: Array[Dictionary] = []

## KVR-07: eski dört bar etki_* dizilerinden bağımsız beş köy statı.
## Karar -> {stat_etkisi: {Refah/Erzak/Guvenlik/Moral/Saglik: int},
## muhafiz_akce: int, esyalar: Array, kosullar: Dictionary}.
## Aynı kararın koşullu sonuçları için varyantlar: Array[Dictionary].
@export var karar_matrisi: Dictionary = {}

func karar_verisi(karar: StringName) -> Dictionary:
	return preload("res://src/sistemler/chr_runtime_sinirlari.gd").karar(karar_matrisi.get(String(karar), {}))

## KVR-06: başlangıç verisi; her sorgu kendi kopyasını kullanır.
@export var sorgu_bayraklari: Dictionary = {
	"Flag_Yol_Sirri_Acik": false,
	"Flag_Kimlik_Cozuldu": false,
	"Flag_Sir_Tamamen_Cozuldu": false,
	"Flag_Kilitlendi": false
}

func yeni_sorgu_bayraklari() -> Dictionary:
	return sorgu_bayraklari.duplicate(true)

## KVR-05: düğüm kimliği -> replik_anahtari, secenekler dizisi.
## Seçenek: metin_anahtari, hedef, tansiyon_delta; kaynak kimliği aynen kalır.
@export var diyalog_dugumleri: Dictionary = {}

## Kopya döndürülür: bir sorgunun değişiklikleri paylaşılan kaynağı etkilemez.
func diyalog_dugumu(dugum_id: StringName) -> Dictionary:
	return diyalog_dugumleri.get(String(dugum_id), {}).duplicate(true)

## KVR-04: kaynak görsel ipucu ve pozları; sınırlar sorgu sözleşmesidir.
@export var gorsel_hata_ipucu: StringName = &""
@export_range(1, 3, 1) var baslangic_tansiyonu: int = 2
@export var animasyon_anahtarlari: Dictionary = {
	"Idle": &"Idle", "Stressed": &"Stressed", "Panic": &"Panic"
}
@export var gorsel_hata: String = ""
@export var sir_baglantisi: String = ""
@export var poz_aciklamalari: Dictionary = {}

func tansiyon_animasyonu(tansiyon: int) -> StringName:
	var durum := "Idle" if tansiyon < 4 else "Stressed" if tansiyon < 8 else "Panic"
	return StringName(animasyon_anahtarlari.get(durum, durum))

## KVR-03: açıklama kaynak Obje_1_Nişan / Obje_2_Yük metnidir.
@export var obje_1: Dictionary = {"aciklama": "", "uretilen_ipucu": &""}
@export var obje_2: Dictionary = {"aciklama": "", "uretilen_ipucu": &""}

## Sorgu/heybe adaptörleri tek sözleşmeden ipucu alır; kaynak değiştirilmez.
func obje_ipucu(sira: int) -> StringName:
	var obje := obje_1 if sira == 1 else obje_2 if sira == 2 else {}
	return StringName(obje.get("uretilen_ipucu", &""))

## KVR-02: kaynak Secere_Matrisi ve Köy_içi_Davranış adları korunur.
@export var secere_matrisi: Dictionary = {
	"Doğum_Yeri": "", "Aile_Bağı": "", "Kırılma_Olayı": ""
}
@export var koy_ici_davranis: Dictionary = {
	"Gündüz_Döngüsü": "", "Gece_Döngüsü": ""
}

## KVR-01 kimliği; CHR kimliği büyük harfle, eski runtime `id` alanı küçük harfle korunur.
@export var entity_id: StringName:
	get:
		return StringName(String(id).to_upper()) if String(id).begins_with("chr_") else id
	set(deger):
		id = StringName(String(deger).to_lower()) if String(deger).begins_with("CHR_") else deger
## Kaynak sayfadaki gerçek ad; eski `ad_anahtari` çeviri sözleşmesi değişmez.
@export var ad: String = ""
## Kaynak sayfadaki Sadakat_Fraksiyonu; bilinmeyen içerik için boş bırakılır.
@export var fraksiyon: StringName = &""
## KVR-01 tur alt sınırı; eski kadronun kullandığı `en_erken_gece` ile aynı değerdir.
@export var en_erken_tur: int:
	get:
		return en_erken_gece
	set(deger):
		en_erken_gece = deger

## Kimlik; dosya adına eşit, ASCII snake_case.
@export var id: StringName
## Ad metninin çeviri anahtarı (`karakter.<id>.ad`).
@export var ad_anahtari: StringName
## `yabanci` ya da `yerel`.
@export var koken: StringName
## Kabul edilince köye yazılan sınıf: `asker`, `esnaf`, `ciftci`.
@export var sinif: StringName
## Bu karakterin sohbet kaydı (`data/sohbetler/<id>.tres`).
@export var sohbet_id: StringName
## Bu karaktere sunulan karar kimlikleri (Karar 7'nin tanıdıkları).
@export var karar_secenekleri: PackedStringArray
## Karar başına bar etkileri; sıra `OyunAyarlari.bar_anahtarlari` ile aynı.
@export var etki_kabul: PackedInt32Array
@export var etki_ret: PackedInt32Array
@export var etki_rusvet: PackedInt32Array
@export var etki_kisla: PackedInt32Array
## `hic_donmez`, `oranla_doner` ya da `birden_cok_gelir`.
@export var donus_kurali: StringName
@export var p0: float = 0.6
@export var d: float = 0.5
@export var k_azami: int = 4
@export var n_ziyaret: int = 1
@export var g_min: int = 2
@export var g_max: int = 4
## Bu geceden (gun_sayaci) önce gelmez.
@export var en_erken_gece: int = 0
## Portre dosya kökü: `char_<portre>_neutral_card.png`.
@export var portre: StringName
## Bu karaktere sorulabilecek en çok soru; 0 = genel ayar (`OyunAyarlari.azami_soru`).
@export var azami_soru: int = 0
## Kötü niyetli mi (karakter sayfasındaki fraksiyon): retteki tepki öfke olur, masumda yıkılma.
@export var tehlikeli: bool = false
## Zanaat yeteneği 1–10 (köyde üretim formülü); 0 = kimlikten türetilir.
@export var zanaat: int = 0
## Kapıda açılmazsa köye gizli taşınan gerçekler (`casus_suphesi`, `hirsiz`, `hasta`, `usta_ciftci` …).
@export var gizli_bayraklar: PackedStringArray = []


## Verilen kararın bar etkisini döner; tanınmayan karar için boş dizi.
func etki(karar: StringName) -> PackedInt32Array:
	match karar:
		&"kabul":
			return etki_kabul
		&"ret":
			return etki_ret
		&"rusvet":
			return etki_rusvet
		&"kisla":
			return etki_kisla
	return PackedInt32Array()
