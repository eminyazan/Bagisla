// ignore_for_file: constant_identifier_names

import 'package:bagisla/model/ad_category/ad_categories.dart';

const String LOCAL_DB_BOX = "localdb";
const String ONBOARD_BOX = "on_board_box";

const String DEFAULT_PP =
    'https://firebasestorage.googleapis.com/v0/b/bagisla-uygulama.appspot.com/o/assets%2Fdefault-pp.png?alt=media&token=78e2c9a8-49fb-416e-8968-81426fb4ed4f';

const List<Map<AdCategory, String>> adCategories = [
  {
    AdCategory.debt: "Fatura",
  },
  {
    AdCategory.credit: "Kredi",
  },
  {
    AdCategory.confiscation: "İcra",
  },
  {
    AdCategory.other: "Diğer",
  },
];

const String PRIVACY_POLICY = ''' 
Kullanıcı olarak tüm mesajlaşmayı ve bağış yardım işlemlerini Bağışla uygulaması üzerinden yapacağımı, herhangi bir başka platform üzerinden iletişime geçerek oluşabilecek magduriyetlerden Bağışla uygulaması sahiplerini ve paydaşlarının sorumlu tutmayacagimi taahhüt ederim. 

Veri Sorumlusu

6698 sayılı Kişisel Verilerin Korunması Kanunu uyarınca, kişisel verileriniz; veri sorumlusu olarak Bağışla tarafından aşağıda açıklanan kapsamda toplanacak ve işlenebilecektir.

Toplanan Kişisel Veriler

Bağışla, aşağıda belirtilen metodlarla Kullanıcılar’dan çeşitli statik (sabit) ve dinamik (değişken) veriler toplamaktadır. Bağışlanı'ın topladığı veriler, Kullanıcıların kullandığı hizmetlere ve özelliklere bağlıdır.

Ad ve İletişim Bilgileri: Ad, soyadı, cep telefonu, ev telefonu, iş telefonu, adresi, e-posta adresi, fatura bilgileri, TC kimlik numarası (ulusal kimlik numarası), kimlik ön yüzü fotokopisi ve benzer diğer belgeler

Kimlik Doğrulama Bilgileri: Kullanıcıların hesap bilgileri, kimliği doğrulamak için ve hesaba erişimi sağlamak için kullanılan parolaları, Kullanıcı Adı, kontak bilgileri, Kullanıcı numaraları, ilan numaraları, nüfus cüzdanı ön yüzü bilgileri, yeni kimlik ön yüzü bilgileri, yeni ehliyet ön yüzü bilgileri, kullanıcı selfie(özçekim) videosu, kimlik hologram videosu, fatura bilgileri.

Demografik Veriler: Doğum tarihi, cinsiyet, medeni hali, eğitim durumu, meslek, ilgi alanları, tercih edilen dil verileri.

Konum Verileri: Kullanıcıların hassas veya yaklaşık konumları ile ilgili verileri kapsar. GPS verisi ile IP ve port adreslerinden çıkarılan konum verisi, kullanıcı Bağışla'nın mobil uygulamalarını kullanırken, kendi bulunduğu konumun etrafındaki ilanları aramak ve ilan vermek istemesi durumunda ve kullanıcının izin vermesi halinde kullanılır.

Ödeme Verileri: Ajans ve müşteri fatura ve ödeme bilgileri (adı, soyadı, fatura adresi, TC kimlik numarası, vergi kimlik numarası), hesap sahibine gönderilen faturalar ve hesap sahiplerinden alınan ödemelere ait dekont örnekleri, ödeme numarası, fatura numarası, fatura tutarı, fatura kesim tarihi gibi veriler.

İçerik Verileri: Markanın sahte olmadığına dair talep edilen belgeler (fatura, garanti belgesi vs), ürünün kişiye ait olduğunu ya da ürün üzerindeki yetkisini gösteren belgeler (tapu, ruhsat, marka tescil belgesi, yetkilendirme sözleşmesinin ilgili kısımları gibi), ilan bilgileri, yetki belgesi, hesap bilgileri, bildirim açıklaması, çözüm açıklaması, memnuniyet, bildirim nedeni, müşteri notu, yenileme tarihi, ilan reddetme nedeni, geri bildirim, belge gönderim nedeni, Hizmet’in kullanımı sırasında belirtilen hata içeriği, ara bilgilendirme durumu, ara bilgilendirme, arama nedeni gibi benzer veriler.

Ad ve İletişim Bilgileri: Şirket içi değerlendirme, iletişim, Kullanıcı kayıt, potansiyel müşteri bilgisi elde etmek, satış sonrası süreçlerin geliştirilmesi, iş geliştirme, tahsilat, müşteri portföy yönetimi, promosyon,  analiz, şikayet yönetimi, müşteri memnuniyeti süreçlerini yönetmek, pazarlama, reklam, araştırma, faturalandırma, etkinlik bilgilendirmesi, operasyonel faaliyetlerin yürütülmesi, hizmet kalitesinin ölçülmesi, geliştirilmesi, denetim, kontrol, optimizasyon, müşteri doğrulama, satış, satış sonrası hizmetleri, dolandırıcılığın tespiti ve önlenmesi, çevrimiçi eğitim toplantılarına katılım sağlamak;

Filtrelere Takılmış veya Kullanım Koşullarına Aykırı İçerikteki Site İçi Mesajlar: Mesajlaşma hizmetimiz, kullanıcılarımızın alım, satım ve kiralama işlemlerinde karşı taraf ile iletişim kurmalarını kolaylaştırmak amacı ile sunulmaktadır. Bu kapsamdaki mesajlarda; Kanun’un 5. Maddesindeki meşru menfaate dayalı olarak, hakaret içeren, genel ahlaka aykırı, dolandırıcılık maksatlı ilan verildiği konusunda şüphe uyandıran, haksız rekabete neden olabilecek, kişilik haklarını, fikri ve sınai mülkiyet haklarını ihlal eden ve sair surette hukuka aykırılık içeren mesajlar filtrelenerek moderasyona tabi tutulmakta,  kullanım koşullarına aykırı içerikteki site içi mesajlar incelenerek engellenebilmektedir.
''';
