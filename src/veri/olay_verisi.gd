## Gece sonu olayı: köy görünümünde seçimli bir kart (kararların sonradan gelen bedelleri).
class_name OlayVerisi
extends Resource

@export var id: StringName
@export var baslik_anahtari: String
@export var metin_anahtari: String
## Koşullar (hepsi sağlanmalı): gece_min, gece_max, perde, koyde[], ayrildi[], bayrak[], bayrak_yok[],
## nufus_min, sinif_min{}, ambar_max, akce_min, yapi_min{}, bar_max{indeks: değer}, sans (0–1).
@export var kosullar: Dictionary = {}
@export var agirlik: float = 1.0
@export var tek_sefer: bool = true
@export var secenek_anahtarlari: PackedStringArray
## Seçenek başına etki: bar[4], akce, ambar, kese, nufus{sinif: n}, bayrak, ayril (karakter id),
## sonraki_gelen (bir sonraki gece gelen sayısına ek), gerekli{akce|ambar|koyde}.
@export var secenek_etkileri: Array[Dictionary] = []
## Kart açılınca çalan efekt (`assets/ses/<ad>.wav`); boşsa genel olay sesi.
@export var ses: StringName
## Kart açıkken çalan müzik döngüsü (düğün gibi); boşsa müzik değişmez.
@export var muzik: StringName
