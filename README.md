# bitbar-ezanvakti

🕌 BitBar ezan vakti eklentisi

Sonraki vakte kalan süreyi menubarda gösterir. Basıldığında hicri tarihi ve günün ezan vakitlerini listeler.

![Ornek gorsel](screenshot.png)

## Kullanım

Öncelikle [BitBar](https://getbitbar.com)'ı indirin. Sonra plugin dizininize `ezan_vakti.1m.rb` dosyasını kopyalayın. 

Dosyanın çalıştırılabilir olduğuna emin olun.
``` chmod +x bitbar-plugin-dizini/ezan_vakti.1m.rb ```

Daha sonra bulunduğunuz ilin plaka kodunu girerek komut satırından çalıştırın. Örneğin istanbul ezan vakitleri için: 

``` bitbar-plugin-dizini/ezan_vakti.1m.rb 34```

## Gelişmiş Kullanım

### Yurtdışı / İlçe Desteği

Eğer şehir için değil ilçe için ezan vakitlerini almak veya yurtdışında bu eklentiyi kullanmak isterseniz [EzanVakti API](http://ezanvakti.herokuapp.com)'dan istediğiniz ilçenin kodunu bulun. Örneğin istanbul için [bu adres](http://ezanvakti.herokuapp.com/ilceler?sehir=539). Buradaki `ilceID` bilgisini alın ve bitbar eklenti dizininizin altına `.ezanvakti` isimli bir dosya oluşturup içine ilçe kodunuzu yazın.

## Uyarı

Ezan vakti bilgisi Diyanet İşleri Başkanlığı ile uyumludur.

