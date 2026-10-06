# Köy görsel planı

Claude sohbetindeki son devralma yanıtından 6 Ekim 2026 tarihinde erişilebilirlik metni olarak aktarılmıştır. Örnek kod ve performans rakamları taslak hedeflerdir; ölçülmüş sonuç değildir.

## BÖLÜM A — ARAZİ VE ÇEVRE

## 1. Arazi Zemini (Splat Map / Terrain Shader)

- Amaç: Düz ve tek renk kahverengi zemin yerine; çimen, sıkışmış toprak, çamur ve kuru ot dokularını arazi eğimine ve köylü trafiğine göre harmanlayan organik bir taban oluşturmak.

- Godot Yapısı: MeshInstance3D (Subdivided PlaneMesh: 128x128 segment) + ShaderMaterial.

- Örnek Kod / Shader:

// res://src/koy/gorsel/arazi_zemini.gdshader

shader_type spatial

;

render_mode diffuse_burley

,

specular_schlick_ggx

;

uniform



sampler2D

doku_cimen : source_color

,

filter_linear_mipmap_anisotropic

;

uniform



sampler2D

doku_toprak : source_color

,

filter_linear_mipmap_anisotropic

;

uniform



sampler2D

doku_camur : source_color

,

filter_linear_mipmap_anisotropic

;

uniform



sampler2D

maske_splat : hint_default_black

;

// R: Toprak/Yol, G: Çamur

uniform



float

uv_olcek

=



32.0

;

void



fragment

()



{

vec2 d_uv

=

UV

*

uv_olcek

;

vec3 cimen

=



texture

(

doku_cimen

,

d_uv

).

rgb

;

vec3 toprak

=



texture

(

doku_toprak

,

d_uv

).

rgb

;

vec3 camur

=



texture

(

doku_camur

,

d_uv

).

rgb

;

vec4 maske

=



texture

(

maske_splat

,

UV

);

vec3 son_renk

=



mix

(

cimen

,

toprak

,

maske

.

r

);

son_renk

=



mix

(

son_renk

,

camur

,

maske

.

g

);

ALBEDO

=

son_renk

;

ROUGHNESS

=



mix

(

0.85

,



0.5

,

maske

.

g

);

// Çamurlu kısımlar ıslak parlar

}

- Performans Notu: 4K dokular yerine 1024x1024 boyutunda texture atlas veya 3 kanallı tek bir splat map kullanın. 4 GB VRAM için bellek ayak izi 35 MB'ı geçmez.

- Öncelik: V1 (Kritik)

## 2. Bitki Örtüsü ve Rüzgâr Shader'ı

- Amaç: Köyün sınırlarını çorak kazık çit yerine doğal meşe/çam ormanı kuşağı ve zemin çimenleriyle çevrelemek; arazide rüzgâr hareketliliği sağlamak.

