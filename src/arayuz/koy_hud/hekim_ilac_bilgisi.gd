## Kimlik/hastalık teşhisi yerine mevcut Şifahane hizmetinin açık etkisi.
class_name HekimIlacBilgisi
extends RefCounted
static func ekle(y: KoyYonetimi, ebeveyn: Control, bina_id: int = -1) -> void:
	var satir := Label.new()
	satir.name = "hekim_ilac_bilgisi"
	satir.text = HekimIlac.metin(y, bina_id)
	satir.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ebeveyn.add_child(satir)
