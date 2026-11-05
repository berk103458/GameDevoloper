## HAR-10: mevcut köylü kartının görev seçenekleri; ikinci HUD veya NPC yok.
class_name KonuslanmaPaneli
extends RefCounted
## Gerçek kişi için kapı/sur/devriye; basınca canlı uygunluk yeniden doğrulanır.
static func ekle(e: KoyEkrani,ic: VBoxContainer,k: Koylu) -> void:
 var y:=e.oturum.yonetim
 if not y.agalik or (not MuhafizMaasi.aday(k,y) and not SavunmaKonuslanmasi.durum(y).has(str(k.id))): return
 var rol: String=SavunmaKonuslanmasi.durum(y).get(str(k.id),"")
 e._etiket(ic,"Taktik konuşlanma: "+("Devriye" if rol.is_empty() else String(SavunmaKonuslanmasi.AYAR.roller[rol].ad))+ (" · şu an etkin değil" if not rol.is_empty() and SavunmaKonuslanmasi.etkin(y,k.id).is_empty() else ""),Tema.KUCUK_PX)
 e._etiket(ic,KervanKorumasi.SAVUNMA_GUVENLIGI.metin(y),Tema.KUCUK_PX).name="savunma_guvenligi_bilgisi"
 for r in ["","kapi","sur"]:
  var b:=e._dugme("Devriye" if r.is_empty() else String(SavunmaKonuslanmasi.AYAR.roller[r].ad),ic)
  b.set_meta("konuslanma",r)
  b.disabled=rol==r or not SavunmaKonuslanmasi.atanabilir(y,k.id,r)
  b.pressed.connect(func() -> void:
   if not preload("res://src/arayuz/koy_atama_kapisi.gd").acik(e): return
   SavunmaKonuslanmasi.ata(y,k.id,r)
   e._yenile()
   KoyluKarti.ac(e,k.id))
