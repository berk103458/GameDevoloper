## SRM-04, SRM-05, SRM-06: oyuncu acilisinda debug dugumu kurulmaz.
## Kopru yalniz port istendiginde (ADM-16). Gelistirme acilisi bugunku bayrakla durur.
class_name OyuncuSurumu
extends RefCounted


static func debug_acik(argumanlar: PackedStringArray = OS.get_cmdline_user_args()) -> bool:
	return AdminHud.arac_acik(argumanlar)


static func perf_istendi(argumanlar: PackedStringArray = OS.get_cmdline_user_args(), debug_derleme: bool = OS.is_debug_build()) -> bool:
	return debug_derleme or debug_acik(argumanlar) or argumanlar.has("--perf-log")


static func kopru_istendi(argumanlar: PackedStringArray = OS.get_cmdline_user_args(), ortam: String = OS.get_environment("BRIDGE_PORT")) -> bool:
	return OyunKoprusu.port_oku(argumanlar, ortam) > 0


static func debug_dugum_sayisi(argumanlar: PackedStringArray, debug_derleme: bool, ortam: String = "") -> int:
	var sayi := 0
	if debug_acik(argumanlar):
		sayi += 1
	if perf_istendi(argumanlar, debug_derleme):
		sayi += 1
	if kopru_istendi(argumanlar, ortam):
		sayi += 1
	return sayi
