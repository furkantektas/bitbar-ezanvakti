#!/usr/bin/ruby
# <bitbar.title>EzanVakti BitBar</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Furkan Tektas</bitbar.author>
# <bitbar.author.github>furkantektas</bitbar.author.github>
# <bitbar.desc>OS X menubar icin ezan vakti. Il ayarlamak icin terminalden plaka ile cagirin. orn:`ruby ezan_vakti.1m.rb 34`</bitbar.desc>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.image>https://raw.githubusercontent.com/furkantektas/bitbar-ezanvakti/master/screenshot.png</bitbar.image>
# <bitbar.abouturl>http://github.com/furkantektas/bitbar-ezanvakti</bitbar.abouturl>

require 'net/http'
require 'json'
require 'time'

def gethhmm(secs)
	str = ""
	h = (secs / 3600).to_i
	secs -= h * 3600

	m = (secs / 60).to_i
	secs -= m * 60

	str << "%02i:%02i" % [h, m]
	return str
end

if ARGV.count == 1
	sehirler = {
			"ADANA" => "9146",
			"ADIYAMAN" => "9158",
			"AFYON" => "9167",
			"AGRI" => "9185",
			"AKSARAY" => "9193",
			"AMASYA" => "9198",
			"ANKARA" => "9206",
			"ANTALYA" => "9225",
			"ARDAHAN" => "9238",
			"ARTVIN" => "9246",
			"AYDIN" => "9252",
			"BALIKESIR" => "9270",
			"BARTIN" => "9285",
			"BATMAN" => "9288",
			"BAYBURT" => "9295",
			"BILECIK" => "9297",
			"BINGOL" => "9303",
			"BITLIS" => "9311",
			"BOLU" => "9315",
			"BURDUR" => "9327",
			"BURSA" => "9335",
			"CANAKKALE" => "9352",
			"CANKIRI" => "9359",
			"CORUM" => "9370",
			"DENIZLI" => "9392",
			"DIYARBAKIR" => "9402",
			"DUZCE" => "9414",
			"EDIRNE" => "9419",
			"ELAZIG" => "9432",
			"ERZINCAN" => "9440",
			"ERZURUM" => "9451",
			"ESKISEHIR" => "9470",
			"GAZIANTEP" => "9479",
			"GIRESUN" => "9494",
			"GUMUSHANE" => "9501",
			"HAKKARI" => "9507",
			"HATAY" => "9515",
			"IGDIR" => "9522",
			"ISPARTA" => "9528",
			"ISTANBUL" => "9541",
			"IZMIR" => "9560",
			"KAHRAMANMARAS" => "9577",
			"KARABUK" => "9581",
			"KARAMAN" => "9587",
			"KARS" => "9594",
			"KASTAMONU" => "9609",
			"KAYSERI" => "9620",
			"KIRIKKALE" => "9635",
			"KIRKLARELI" => "9638",
			"KIRSEHIR" => "9646",
			"KILIS" => "9629",
			"KOCAELI" => "9654",
			"KONYA" => "9676",
			"KUTAHYA" => "9689",
			"MALATYA" => "9703",
			"MANISA" => "9716",
			"MARDIN" => "9726",
			"MERSIN" => "9737",
			"MUGLA" => "9747",
			"MUS" => "9755",
			"NEVSEHIR" => "9760",
			"NIGDE" => "9766",
			"ORDU" => "9782",
			"OSMANIYE" => "9788",
			"RIZE" => "9799",
			"SAKARYA" => "9807",
			"SAMSUN" => "9819",
			"SIIRT" => "9839",
			"SINOP" => "9847",
			"SIVAS" => "9868",
			"SANLIURFA" => "9831",
			"SIRNAK" => "9854",
			"TEKIRDAG" => "9879",
			"TOKAT" => "9887",
			"TRABZON" => "9905",
			"TUNCELI" => "9914",
			"USAK" => "9919",
			"VAN" => "9930",
			"YALOVA" => "9935",
			"YOZGAT" => "9949",
			"ZONGULDAK" => "9955"
	}

	plakalar = {
			"1"=>"ADANA",
			"2"=>"ADIYAMAN",
			"3"=>"AFYON",
			"4"=>"AGRI",
			"68"=>"AKSARAY",
			"5"=>"AMASYA",
			"6"=>"ANKARA",
			"7"=>"ANTALYA",
			"75"=>"ARDAHAN",
			"8"=>"ARTVIN",
			"9"=>"AYDIN",
			"10"=>"BALIKESIR",
			"74"=>"BARTIN",
			"72"=>"BATMAN",
			"69"=>"BAYBURT",
			"11"=>"BILECIK",
			"12"=>"BINGOL",
			"13"=>"BITLIS",
			"14"=>"BOLU",
			"15"=>"BURDUR",
			"16"=>"BURSA",
			"17"=>"CANAKKALE",
			"18"=>"CANKIRI",
			"19"=>"CORUM",
			"20"=>"DENIZLI",
			"21"=>"DIYARBAKIR",
			"81"=>"DUZCE",
			"22"=>"EDIRNE",
			"23"=>"ELAZIG",
			"24"=>"ERZINCAN",
			"25"=>"ERZURUM",
			"26"=>"ESKISEHIR",
			"27"=>"GAZIANTEP",
			"28"=>"GIRESUN",
			"29"=>"GUMUSHANE",
			"30"=>"HAKKARI",
			"31"=>"HATAY",
			"76"=>"IGDIR",
			"32"=>"ISPARTA",
			"33"=>"ICEL",
			"34"=>"ISTANBUL",
			"35"=>"IZMIR",
			"46"=>"KAHRAMANMARAS",
			"78"=>"KARABUK",
			"70"=>"KARAMAN",
			"36"=>"KARS",
			"37"=>"KASTAMONU",
			"38"=>"KAYSERI",
			"71"=>"KIRIKKALE",
			"39"=>"KIRKLARELI",
			"40"=>"KIRSEHIR",
			"79"=>"KILIS",
			"41"=>"KOCAELI",
			"42"=>"KONYA",
			"43"=>"KUTAHYA",
			"44"=>"MALATYA",
			"45"=>"MANISA",
			"47"=>"MARDIN",
			"48"=>"MUGLA",
			"49"=>"MUS",
			"50"=>"NEVSEHIR",
			"51"=>"NIGDE",
			"52"=>"ORDU",
			"80"=>"OSMANIYE",
			"53"=>"RIZE",
			"54"=>"SAKARYA",
			"55"=>"SAMSUN",
			"56"=>"SIIRT",
			"57"=>"SINOP",
			"58"=>"SIVAS",
			"63"=>"SANLIURFA",
			"73"=>"SIRNAK",
			"59"=>"TEKIRDAG",
			"60"=>"TOKAT",
			"61"=>"TRABZON",
			"62"=>"TUNCELI",
			"64"=>"USAK",
			"65"=>"VAN",
			"77"=>"YALOVA",
			"66"=>"YOZGAT",
			"67"=>"ZONGULDAK"
	}
	ilceKodu = sehirler[plakalar[ARGV.first]]

	if ilceKodu.nil?
		puts "Il bulunamadi"
	else
		fn = File.join(File.dirname($0), '.ezanvakti')
		File.write(fn, ilceKodu)
	end
