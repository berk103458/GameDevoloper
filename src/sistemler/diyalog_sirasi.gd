## SYS-16: adsız hazır diyalog sırası (Oturum._gemini_sira) kayıt kalıcılığı.
## Mevcut "diyalog_sira" alanı tek kaynaktır; ikinci alan yok. Bozuk/negatif/legacy
## değer başa (0) döner: negatif indeks GDScript dizisinde sondan okuma yapardı.
extends RefCounted

const AZAMI := 100000

static func oku(v: Variant) -> int:
	if (v is int or v is float) and is_finite(float(v)) and floor(float(v)) == float(v) and float(v) >= 0 and float(v) <= AZAMI: return int(v)
	if v is String and v.is_valid_int() and v.to_int() >= 0 and v.to_int() <= AZAMI: return v.to_int()
	return 0
