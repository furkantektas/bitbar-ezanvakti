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

def secs_to_hhmm(secs)
	str = ""
	h = (secs / 3600).to_i
	secs -= h * 3600

	m = (secs / 60).to_i

	str << "%02i:%02i" % [h, m]
	str
end

def turkish_month_to_idx(month)
	s = month.downcase
	months = %w[ocak şubat mart nisan mayıs haziran temmuz ağustos eylül ekim kasım aralık]
	months.index(s)
end

def turkish_date_str_to_date(date_str)
	date_parts = date_str.split(" ")
	day = date_parts[0].to_i
	month = turkish_month_to_idx(date_parts[1])
	year = date_parts[2].to_i
	Time.new(year, month + 1, day).strftime("%d.%m.%Y")
end

def valid_json?(string)
	!!JSON.parse(string)
rescue JSON::ParserError
	false
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
		"1" => "ADANA",
		"2" => "ADIYAMAN",
		"3" => "AFYON",
		"4" => "AGRI",
		"68" => "AKSARAY",
		"5" => "AMASYA",
		"6" => "ANKARA",
		"7" => "ANTALYA",
		"75" => "ARDAHAN",
		"8" => "ARTVIN",
		"9" => "AYDIN",
		"10" => "BALIKESIR",
		"74" => "BARTIN",
		"72" => "BATMAN",
		"69" => "BAYBURT",
		"11" => "BILECIK",
		"12" => "BINGOL",
		"13" => "BITLIS",
		"14" => "BOLU",
		"15" => "BURDUR",
		"16" => "BURSA",
		"17" => "CANAKKALE",
		"18" => "CANKIRI",
		"19" => "CORUM",
		"20" => "DENIZLI",
		"21" => "DIYARBAKIR",
		"81" => "DUZCE",
		"22" => "EDIRNE",
		"23" => "ELAZIG",
		"24" => "ERZINCAN",
		"25" => "ERZURUM",
		"26" => "ESKISEHIR",
		"27" => "GAZIANTEP",
		"28" => "GIRESUN",
		"29" => "GUMUSHANE",
		"30" => "HAKKARI",
		"31" => "HATAY",
		"76" => "IGDIR",
		"32" => "ISPARTA",
		"33" => "ICEL",
		"34" => "ISTANBUL",
		"35" => "IZMIR",
		"46" => "KAHRAMANMARAS",
		"78" => "KARABUK",
		"70" => "KARAMAN",
		"36" => "KARS",
		"37" => "KASTAMONU",
		"38" => "KAYSERI",
		"71" => "KIRIKKALE",
		"39" => "KIRKLARELI",
		"40" => "KIRSEHIR",
		"79" => "KILIS",
		"41" => "KOCAELI",
		"42" => "KONYA",
		"43" => "KUTAHYA",
		"44" => "MALATYA",
		"45" => "MANISA",
		"47" => "MARDIN",
		"48" => "MUGLA",
		"49" => "MUS",
		"50" => "NEVSEHIR",
		"51" => "NIGDE",
		"52" => "ORDU",
		"80" => "OSMANIYE",
		"53" => "RIZE",
		"54" => "SAKARYA",
		"55" => "SAMSUN",
		"56" => "SIIRT",
		"57" => "SINOP",
		"58" => "SIVAS",
		"63" => "SANLIURFA",
		"73" => "SIRNAK",
		"59" => "TEKIRDAG",
		"60" => "TOKAT",
		"61" => "TRABZON",
		"62" => "TUNCELI",
		"64" => "USAK",
		"65" => "VAN",
		"77" => "YALOVA",
		"66" => "YOZGAT",
		"67" => "ZONGULDAK"
	}
	ilce_kodu = sehirler[plakalar[ARGV.first]]

	if ilce_kodu.nil?
		puts "Il bulunamadi"
	else
		fn = File.join(File.dirname($0), '.ezanvakti')
		File.write(fn, ilce_kodu)
	end
else
	fn = File.join(File.dirname($0), '.ezanvakti')
	ilce_kodu = 9541 # istanbul
	if File.file?(fn)
		ilce_kodu = File.read(fn).lines.first
	end
	begin
		url = 'https://namaz-vakti-api.herokuapp.com/data?region=' + ilce_kodu.to_s
		uri = URI(url)
		response = Net::HTTP.get(uri)
	rescue SocketError
		puts '🚫'
		puts '---'
		puts 'İnternet bağlantısı yok.'
		exit
	end
	if valid_json?(response)
		vakitler = JSON.parse(response)
		day = Time.now.strftime("%d.%m.%Y")
		vakit = vakitler[1]
		vakitler.each { |data| vakit = data if turkish_date_str_to_date(data[0]) == day }
		now = Time.now
		remaining = 0
		vakit_labels = %w[İmsak Güneş Öğle İkindi Akşam Yatsı]

		(1..6).each do |idx|
			remaining = Time.parse(vakit[idx]) - now
			if remaining > 0
				break
			end
		end
		if remaining < 0
			tomorrow = (Time.now + 24 * 60 * 60).strftime("%d.%m.%Y")
			vakitler.each { |data| vakit = data if turkish_date_str_to_date(data[0]) == tomorrow }
			remaining = Time.parse(vakit[1]) + 24 * 60 * 60  - now
		end
		str = "🕌 " << secs_to_hhmm(remaining) << "\n" << "---\n"
		str << vakit[0] << "\n"
		vakit_labels.each_with_index { |label, idx|
			str << "%-10s " % label << ' : '
			str << Time.parse(vakit[idx + 1]).strftime("%H:%M")
			str << "|font=Menlo size=12" << "\n"
		}
		puts str
	else
		puts '🚫'
		puts '---'
		puts 'Veri alınamıyor.'
		puts 'Yenileme sıklığını azaltmayı deneyebilirsiniz.'
	end
end
