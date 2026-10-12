## Uçuşta olan varlık yükleme zincirlerinin defteri (VarlikYuklemePaneli.hazirla ↔ bitir).
##
## Neden: `VarlikOnbellek.yukle` dosyaları `ResourceLoader.load_threaded_request` ile kareler arasında
## başlatır. Oyun tam o sırada kapanırsa motor uçuştaki isteği ve yüklediği kaynağı serbest bırakmaz;
## çıkışta "N RID allocations ... were leaked at exit" ve ObjectDB sızıntısı bildirilir. Çıkış yolu
## (`Ses.cik`) burada bekler, istekler normal biçimde tamamlanır ve kaynaklar bırakılır.
##
## Ayrıca doğrudan bir kaynağı tutan geçiş katmanı, ana sahne kapansa bile boşaltılana kadar beklenir.
class_name VarlikAkisDenetimi
extends RefCounted

## Bekleme üst sınırı (kare). Sağlıklı bir yükleme turu ~on kare sürer; üst sınır yalnız kopmuş bir
## zincirin çıkışı kilitlememesi içindir.
const EN_FAZLA_KARE := 600

static var _uclar: Dictionary = {}
static var _sira := 0


## Zincir kaynak tutmaya başladı; dönen kimlik `bitir`e verilir.
static func basla() -> int:
	_sira += 1
	_uclar[_sira] = true
	return _sira


## Zincir kaynakları bıraktı. Aynı kimlik iki kez verilebilir (bitir + nesnenin silinmesi).
static func bitir(is_no: int) -> void:
	if is_no != 0:
		_uclar.erase(is_no)


## Uçuşta kaynak tutan yükleme zinciri var mı.
static func bekleyen_var_mi() -> bool:
	return not _uclar.is_empty()


## Uçuştaki zincirler kaynaklarını bırakana kadar bekler (kare başına `agac.process_frame`).
static func bosalana_kadar(agac: SceneTree) -> void:
	if agac == null:
		return
	var kare := 0
	while not _uclar.is_empty() and kare < EN_FAZLA_KARE:
		await agac.process_frame
		kare += 1