else
	fn = File.join(File.dirname($0), '.ezanvakti')
	ilceKodu = 9541 # istanbul
	if File.file?(fn)
		ilceKodu = File.read(fn).lines.first
	end
	begin
		url = 'http://ezanvakti.herokuapp.com/vakitler?ilce='+ilceKodu
		uri = URI(url)
		response = Net::HTTP.get(uri)
	rescue SocketError
		puts '🚫'
		puts '---'
		puts 'İnternet bağlantısı yok.'
		exit
	end
	vakitler = JSON.parse(response)
	day = Time.now.strftime("%d.%m.%Y")
	vakit = vakitler[0]

	vakitler.each { |data| vakit = data if data['MiladiTarihKisa'] == day }

	now = Time.now
	remaining = 0
	vakitKeys = ['Imsak','Gunes','Ogle','Ikindi','Aksam','Yatsi']
	vakitLabels = ['İmsak','Güneş','Öğle','İkindi','Akşam','Yatsı']

	vakitKeys.each do |key|
		currVakit = Time.parse(vakit[key])
		remaining = currVakit - now
		if remaining > 0
			nextVakit = currVakit
			break
		end
	end

	str = "🕌 " << gethhmm(remaining) << "\n" << "---\n"
	str << vakit['HicriTarihUzun'] << "\n"
	vakitKeys.each_with_index { |key, index|
		str << "%-10s " % vakitLabels[index] << ' : '
		str << Time.parse(vakit[key]).strftime("%H:%M")
		str << "|font=Menlo size=12" << "\n"
	}
	puts str
end