- Godot Yapısı: MultiMeshInstance3D (Çimen ve ağaçlar için ayrı node'lar) + Vertex Shader rüzgâr deformasyonu.

- Örnek Kod:

# res://src/koy/gorsel/bitki_yoneticisi.gd

extends



Node3D

@export



var

agac_mesh

:



Mesh

@export



var

agac_sayisi

:



int



=



150

@onready



var

agac_multimesh

:



MultiMeshInstance3D



=



$

Agaclar

func



_ready

()



->



void

:

agac_multimesh

.

multimesh

=



MultiMesh

.

new

()

agac_multimesh

.

multimesh

.

transform_format

=



MultiMesh

.

TRANSFORM_3D

agac_multimesh

.

multimesh

.

mesh

=

agac_mesh

agac_multimesh

.

multimesh

.

instance_count

=

agac_sayisi



var

rnd

=



RandomNumberGenerator

.

new

()

rnd

.

seed

=



1234



for

i

in



range

(

agac_sayisi

)

:



# Köyün merkezinden uzakta (çevre orman kuşağı) halka şeklinde dağıt



var

aci

=

rnd.

randf_range

(

0

,

TAU

)



var

mesafe

=

rnd.

randf_range

(

35.0

,



75.0

)



var

pos

=



Vector3

(

cos

(

aci

)



*

mesafe,

0.0

,

sin

(

aci

)



*

mesafe

)



var

t

=



Transform3D

()

.

scaled

(

Vector3

.

ONE



*

rnd.

randf_range

(

0.8

,



1.3

))

t

.

origin

=

pos

agac_multimesh

.

multimesh.

set_instance_transform

(

i

,

t

)

- Performans Notu: 5000 çimen ve 200 ağaç MultiMesh ile tek draw-call'da çizilir. GPU instancing sayesinde RTX 3050'de kare hızına etkisi 0.2 ms'dir.

- Öncelik: V1 (Kritik)

## 3. Doğal Yollar ve Dinamik Patikalar

- Amaç: Oyuncunun döşediği taş/çakıl yollar ile köylülerin sık yürüdüğü rotalarda zamanla toprağın ezilerek belirginleştiği organik patika hissi.

- Godot Yapısı: Decal (Genişliği ayarlanabilir çamur/toprak patika) veya Splat Map dinamik Viewport boyama. V1 için Decal sistemi en hızlı ve modüler çözümdür.

- Örnek Kod:

# res://src/koy/gorsel/yol_decal_olusturucu.gd

extends



Node3D

@export



var

yol_kaplamasi

:



Texture2D

func



patika_segmenti_olustur

(

baslangic

:



Vector3

,



bitis

:



Vector3

,



genislik

:



float



=



2.5

)



->



void

:



var

decal

=



Decal

.

new

()

decal

.

texture_albedo

=

yol_kaplamasi



var

orta_nokta

=



(

baslangic

+

bitis

)



*



0.5



var

uzunluk

=

baslangic.

distance_to

(

bitis

)

decal

.

size

=



Vector3

(

genislik,

2.0

, uzunluk

)



add_child

(

decal

)

decal

.

global_position

=

orta_nokta

+



Vector3

(

0

,

0.5

,

0

)

decal.

look_at

(

bitis

,



Vector3

.

UP

)

- Performans Notu: Fazla sayıda Decal overdraw oluşturabilir. Yollar parsel tabanlı grid üzerinde birleştirilerek maksimum 20-30 Decal ile sınırlandırılmalıdır.

- Öncelik:V1

## 4. Çevresel Props ve Otomatik Bina Dekoru

- Amaç: Binaların etrafına odun yığınları, fıçılar, çit parçaları, çuvallar serpiştirerek "inşaat yapılıp bırakılmış" hissini kırıp yaşanmışlık katmak.

- Godot Yapısı: KoyBinasi sahnesinin içine gömülü rastgele açılan dekor node'ları (Marker3D + rastgele prop instancing).

- Örnek Kod:

# res://src/koy/gorsel/bina_dekoratator.gd

extends



Node3D

@export



var

prop_havuzu

:



Array

[

PackedScene

]



=



[]

@export



var

min_prop

:



int



=



2

@export



var

maks_prop

:



int



=



4

func



_ready

()



->



void

:



if

prop_havuzu.

is_empty

()

:



return



var

adet

=



randi_range

(

min_prop

,

maks_prop

)



for

i

in



range

(

adet

)

:



var

prop_sahnesi

=

prop_havuzu.

pick_random

()



var

prop

=

prop_sahnesi.

instantiate

()



as



Node3D



add_child

(

prop

)



var

ofset

=



Vector3

(

randf_range

(

-

2.0

,



2.0

)

,

0

,

randf_range

(

-

2.0

,



2.0

))

prop

.

position

=

ofset

prop

.

rotation

.

y

=



randf_range

(

0

,

TAU

)

- Performans Notu: Prop'lar tekil collision taşımamalıdır (StaticBody3D eklemeyin), sadece görsel mesh olmalıdır.

- Öncelik: V1

## 5. Atmosfer, Sis ve Dönem Işıklandırması (Kandil / Meşale)

- Amaç: Gündüz sarımtırak sınır güneşi, akşam kızıllığı ve gece kandil aydınlatması; odun ateşi dumanları ile derinlik hissi.

- Godot Yapısı:WorldEnvironment (Volumetric Fog, Tonemap: Filmic) + DirectionalLight3D + Az sayıda OmniLight3D + Emissive malzemeler.

- Örnek Kod:

# res://src/koy/gorsel/atmosfer_yoneticisi.gd

extends



Node3D

@onready



var

gunes

:



DirectionalLight3D



=



$

GunesIzigi

@onready



var

dunya_ortami

:



WorldEnvironment



=



$

WorldEnvironment

func



faz_isigini_guncelle

(

faz_adi

:



String

)



->



void

:



var

tween

=



create_tween

()

.

set_parallel

(

true

)



match

faz_adi:



"Gunduz"

:

tween.

tween_property

(

gunes

,



"light_energy"

,



1.2

,



2.0

)

tween.

tween_property

(

gunes

,



"light_color"

,



Color

(

"fff4db"

),



2.0

)

gunes

.

rotation_degrees

=



Vector3

(

-

45

,

30

,

0

)



"Aksam"

:

tween.

tween_property

(

gunes

,



"light_energy"

,



0.6

,



2.0

)

tween.

tween_property

(

gunes

,



"light_color"

,



Color

(

"e06d3b"

),



2.0

)

gunes

.

rotation_degrees

=



Vector3

(

-

15

,

65

,

0

)



"Gece"

:

tween.

tween_property

(

gunes

,



"light_energy"

,



0.05

,



2.0

)

tween.

tween_property

(

gunes

,



"light_color"

,



Color

(

"2a3a59"

),



2.0

)

gunes

.

rotation_degrees

=



Vector3

(

-

80

,

0

,

0

)

- Performans Notu: Her çadırın önüne gerçek OmniLight koymak 4 GB VRAM'de gölge haritası darboğazı yaratır. Yalnızca merkezi kamp ateşinde gölgeli ışık kullanın; kandiller için sadece gölgesiz OmniLight3Dve parlak StandardMaterial3D.emission tercih edin.

- Öncelik: V1 (Kritik)

## BÖLÜM B — KÖYLÜ HAREKETİ VE YAPAY ZEKÂ

## 6. Navigasyon ve Dinamik Engel Sistemi

- Amaç: Köylülerin binaların veya çitlerin içinden geçmeden, oluşturulan yolları tercih ederek hedeflerine yürümesi.

- Godot Yapısı:NavigationRegion3D (Hafif bake) veya Grid tabanlı AStar3D. (2 kişilik ekip için en hafif ve sorunsuz olanı AStar3D grid düğümleridir).

- Örnek Kod:

# res://src/koy/ai/koy_navigasyon.gd

extends



Node

var

astar

=



AStar3D

.

new

()

var

grid_boyutu

:



float



=



2.0

func



dugum_id_al

(

pos

:



Vector3

)



->



int

:



var

x

=



int

(

round

(

pos

.

x

/

grid_boyutu

))



var

z

=



int

(

round

(

pos

.

z

/

grid_boyutu

))



return

x

*



10000



+

z

func



engel_ekle

(

pos

:



Vector3

,



yaricap

:



float

)



->



void

:



var

merkez_id

=



dugum_id_al

(

pos

)



if

astar.

has_point

(

merkez_id

)

:

astar.

set_point_disabled

(

merkez_id

,



true

)

func



rota_bul

(

baslangic

:



Vector3

,



hedef

:



Vector3

)



->



PackedVector3Array

:



var

id1

=

astar.

get_closest_point

(

baslangic

)



var

id2

=

astar.

get_closest_point

(

hedef

)



return

astar.

get_point_path

(

id1

,

id2

)

- Performans Notu:AStar3D CPU tarafında çalışır ve Physics/Navigation thread'ine yük bindirmez. 30 köylü için anlık rota sorgusu 0.01 ms sürer.

- Öncelik:V1

## 7. Günlük Rutin Durum Makinesi

- Amaç: Köylülerin heykel gibi durmasını önleyip sabah işe gitmelerini, akşam köy meydanında toplanmalarını, gece çadırlarına dönmelerini sağlamak.

- Godot Yapısı: CharacterBody3D içine gömülü State Machine enum yapısı.

- Örnek Kod:

# res://src/koy/ai/koylu_ai.gd

extends



CharacterBody3D

enum



RutinDurumu



{

UYKUDA, ISE_GIDERKEN, CALISIYOR, DINLENMEDE, MEYDANDA

}

var

suanki_durum

:



RutinDurumu



=



RutinDurumu

.

DINLENMEDE

var

hedef_nokta

:



Vector3

var

hareket_hizi

:



float



=



2.2

var

hedef_yol

:



PackedVector3Array



=



[]

func



duruma_gec

(

yeni_durum

:



RutinDurumu

,



hedef

:



Vector3

)



->



void

:

suanki_durum

=

yeni_durum

hedef_nokta

=

hedef

hedef_yol

=



KoyYonetimi

.

navigasyon.

rota_bul

(

global_position

,

hedef_nokta

)

func



_physics_process

(

delta

:



float

)



->



void

:



if

hedef_yol.

is_empty

()

:



return



var

hedef

=

hedef_yol

[

0

]



if

global_position.

distance_to

(

hedef

)



<



0.4

:

hedef_yol.

remove_at

(

0

)



if

hedef_yol.

is_empty

()

:



_hedefe_varildi

()



return



var

yon

=



(

hedef

-

global_position

)

.

normalized

()

velocity

=

yon

*

hareket_hizi



move_and_slide

()



look_at

(

Vector3

(

hedef.x, global_position.y, hedef.z

),



Vector3

.

UP

)

func



_hedefe_varildi

()



->



void

:



if

suanki_durum

==



RutinDurumu

.

ISE_GIDERKEN

:

suanki_durum

=



RutinDurumu

.

CALISIYOR



$

AnimPlayer

.

play

(

"calisiyor"

)

- Performans Notu:_physics_process her köylüde her karede değil, yalnızca yürüyüş esnasında aktif olmalı; durduğunda devre dışı bırakılmalıdır (set_physics_process(false)).

- Öncelik: V1 (Kritik)

## 8. Çalışma Animasyonları ve Alet Bağlantısı (BoneAttachment3D)

- Amaç: Tarladaki köylünün çapa, hızarhanedekinin balta, taş ocağındakinin kazma tutması ve döngüsel animasyon oynatması.

- Godot Yapısı: AnimationPlayer + BoneAttachment3D (Sağ el kemiğine bağlı alet modelleri).

- Örnek Kod:

# res://src/koy/gorsel/koylu_ekipman.gd

extends



Node3D

@onready



var

sag_el_baglantisi

:



BoneAttachment3D



=



$

Armature/Skeleton3D/SagEl

@onready



var

balta

:



Node3D



=



$

Armature/Skeleton3D/SagEl/Balta

@onready



var

capa

:



Node3D



=



$

Armature/Skeleton3D/SagEl/Capa

@onready



var

kazma

:



Node3D



=



$

Armature/Skeleton3D/SagEl/Kazma

func



alet_kusandir

(

meslek_tipi

:



String

)



->



void

:

balta

.

visible

=



false

capa

.

visible

=



false

kazma

.

visible

=



false



match

meslek_tipi:



"oduncu"

: balta

.

visible

=



true



"ciftci"

: capa

.

visible

=



true



"madenci"

: kazma

.

visible

=



true

- Performans Notu: Düşük poligonlu aletler (her biri < 80 poligon) doğrudan karakter GLTF içinde tutulmalı, dinamik instancing yerine görünürlük toggle'ı ile yönetilmelidir.

- Öncelik:V1

## 9. Sosyal Davranış (Meydan Sohbetleri ve Ateş Başı)

- Amaç: Boşta gezen köylülerin meydandaki ateş etrafında oturması veya ikili gruplar halinde durup jest/mimik animasyonları sergilemesi.

- Godot Yapısı: Köy meydanına yerleştirilen Marker3D (Sohbet Slotları) + Mesafeye dayalı AudioStreamPlayer3D (Hafif dönem mırıltısı).

- Örnek Kod:

# res://src/koy/ai/meydan_alani.gd

extends



Area3D

@export



var

toplanma_noktalari

:



Array

[

Marker3D

]



=



[]

var

oturan_koyluler

:



Array

[

Node3D

]



=



[]

func



bos_nokta_al

()



->



Vector3

:



for

nokta

in

toplanma_noktalari:



if

nokta.

get_child_count

()



==



0

:



return

nokta

.

global_position



return

global_position

+



Vector3

(

randf_range

(

-

2

,



2

)

,

0

,

randf_range

(

-

2

,



2

))

- Performans Notu: Mırıltı sesleri her köylü için ayrı oynatılmaz. Meydanın merkezine 1 adet 3D Audio Stream yerleştirilir; köylü sayısı 3'ü geçtiğinde ses seviyesi artırılır.

- Öncelik: V1

## 10. Kalabalık Kaçınması ve Hız Çeşitliliği

- Amaç: Köylülerin birbirinin içinden tek bir hayalet gibi geçmesini engellemek ve yürüyüş hızlarındaki küçük farklarla yapaylığı kırmak.

- Godot Yapısı: Basit itme vektörü (Soft collision separation) + Başlangıç hızına %±15 rastgele varyasyon.

- Örnek Kod:

# koylu_ai.gd içine eklenecek kısım

@export



var

ayrilma_alani

:



Area3D

func



ayrilma_vektoru_hesapla

()



->



Vector3

:



var

itme

=



Vector3

.

ZERO



if



not

ayrilma_alani:



return

itme



var

yakin_koyluler

=

ayrilma_alani.

get_overlapping_bodies

()



for

k

in

yakin_koyluler:



if

k

!=



self



and

k

is



CharacterBody3D

:



var

fark

=

global_position

-

k

.

global_position



var

mesafe

=

fark.

length

()



if

mesafe

>



0.01



and

mesafe

<



1.2

:

itme

+=

fark.

normalized

()



/

mesafe



return

itme

- Performans Notu: Karmaşık RVO/Crowd simülasyonları yerine bu yöntem 30 karakterde sıfır gecikmeyle sonuç verir.

- Öncelik: V1

## 11. Ruh Hâli ve Sağlık Görünürlüğü

- Amaç: Aç, hasta veya düşük moralli köylünün yürüyüşünden durumunun anlaşılması; acil durumlarda koşma refleksi.

- Godot Yapısı: AnimationTree (BlendSpace1D: Hız ve Moral eğrisi).

- Örnek Kod:

# koylu_gorsel_durum.gd

extends



Node

func



ruh_halini_yansit

(

moral

:



int

,



saglik

:



int

,



anim_tree

:



AnimationTree

)



->



void

:



if

saglik

<



30

:

anim_tree.

set

(

"parameters/YuruyusTipi/transition_request"

,



"topallama"

)



elif

moral

<



25

:

anim_tree.

set

(

"parameters/YuruyusTipi/transition_request"

,



"kambur_yuruyus"

)



else

:

anim_tree.

set

(

"parameters/YuruyusTipi/transition_request"

,



"normal_yuruyus"

)

- Performans Notu: 30 karakter için AnimationTree oldukça hafiftir. Kemik sayısı < 25 tutulduğunda CPU yükü ihmal edilebilir düzeydedir.

- Öncelik:V1

## 12. Görsel Taşıma Animasyonu (Kozmetik Ambar Lojistiği)

- Amaç: Ortak ambar mekaniğini bozmadan, tarladan veya hızarhaneden çıkan bir köylünün sırtında çuvalla ambara doğru yürümesi (yalnızca sahne canlılığı için).

- Godot Yapısı: Belirli aralıklarla tetiklenen sahte görsel görev (Cuval node'u görünürlüğü).

- Örnek Kod:

# koylu_ai.gd içine

@onready



var

sirt_cuvali

:



Node3D



=



$

Armature/Skeleton3D/Gogus/SirtCuvali

func



gorsel_ambara_tasima_baslat

(

ambar_pozisyonu

:



Vector3

)



->



void

:

sirt_cuvali

.

visible

=



true



duruma_gec

(

RutinDurumu

.

ISE_GIDERKEN

,

ambar_pozisyonu

)

func



ambara_vardi_kozmetik

()



->



void

:

sirt_cuvali

.

visible

=



false



# İşe geri dön



duruma_gec

(

RutinDurumu

.

ISE_GIDERKEN

,

bagli_oldugu_bina_pos

)

- Performans Notu: Bu işlem ekonomik hesaplamayı beklemez, tamamen görsel bir döngüdür.

- Öncelik: V2 (V1'de boş gezinme yeterlidir)

## BÖLÜM C — HAYVANLAR VE YAŞAM

## 13. Evcil Hayvanlar (Tavuk, Koyun, Köpek)

- Amaç: Köy sokaklarında dolaşan tavuklar, çadır kenarında yatan çoban köpeği ile köy canlılığını katlamak.

- Godot Yapısı:CharacterBody3D tabanlı basit Wander State Machine (Küçük alan sınırlamalı).

- Örnek Kod:

# res://src/koy/ai/hayvan_ai.gd

extends



CharacterBody3D

@export



var

otlama_yaricapi

:



float



=



8.0

var

baslangic_pos

:



Vector3

var

hedef_pos

:



Vector3

var

bekleme_sayaci

:



float



=



0.0

func



_ready

()



->



void

:

baslangic_pos

=

global_position



yeni_hedef_sec

()

func



_physics_process

(

delta

:



float

)



->



void

:



if

bekleme_sayaci

>



0

:

bekleme_sayaci

-=

delta



return



if

global_position.

distance_to

(

hedef_pos

)



<



0.3

:

bekleme_sayaci

=



randf_range

(

3.0

,



8.0

)



yeni_hedef_sec

()



return

velocity

=



(

hedef_pos

-

global_position

)

.

normalized

()



*



0.8



move_and_slide

()

func



yeni_hedef_sec

()



->



void

:



var

r

=



randf_range

(

0

,

otlama_yaricapi

)



var

a

=



randf_range

(

0

,

TAU

)

hedef_pos

=

baslangic_pos

+



Vector3

(

cos

(

a

)



*

r,

0

,

sin

(

a

)



*

r

)

- Performans Notu: Hayvan modelleri 100-200 poligon olmalı ve gölge düşürmemelidir (Cast Shadow: Off).

- Öncelik: V1 (Köyde 4-5 tavuk ve 1 köpek eklemek atmosferi anında değiştirir)

## 14. Yaban Hayatı (Orman Kenarı Geyikleri ve Kuşlar)

- Amaç: Haritanın uçlarındaki ormanlık alanda uzaktan seçilen geyikler ve gökyüzünde dönen kuş gölgeleri.

- Godot Yapısı: Kuşlar için GPUParticles3D (Billboard kuş silüeti), geyikler için hafif wanderer scripti.

- Örnek Kod:

# res://src/koy/gorsel/kus_surusu.gd

# GPUParticles3D üzerinde çalışan dairesel yörünge partikülü

extends



GPUParticles3D

func



_ready

()



->



void

:

amount

=



8

lifetime

=



12.0



# ParticleProcessMaterial içinde yörüngesel hız verilerek gökyüzünde döndürülür

- Performans Notu: Kuşları gerçek 3D model yapmak yerine GPU particle billboard kullanmak sıfır maliyet sağlar.

- Öncelik:V2

## 15. Sürü ve Çoban Döngüsü

- Amaç: Çobanın koyun sürüsünü sabah köy dışına otlağa götürüp akşam geri getirmesi.

- Godot Yapısı: Lider-Takipçi (Boids / Flocking) mantığı.

- Performans Notu: İki kişilik ekip için karmaşık boids algoritması geliştirmek gereksiz risk taşır.

- Öncelik: V2'ye ertelenmeli.

## BÖLÜM D — ARAYÜZ (HUD) YENİDEN TASARIMI

## 16. Üst Kaynak Şeridi (İkonlu ve Dinamik Değişimli)

- Amaç: Mevcut "Akçe 1, Gıda 21..." şeklindeki ham metin yerine; Manor Lords benzeri ahşap/bronz kabartma ikonlar, net stok miktarı ve günlük değişim (+3, -1) etiketleri.

- Godot Yapısı: PanelContainer + HBoxContainer + TextureRect & Label bileşenleri.

- Örnek Kod:

# res://src/arayuz/koy_hud/kaynak_gostergesi.gd

extends



HBoxContainer

@onready



var

ikon_rect

:



TextureRect



=



$

Ikon

@onready



var

miktar_label

:



Label



=



$

MiktarLabel

@onready



var

degisim_label

:



Label



=



$

DegisimLabel

func



guncelle

(

miktar

:



int

,



net_degisim

:



int

,



kritik_esik

:



int



=



5

)



->



void

:

miktar_label

.

text

=



str

(

miktar

)



if

net_degisim

>



0

:

degisim_label

.

text

=



"+

%d

"



%

net_degisim

degisim_label

.

modulate

=



Color

(

"7cdb58"

)



# Yeşil



elif

net_degisim

<



0

:

degisim_label

.

text

=



"

%d

"



%

net_degisim

degisim_label

.

modulate

=



Color

(

"db5858"

)



# Kırmızı



else

:

degisim_label

.

text

=



"0"

degisim_label

.

modulate

=



Color

(

"a0a0a0"

)



# Gri



# Kritik seviye uyarısı



if

miktar

<=

kritik_esik:

miktar_label

.

modulate

=



Color

(

"ff3333"

)



else

:

miktar_label

.

modulate

=



Color

.

WHITE

- Performans Notu: UI etiketleri her frame değil, sadece Kaynaklar.kaynak_degisti sinyali yayımlandığında güncellenmelidir.

- Öncelik: V1 (Kritik)

## 17. Sağ Üst Köy Durumu ve Takvim

- Amaç: Huzur, Adalet, Asayiş Riski göstergelerini ikon ve renkli pip/bar sistemiyle görselleştirmek; takvim ve ambar doluluğunu okunabilir kılmak.

- Godot Yapısı: VBoxContainer + ProgressBar / Özel çizim Control düğümleri.

- Örnek Kod:

# res://src/arayuz/koy_hud/koy_durum_paneli.gd

extends



PanelContainer

@onready



var

huzur_bar

:



ProgressBar



=



$

VBox/HuzurBar

@onready



var

adalet_bar

:



ProgressBar



=



$

VBox/AdaletBar

@onready



var

asayis_label

:



Label



=



$

VBox/AsayisLabel

@onready



var

takvim_label

:



Label



=



$

VBox/TakvimLabel

@onready



var

ambar_bar

:



ProgressBar



=



$

VBox/AmbarBar

func



verileri_yansit

(

huzur

:



int

,



adalet

:



int

,



asayis_riski

:



int

,



gun

:



int

,



mevsim

:



String

,



mevsim_gun

:



int

,



ambar_suanki

:



int

,



ambar_maks

:



int

)



->



void

:

huzur_bar

.

value

=

huzur

adalet_bar

.

value

=

adalet

asayis_label

.

text

=



"Asayiş Riski:

%%%d

"



%

asayis_riski

takvim_label

.

text

=



"

%s

•

%d

/7 (Gün

%d

)"



%



[

mevsim, mevsim_gun, gun

]

ambar_bar

.

max_value

=

ambar_maks

ambar_bar

.

value

=

ambar_suanki

ambar_bar

.

tint_progress

=



Color

.

RED



if

ambar_suanki

>=

ambar_maks

else



Color

.

SANDY_BROWN

- Performans Notu: Sıfır GPU yükü, temiz Control hiyerarşisi.

- Öncelik:V1

## 18. Seçili Karakter Portresi ve Detay Kartı

- Amaç: Sahadaki herhangi bir köylüye tıklandığında sağ üstte portresi, adı, atandığı iş, morali ve kapıda öğrenilmiş flag'lerinin belirmesi; "Sorgula/Konuş" butonu sunulması.

- Godot Yapısı: PanelContainer (Slide-in tween animasyonu ile açılan pencere).

- Örnek Kod:

# res://src/arayuz/koy_hud/karakter_kart_paneli.gd

extends



PanelContainer

@onready



var

portre_rect

:



TextureRect



=



$

HBox/Portre

@onready



var

isim_label

:



Label



=



$

HBox/VBox/Isim

@onready



var

is_label

:



Label



=



$

HBox/VBox/Is

@onready



var

flag_listesi

:



Label



=



$

HBox/VBox/Flagler

var

secili_koylu

:



Node



=



null

func



karakter_goster

(

koylu_data

:



Resource

)



->



void

:

secili_koylu

=

koylu_data

visible

=



true

isim_label

.

text

=

koylu_data

.

ad

is_label

.

text

=



"Görevi:

%s

"



%

koylu_data

.

meslek



# Kapıda keşfedilen flag'leri göster



var

f_metin

=



""



for

f

in

koylu_data

.

acilan_flagler:

f_metin

+=



"•

%s

\n

"



%

f.

replace

(

"flag_"

,



""

)

.

capitalize

()

flag_listesi

.

text

=

f_metin

func



_on_konus_button_pressed

()



->



void

:



if

secili_koylu:



KoyYonetimi

.

diyalog_baslat

(

secili_koylu

)

- Performans Notu: Pencere kapalıyken visible = false yapılarak draw call ve input dinlemesi durdurulur.

- Öncelik: V1 (Kritik)

## 19. Alt İnşaat Çubuğu ve Önizleme Kartları

- Amaç: Mevcut sade butonlar yerine Manor Lords tarzı; kategori ikonları (Ev, Balta, Kılıç, Kalkan), binaların küçük çizim kartları ve hammadde maliyet rozetleri.

- Godot Yapısı:TabContainer veya buton grubu + GridContainer (Bina önizleme kartları).

- Örnek Kod:

# res://src/arayuz/koy_hud/bina_secim_karti.gd

extends



Button

@export



var

bina_id

:



String



=



"kulube"

@onready



var

maliyet_label

:



Label



=



$

MaliyetLabel

@onready



var

ikon_rect

:



TextureRect



=



$

BinaIkon

func



kart_kur

(

bina_bilgisi

:



Dictionary

,



ambar_kaynaklar

:



Dictionary

)



->



void

:

bina_id

=

bina_bilgisi

[

"id"

]

text

=

bina_bilgisi

[

"ad"

]

ikon_rect

.

texture

=



load

(

bina_bilgisi

[

"ikon_yolu"

])



# Maliyet kontrolü



var

karsilanabilir

=



true



var

m_metin

=



""



for

k

in

bina_bilgisi

[

"maliyet"

]

:

m_metin

+=



"

%s

:

%d

"



%



[

k, bina_bilgisi

[

"maliyet"

][

k

]]



if

ambar_kaynaklar.

get

(

k

,



0

)



<

bina_bilgisi

[

"maliyet"

][

k

]

:

karsilanabilir

=



false

maliyet_label

.

text

=

m_metin

disabled

=



not

karsilanabilir

modulate

=



Color

.

WHITE



if

karsilanabilir

else



Color

(

0.6

,

0.6

,

0.6

,

0.8

)

- Performans Notu: Dokuların hepsi önceden belleğe alınmış (preloaded) olmalıdır.

- Öncelik: V1

## 20. Overlay Menüsü (Stratejik Isı Haritaları)

- Amaç: Manor Lords sağ menüsündeki gibi (image_836881.jpg) harita üzerinde Asayiş Riski, Yangın Tehlikesi, Lojistik Yakınlığı gibi katmanları renklendirerek göstermek.

- Godot Yapısı: OptionButton + Zemin Shader'ına gönderilen Texture maskesi veya binaların üzerine düşen dikey renkli Decal'lar.

- Örnek Kod:

# res://src/arayuz/koy_hud/overlay_kontrol.gd

extends



Control

enum



OverlayModu



{

YOK, ASAYIS, YANGIN, VERIMLILIK

}

func



_on_overlay_secildi

(

index

:



int

)



->



void

:



var

secim

=

index

as



OverlayModu



for

bina

in



get_tree

()

.

get_nodes_in_group

(

"binalar"

)

:

bina.

overlay_rengi_guncelle

(

secim

)

- Performans Notu: V1 için arazinin tamamını boyayan shader yerine, binaların üzerine küçük renkli halka (Decal veya Mesh) koymak çok daha zahmetsiz ve hafiftir.

- Öncelik: V2 (V1'de UI içi risk listesi yeterlidir)

## 21. Kesikli Çizgili İnşaat Önizlemesi (Manor Lords Stili)

- Amaç: image_836881.jpg'deki gibi bina veya parsel çizerken kesikli beyaz sınır çizgileri, yola bağlantı çizgisi ve yeşil/kırmızı onay alanı sunulması.

- Godot Yapısı: ImmediateMesh (LineStrip) veya LineRenderer3D shader'ı + Şeffaf Ghost Mesh.

- Örnek Kod:

// res://src/koy/gorsel/kesikli_cizgi.gdshader

shader_type spatial

;

render_mode unshaded

;

uniform



vec4

cizgi_rengi : source_color

=



vec4

(

1.0

,



1.0

,



1.0

,



0.9

);

uniform



float

kesik_sikligi

=



20.0

;

void



fragment

()



{



float

cizgi

=



sin

(

UV

.

x

*

kesik_sikligi

);



if



(

cizgi

<



0.0

)



{

discard

;



}

ALBEDO

=

cizgi_rengi

.

rgb

;

ALPHA

=

cizgi_rengi

.

a

;

}

- Performans Notu: ImmediateMesh sadece inşaat modundayken çizdirilmelidir; normal oyun akışında boşa CPU harcamamalıdır.

- Öncelik: V1 (Okunabilirlik ve Manor Lords hissi için kritik)

## 22. Zaman ve Hız Kontrol Paneli

- Amaç: Sağ alttaki hız butonlarını (Durdur, 1x, 2x, 3x) ve "Geceye Geç" butonunu netleştirmek, günün hangi vaktinde olunduğunu dönen bir saat/güneş kadranıyla göstermek.

- Godot Yapısı: HBoxContainer + TextureButton + Engine.time_scale entegrasyonu.

- Örnek Kod:

# res://src/arayuz/koy_hud/zaman_kontrol.gd

extends



HBoxContainer

func



hiz_ayarla

(

carpan

:



float

)



->



void

:



Engine

.

time_scale

=

carpan

func



_on_duraklat_toggled

(

toggled_on

:



bool

)



->



void

:



hiz_ayarla

(

0.0



if

toggled_on

else



1.0

)

func



_on_hiz_1x_pressed

()



->



void

:



hiz_ayarla

(

1.0

)

func



_on_hiz_2x_pressed

()



->



void

:



hiz_ayarla

(

2.0

)

func



_on_geceye_gec_pressed

()



->



void

:



KoyYonetimi

.

gece_fazina_gec

()

- Performans Notu: Engine.time_scale 2x ve 3x hızda physics hesaplamalarını sıklaştırır. Fizik motoru ayarlarından max_physics_steps_per_frame değerini 8 ile sınırlayın ki 3x hızda laptop kasmadan 60 FPS kalsın.

- Öncelik:V1

## 23. Görsel Dil, Tipografi ve İkonografi

- Amaç: UI'daki düz gri pencereleri koyu lacivert/kahve yarı saydam parşömen stiline çekmek, okunabilir bir Orta Çağ fontu kullanmak.

- Godot Yapısı: Global Theme + StyleBoxFlat (Köşe yuvarlama, 1px altın/bronz kenarlık, %80 opaklık).

- Tasarım Kuralları:◦ Arka Plan: Color(0.08, 0.07, 0.06, 0.85) (Koyu isli ahşap tonu).◦ Kenarlık: Color(0.65, 0.52, 0.32, 0.9) (Eski bronz/altın rengi).◦ Tipografi: Başlıklar ve sayılar için serif/gotik türevi (örn. Cinzel veya MedievalSharp), gövde metinleri ve diyaloglar için temiz serif (örn. Alegreya veya EB Garamond).

- Öncelik: V1 (Kritik)

## BÖLÜM E — KAMERA VE ETKİLEŞİM

## 24. Strateji Kamerası (Tilt-on-Zoom)

- Amaç: WASD, fare kenarı ve tekerlek ile kontrol edilen; yaklaştıkça yere paralel eğilen (tilt), uzaklaştıkça dikleşen RTS kamerası.

- Godot Yapısı:Node3D (Gimbal pivot) + Camera3D.

- Örnek Kod:

# res://src/koy/gorsel/koy_kamerasi.gd

extends



Node3D

@export



var

hareket_hizi

:



float



=



25.0

@export



var

min_zoom

:



float



=



8.0

@export



var

maks_zoom

:



float



=



45.0

@onready



var

kamera

:



Camera3D



=



$

Camera3D

var

hedef_zoom

:



float



=



25.0

func



_process

(

delta

:



float

)



->



void

:



# Klavye hareketi



var

giris

=



Input

.

get_vector

(

"kamera_sol"

,



"kamera_sag"

,



"kamera_yukari"

,



"kamera_asagi"

)



var

hareket

=



(

transform.basis

*



Vector3

(

giris.x,

0

, giris.y

))

.

normalized

()

global_position

+=

hareket

*

hareket_hizi

*

delta



# Yumuşak Zoom ve Açı Değişimi (Tilt-on-zoom)

kamera

.

position

.

z

=



lerp

(

kamera

.

position

.

z

,

hedef_zoom

,



10.0



*

delta

)



var

t

=



inverse_lerp

(

min_zoom

,

maks_zoom

,

kamera

.

position

.

z

)

kamera

.

rotation_degrees

.

x

=



lerp

(

-

30.0

,



-

65.0

,

t

)



# Yakınken yatık, uzaktayken dik

func



_unhandled_input

(

event

:



InputEvent

)



->



void

:



if

event

is



InputEventMouseButton



and

event.

is_pressed

()

:



if

event

.

button_index

==

MOUSE_BUTTON_WHEEL_UP:

hedef_zoom

=



clamp

(

hedef_zoom

-



3.0

,

min_zoom

,

maks_zoom

)



elif

event

.

button_index

==

MOUSE_BUTTON_WHEEL_DOWN:

hedef_zoom

=



clamp

(

hedef_zoom

+



3.0

,

min_zoom

,

maks_zoom

)

- Performans Notu: Kameranın frustum culling özelliği sayesinde kamera açısı yatayken uzaktaki nesneler otomatik elenir.

- Öncelik: V1

## 25. Seçim ve Vurgulama (Outline Shader)

- Amaç: Fareyle üzerine gelinen bina veya köylünün etrafında hafif sarı/beyaz parıltı; tıklandığında seçili kalması.

- Godot Yapısı: Mesh üzerinde next_pass olarak çalışan basit Inverted Hull Outline Shader.

- Örnek Kod:

// res://src/koy/gorsel/secim_outline.gdshader

shader_type spatial

;

render_mode cull_front

,

unshaded

;

uniform



vec4

vurgu_rengi : source_color

=



vec4

(

0.9

,



0.75

,



0.3

,



1.0

);

uniform



float

kalinlik :

hint_range

(

0.0

,



0.1

)



=



0.03

;

void



vertex

()



{

VERTEX

+=

NORMAL

*

kalinlik

;

}

void



fragment

()



{

ALBEDO

=

vurgu_rengi

.

rgb

;

}

- Performans Notu: Tam ekran post-process outline yerine Inverted Hull kullanmak 4 GB VRAM'li sistemde sıfır bellek bant genişliği tüketir.

- Öncelik: V1

## 26. Yüzen Bina Durum İkonları (World Space UI)

- Amaç: İşçisi olmayan binanın üzerinde "Boşta", hammaddesi bitenin üzerinde "Girdi Yok", ambar dolunca "Dolu" ikonu süzülmesi.

- Godot Yapısı: Binaya bağlı Sprite3D (billboard = BILLBOARD_ENABLED).

- Örnek Kod:

# res://src/koy/gorsel/bina_durum_ikonu.gd

extends



Sprite3D

func



durum_guncelle

(

isci_sayisi

:



int

,



hammadde_var_mi

:



bool

,



ambar_dolu

:



bool

)



->



void

:



if

isci_sayisi

==



0

:

visible

=



true

texture

=



preload

(

"res://assets/arayuz/ikonlar/uyari_isci_yok.png"

)



elif



not

hammadde_var_mi:

visible

=



true

texture

=



preload

(

"res://assets/arayuz/ikonlar/uyari_hammadde_yok.png"

)



elif

ambar_dolu:

visible

=



true

texture

=



preload

(

"res://assets/arayuz/ikonlar/uyari_ambar_dolu.png"

)



else

:

visible

=



false

- Performans Notu: Kamera çok uzaklaştığında (kamera.position.z > 40) tüm Sprite3D ikonları topluca gizlenerek ekran kalabalığı ve draw call önlenmelidir.

- Öncelik:V1

## BÖLÜM F — PERFORMANS VE TEKNİK

## 27. Köylü Modelleri ve Animasyon Optimizasyonu

- Amaç: 20–30 animasyonlu köylü varken RTX 3050 ekran kartının fan açmadan 60 FPS vermesini sağlamak.

- Teknik Yöntem:◦ Karakter modellerinde Skeleton3D kemik sayısı maksimum 22 kemik ile sınırlandırılmalıdır (parmak kemikleri olmamalı).◦ Karakterlerin polygon sayısı 1.500–2.500 tris bandında tutulmalıdır.◦ Kameradan 30 metre uzaktaki köylülerin animasyon kare hızı yarıya düşürülmelidir (anim_player.playback_process_mode manuel tick).

- Öncelik: V1

## 28. Instancing ve Doku Atlası Stratejisi

- Amaç: Tüm çitler, fıçılar, çadır kazıkları ve taşlar için draw call sayısını 100'ün altında tutmak.

- Teknik Yöntem:◦ Çitler tek tek MeshInstance3D olarak sahneye konulmaz; MultiMeshInstance3D ile birleştirilir.◦ Tüm ahşap ve taş propslar tek bir 2048x2048 "Koy_Props_Atlas.png" dokusunu paylaşır. Böylece Godot motoru hepsini tek bir shader state'inde çizer.

- Öncelik: V1

## 29. Yapay Zekâ Zaman Dilimleme (Time-Slicing AI)

- Amaç: 30 köylünün aynı anda durum değiştirmesi veya A* rotası araması sonucu oluşabilecek mikroskobik takılmaları (frame drop) engellemek.

- Godot Yapısı: KoyluYoneticisi merkezi sınıfı üzerinden sıralı dağıtım.

- Örnek Kod:

# res://src/koy/ai/koylu_yoneticisi.gd

extends



Node

var

koyluler

:



Array

[

Node

]



=



[]

var

sira_indeksi

:



int



=



0

var

kare_basi_islenen_koylu

:



int



=



5

func



_physics_process

(

_delta

:



float

)



->



void

:



if

koyluler.

is_empty

()

:



return



# Her frame sadece 5 köylünün durumunu kontrol et



for

i

in



range

(

kare_basi_islenen_koylu

)

:



if

sira_indeksi

>=

koyluler.

size

()

:

sira_indeksi

=



0



var

k

=

koyluler

[

sira_indeksi

]



if



is_instance_valid

(

k

)

:

k.

rutin_karari_uret

()

sira_indeksi

+=



1

- Öncelik: V1

## 30. Güvenli Kayıt (guvenli_kayit) ile Tam Uyum

- Amaç: Eklenen görsel öğelerin, anlık köylü pozisyonlarının veya alet animasyonlarının savegame.jsondosyasını şişirmesini engellemek.

- Kural: Yalnızca saf veri kaydedilir (kimlik, statlar, atandığı bina ID'si, açık flag'ler). Köylünün arazideki anlık koordinatı, elindeki balta veya yürüyüş animasyonu asla kayda girmez; oyun yüklendiğinde atandığı binanın kapısında yeniden canlandırılır (re-instantiate).

- Örnek Kod:

# guvenli_kayit.gd entegrasyonu

func



koylu_verisini_pakete_ekle

(

k

:



Node

)



->



Dictionary

:



return



{



"chr_id"

: k.chr_kaynak_yolu,



"atanan_bina_id"

: k.atanan_bina_id,



"sadakat"

: k.sadakat,



"moral"

: k.moral,



"acilan_flagler"

: k.acilan_flagler



}



# Position, Velocity, CurrentAnimation KAYDEDİLMEZ.

- Öncelik: V1 (Kritik)

## 3. ÖNERİLEN KLASÖR YAPISI

Mevcut

src/koy/

yapınızı bozmadan şu modüler hiyerarşiye geçmeniz önerilir:

src/

├── koy/

│ ├── koy_yonetimi.gd (Mevcut orkestratör)

│ ├── izgara.gd (Mevcut grid mantığı)

│ ├── kaynaklar.gd (Mevcut envanter)

│ ├── guvenli_kayit.gd (Mevcut JSON kayıt)

│ │

│ ├── ai/ [YENİ]

│ │ ├── koylu_ai.gd (Durum makinesi & hareket)

│ │ ├── koylu_yoneticisi.gd (Time-slicing yöneticisi)

│ │ ├── hayvan_ai.gd (Tavuk / köpek basit dolaşma)

│ │ └── koy_navigasyon.gd (AStar3D grid yol bulucu)

│ │

│ └── gorsel/ [YENİ]

│ ├── arazi_zemini.gdshader (Splat map / zemin dokusu)

│ ├── bitki_yoneticisi.gd (MultiMesh ağaç ve çimen)

│ ├── koy_kamerasi.gd (Tilt-on-zoom RTS kamera)

│ ├── atmosfer_yoneticisi.gd (Işık ve sis döngüsü)

│ └── kesikli_cizgi.gdshader (İnşaat yerleşim önizleme)

│

└── arayuz/

└── koy_hud/ [YENİ HUD BİLEŞENLERİ]

├── koy_hud.tscn (Ana UI sahnesi)

├── koy_hud.gd (Sinyal toplayıcı)

├── kaynak_gostergesi.gd (Üst bar tekil kaynak kutusu)

├── koy_durum_paneli.gd (Huzur, Adalet, Takvim)

├── karakter_kart_paneli.gd(Sağ üst köylü inceleme)

├── bina_secim_karti.gd (İnşaat önizleme butonu)

└── zaman_kontrol.gd (Hızlandırma ve gece butonu)

## 4. UYGULAMA SIRASI (Canlılık Hissini En Hızlı Veren İlk 5 İş)

Ekran görüntünüzdeki boşluğu kırmak için işleri şu sırayla yaparsanız

3 gün içinde

bambaşka bir oyun elde edersiniz:

- İş 1: Arazi Dokusu ve Çevre Kuşağı (Maddeler 1, 2, 5)• Düz kahverengiyi kaldırın. 1024'lük çimen/çamur dokusu serin, etrafı MultiMesh ile 100-150 ağaçla çevirin ve akşam kızıllığı veren yönlü ışığı bağlayın.

- İş 2: Üst ve Alt HUD Yenilemesi (Maddeler 16, 19, 23)• Düz yazıları kaldırıp bronz çerçeveli yarı saydam paneller, kaynak ikonları ve bina seçim kartlarını yerleştirin.

- İş 3: Hareketli Köylüler ve Aletler (Maddeler 7, 8)• Çadırın önünde sabit duran köylüleri, tarlaya ve hızarhaneye yürüyüp çapa/balta animasyonu yapacak döngüye sokun.

- İş 4: Seçili Karakter Kartı (Madde 18)• Tıklanan köylünün sağ üstte portresinin, adının ve kapıda keşfedilen flag'lerinin belirmesini sağlayın (sorgunun köydeki karşılığı anında hissedilir).

- İş 5: Köy Hayvanları ve Zemin Prop'ları (Maddeler 4, 13)• Çadırların arasına 4 adet dolaşan tavuk, birkaç odun yığını ve fıçı yerleştirin.

## 5. V1 vs V2 KAPSAM LİSTESİ

İki kişilik ekibinizin projeyi zamanında teslim edebilmesi için sınırları net çiziyoruz:

Özellik / Sistem

V1 (Şimdi Yapılacak)

V2 (Genişleme Havuzu)

Zemin & Doğa

Splat Map çimen/çamur, MultiMesh çevre ağaçları

Dinamik mevsimsel çamur birikimi, etkileşimli çimen ezilmesi

Yollar

Basit Decal / boyama patikalar, düğüm bağlantısı

Köylü yürüdükçe gerçek zamanlı açılan prosedürel patikalar

Köylü Hareketi

AStar3D yol bulma, 3 durumlu rutin (İş/Dinlenme/Uyku)

Karmaşık 24 saatlik rota, araba çekme, sokakta selamlaşma

Hayvanlar

Basit dolaşan tavuklar ve nöbetçi köpek

Çobanlı koyun sürüsü, ormanda avlanan geyikler, kurt tehdidi

Ambar Lojistiği

Tek ortak ambar (fiziksel taşıma yok)

Fiziksel el arabasıyla malzeme taşıyan hamallar

Bina İçi

UI kartından karakterle diyalog kurma

3D çatı kesiti (cutaway), bina içine girip gezme

Overlay

UI içi Asayiş ve Risk yüzdeleri

Araziyi renklendiren 3D ısı haritası katmanları

Kamera

Tilt-on-zoom RTS kamerası, seçim outline'ı

Sinematik köylü takip kamerası (First-person teftiş)

## 6. ÜCRETSİZ VE TİCARİ KULLANIMA UYGUN ASSET KAYNAKLARI

Projenin Orta Çağ estetiğine uyan, bütçe tüketmeyen ve telif sorunu çıkarmayan hazır kaynaklar:

## 3D Modeller (Karakter, Bina, Hayvan, Doğa)

- Kay Lottum / KayKit (Medieval Hexagon & Character Pack)• Lisans: CC0 (Kamu Malı - Ticari serbest, atıf zorunlu değil).• Kullanım: Çadır, kulübe, odun, fıçı, çit parçaları ve optimize düşük poligonlu Orta Çağ karakterleri.

- Kenney.nl (Medieval Town & Nature Kit)• Lisans: CC0 (Kamu Malı - Ticari serbest).• Kullanım: Ağaçlar, kayalar, çalılar, zemin taşları, aletler (kazma, balta, çapa).

- Quaternius (Medieval Village & Animated Animals)• Lisans: CC0 (Kamu Malı).• Kullanım: Riglenmiş ve animasyonlu hazır tavuk, koyun, inek, köpek ve köylü modelleri.

## Arayüz (HUD) ve İkonografi

- Game-icons.net• Lisans: CC BY 3.0 (Atıf ile ticari serbest).• Kullanım: Akçe, buğday, odun kütüğü, taş bloğu, balta, meşale, adalet terazisi gibi 4000+ vektörel monokrom ikon. (Koyu bronz veya beyaz tint vererek Manor Lords stiline tam oturur).

- Kenney UI Audio Pack• Lisans: CC0.• Kullanım: Buton tıklamaları, sekme geçişleri, inşaat onay tokmağı sesleri.

## Tipografi

- Google Fonts: Cinzel & MedievalSharp• Lisans: Open Font License (OFL - Ticari serbest).• Kullanım: Başlıklar, altın rengi kaynak sayıları, gün/mevsim yazıları.

- Google Fonts: Alegreya• Lisans: Open Font License (OFL).• Kullanım: Köylü diyalogları, açıklama metinleri ve tooltip'ler (küçük puntoda dahi kusursuz okunur).

## Plana göre uygulanmış sapmalar (İş 1)

- Yollar ve meydan: madde 3'teki Decal yerine splat maskesinde çizildi. Overdraw yok, kenarlar organik. Kapıdan güneye giden yol şaderde formülle çiziliyor.

- Ağaçlar: madde 2'deki gerçek ağ yerine impostor atlas kullanıldı (gövde dibinden kameraya dönen dörtgen). Poly Haven ağaçları 0,4–17 milyon üçgen; KayKit, Kenney ve Quaternius ise realist görünümle çakışıyor. Ağaçlar gölge düşürmüyor; alçak akşam güneşinde köyü kara lekelere boğuyordu.

- Şader adları: .claude/rules/shader-code.md kuralı gereği spatial_env_arazi, spatial_env_cimen ve spatial_env_orman. Atmosfer yöneticisi src/koy/gorsel/koy_atmosferi.gd.

- Ton eşleme: "Filmic" yerine projenin mevcut AgX'i kaldı. Volumetric fog açılmadı (4 GB VRAM).