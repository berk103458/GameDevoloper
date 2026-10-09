## HAR-10: gerçek muhafızın aynı devriyede sabit taktik durağı; HAR15 bonusu eklemez.
class_name SavunmaKonuslanmasi
extends RefCounted
const META := "savunma_konuslanmasi"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/savunma_konuslanmasi.json"))
## Optional, sınırlı defter; kanonik pozitif ID ve yalnız tanımlı rol. NPC yaratmaz.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={}
 if not v is Dictionary: return d
 var ids: Array[int]=[]
 for id in v:
  if not id is String or not id.is_valid_int() or int(id)<1 or int(id)>1000000000 or str(int(id))!=id: continue
  if not v[id] is String or not AYAR.roller.has(v[id]): continue
  ids.append(int(id))
 ids.sort()
 for id in ids:
  if d.size()>=int(AYAR.azami_kayit): break
  d[str(id)]=v[str(id)]
 return d
## Salt okunur normalizasyon; eksik eski kayıt devriye olarak sürer.
static func durum(y: KoyYonetimi) -> Dictionary:
 var d:=oku(y.get_meta(META,{}))
 for id in d.keys():
  if y.koylu(int(id))==null: d.erase(id)
 return d
## Aynı gerçek yetişkin nöbetçinin canlı sağlık/bordro/hüküm/dış görev kısıtları.
static func uygun(y: KoyYonetimi,id: int) -> bool:
 var k:=y.koylu(id)
 return y.agalik and y.son==&"" and k!=null and k.yas_grubu==&"yetiskin" and k.saglik>=int(AYAR.asgari_saglik) and CirakEgitimi.saglam(k) and MuhafizMaasi.aday(k,y) and not MuhafizMaasi.borclu(k,y) and not KervanKorumasi.disarida(y,id) and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k,y)
## Mevcut kayıt, yaşayan gerçek kişiler ve kararlı ID sırasıyla kontenjan süzülür.
static func kisiler(y: KoyYonetimi,rol: String) -> Array[int]:
 var ids: Array[int]=[]
 if not AYAR.roller.has(rol) or (rol=="sur" and (y.sur_seviye<=0 or y.sur_hasar>=100)): return ids
 var d:=durum(y)
 for id in d:
  if d[id]==rol and uygun(y,int(id)): ids.append(int(id))
 ids.sort()
 return ids.slice(0,int(AYAR.roller[rol].kontenjan))
## Pasifleşen rol saklanır; canlı etkin rota/donanım üretmez.
static func etkin(y: KoyYonetimi,id: int) -> String:
 var rol: String=durum(y).get(str(id),"")
 return rol if id in kisiler(y,rol) else ""
## Atomik atama; boş rol pasif veya terminal kaydı da devriyeye temizler.
static func atanabilir(y: KoyYonetimi,id: int,rol: String) -> bool:
 if y.koylu(id)==null: return false
 if rol.is_empty(): return durum(y).has(str(id))
 if not AYAR.roller.has(rol) or not uygun(y,id): return false
 if rol=="sur" and (y.sur_seviye<=0 or y.sur_hasar>=100): return false
 var d:=durum(y)
 if not d.has(str(id)) and d.size()>=int(AYAR.azami_kayit): return false
 # Pasif rezervasyon kontenjanı tüketmez; dönüşte kararlı ID süzümü uygulanır.
 return id in kisiler(y,rol) or kisiler(y,rol).size()<int(AYAR.roller[rol].kontenjan)
## İş/nüfus/kasa/RNG değişmez; yalnız optional görev defteri güncellenir.
static func ata(y: KoyYonetimi,id: int,rol: String) -> bool:
 if not atanabilir(y,id,rol): return false
 var d:=durum(y)
 if rol.is_empty(): d.erase(str(id))
 else: d[str(id)]=rol
 y.set_meta(META,d)
 return true
## Mevcut A* ve kapı/iç kule hücreleri. Dikey tırmanış/teleport veya ayrı motor yok.
static func hedef(y: KoyYonetimi,r: KoyRotasi,bas: Vector2i,id: int,sira: int) -> Dictionary:
 var rol:=etkin(y,id)
 if rol.is_empty(): return {}
 var i:=kisiler(y,rol).find(id)
 var m:=y.a.meydan
 var h: Vector2i=MuhafizDevriyesi.kuleler(y)[i] if rol=="sur" else Vector2i(m.position.x+m.size.x/2+i,y.a.izgara_boyut.y-1)
 var son:=r.yakin(h)
 if son.x<0 or r.yol(bas,son).is_empty(): return {}
 return {"son":son,"ad":String(AYAR.roller[rol].nobet),"sira":sira}
