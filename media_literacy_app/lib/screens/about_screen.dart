import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/footer_logos.dart';
import 'package:media_literacy_app/widgets/responses.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class TextScreen extends StatelessWidget {
  final String title;
  final Color color;
  final Image logo;
  final Widget child;

  const TextScreen({super.key, required this.title, required this.color, required this.logo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBarWithBackButton(
        context,
        title,
        color: color,
        logo: logo,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        color: AppColors.selectStoryBackground,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: SafeArea(
                bottom: false,
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      child,
                      const FooterLogos().padding(top: 4).alignment(Alignment.bottomCenter).expanded(),
                    ],
                  ).padding(top: 28),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TextScreen(
      title: "Za nastavnike/ce",
      color: AppColors.selectAboutBackground,
      logo: Image.asset('assets/images/icon-info.png'),
      child: const AboutText(),
    );
  }
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TextScreen(
      title: "Dodatne informacije",
      color: AppColors.selectInfoBackground,
      logo: Image.asset('assets/images/icon-logo.png'),
      child: const InfoText(),
    );
  }
}

Widget _buildHeading(String text) {
  return Text(text)
      .textStyle(AppTextStyles.aboutParagraph)
      .fontWeight(FontWeight.w700)
      .padding(all: 4)
      .backgroundColor(AppColors.selectAboutBackground)
      .clipRRect(all: 4)
      .padding(bottom: 12, horizontal: 16);
}

Widget _buildParagraph(String text, {bool bold = false, bool background = false}) {
  return _buildParagraphImpl(
    Text(text).textStyle(AppTextStyles.aboutParagraph).fontWeight(bold ? FontWeight.w600 : FontWeight.w400),
    background: background,
  );
}

Widget _buildParagraphRich(List<TextSpan> spans, {bool background = false}) {
  return _buildParagraphImpl(
    Text.rich(
      style: AppTextStyles.aboutParagraph,
      TextSpan(children: spans),
    ),
    background: background,
  );
}

Widget _buildParagraphImpl(Text text, {bool background = false}) {
  Widget widget = text;
  if (background) {
    widget = widget.padding(vertical: 8, horizontal: 10).backgroundColor(const Color(0x80D8D3C1)).clipRRect(all: 4).padding(horizontal: 8);
  } else {
    widget = widget.padding(horizontal: 16);
  }
  return widget.width(double.infinity).padding(bottom: 12);
}

Widget _buildListItem(String number, String text, {bool bold = false}) {
  return _buildListItemImpl(
    number,
    Text(text).textStyle(AppTextStyles.aboutParagraph).fontWeight(bold ? FontWeight.w600 : FontWeight.w400),
  );
}

Widget _buildListItemRich(String number, List<TextSpan> spans) {
  return _buildListItemImpl(
    number,
    Text.rich(
      style: AppTextStyles.aboutParagraph,
      TextSpan(children: spans),
    ),
  );
}

Widget _buildListItemImpl(String number, Text text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(number)
          .textStyle(AppTextStyles.aboutParagraph)
          .fontWeight(FontWeight.w600)
          .padding(vertical: 2, horizontal: 6)
          .backgroundColor(AppColors.selectInfoBackground)
          .clipOval()
          .padding(right: 8),
      Expanded(
        child: text.padding(top: 2, bottom: 12),
      ),
    ],
  ).padding(horizontal: 16);
}

Widget _buildBulletPointItem(String text, {bool bold = false, bool last = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("•").textStyle(AppTextStyles.aboutParagraph).fontWeight(bold ? FontWeight.w600 : FontWeight.w400).padding(right: 8),
      Expanded(
        child: Text(text).textStyle(AppTextStyles.aboutParagraph).fontWeight(bold ? FontWeight.w600 : FontWeight.w400),
      ),
    ],
  ).padding(horizontal: 16, bottom: last ? 12 : 0);
}

Widget _buildImage(BuildContext context, Image image, String caption) {
  void onImageTap() {
    showImageViewer(
      context,
      image.image,
      doubleTapZoomable: true,
      immersive: false,
    );
  }

  return Column(
    children: [
      image,
      Row(
        children: [
          const SizedBox.square(
            dimension: 24,
            child: Icon(Icons.zoom_in, size: 18, color: Colors.white),
          ).backgroundColor(AppColors.youtubePlayButton).clipOval().padding(right: 8),
          Text(caption).textStyle(AppTextStyles.aboutParagraph).fontWeight(FontWeight.w600),
        ],
      ).padding(top: 12),
    ],
  )
      .padding(bottom: 12, top: 16, horizontal: 10)
      .backgroundColor(const Color(0x80D8D3C1))
      .clipRRect(all: 4)
      .gestures(onTap: onImageTap)
      .padding(horizontal: 8, bottom: 12);
}

TextSpan _buildUrlSpan(String text, String url) {
  return TextSpan(
    text: text,
    style: const TextStyle(decoration: TextDecoration.underline),
    recognizer: TapGestureRecognizer()
      ..onTap = () {
        AppSystemSettings.openURL(url);
      },
  );
}

class AboutText extends StatelessWidget {
  const AboutText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          "Drage/i nastavnice/i, dobro došle/i u sekciju aplikacije Mislimetar namijenjenu vama.U ovom dijelu nudimo prijedloge ideje za rad s "
          "učenicima/ama na času. Podijelili smo prijedloge po tematskom sadržaju svakog od modula Mislimetra. Prijedlozi ni na koji način nisu "
          "obavezujući niti su u nekoj uzročno-posljedičnoj vezi sa sadržajima same aplikacije koju učenici/e prolaze; služe samo kao početna "
          "ideja.",
          bold: true,
        ),
        _buildParagraph("Prijedloge za rad u učionici možete pronaći u PDF formatu, kao i u nastavku ove sekcije."),
        ResponseButton(
          text: "Preuzmi PDF",
          image: Image.asset("assets/images/dl-pdf.png"),
          onTap: () {
            AppSystemSettings.openURL("https://drive.google.com/file/d/1uJrGSm8OA2f6XTI9SNMhjQRdmxc1tu3R/view");
          },
        ).padding(horizontal: 16, vertical: 12),
        _buildHeading("Modul 1"),
        _buildListItem(
          "1.",
          "Koristeći ovaj link sa Raskrinkavanje.ba saznajte više o pojmu medijske pismenosti:",
          bold: true,
        ),
        _buildParagraphRich(
          [
            _buildUrlSpan(
              "https://medijskapismenost.raskrinkavanje.ba/saznajte-vise/sta-je-medijska-pismenost/",
              "https://medijskapismenost.raskrinkavanje.ba/saznajte-vise/sta-je-medijska-pismenost/",
            ),
          ],
          background: true,
        ),
        _buildParagraph(
          "Nakon čitanja teksta s učenicima raditi istraživanje s nekoliko ključnih pitanja koja postavljaju svi u učionici, šta ih zanima; na "
          "primjer: Kada se počinje govoriti o medijskoj pismenosti? Zašto je danas važno biti medijski pismen? Kako medijska pismenost pomaže "
          "razvoju demokratskog društva? Ili uz pomoć KWL tabele (Šta znam?, Šta sam naučio? Šta želim znati?) učenici samostalno čitaju tekst i "
          "na osnovu popunjene KWL tabele dogovaraju se naredne aktivnosti.",
        ),
        _buildListItem(
          "2.",
          "Detaljno razgovarati o vezi medijske pismenosti i kritičkog mišljenja. Koje su zajedničke karakteristike, gdje se pojmovi preklapaju, "
              "gdje se razilaze? Možemo li za sebe reći da smo medijski pismeni, ako ne koristim alate kritičkog mišljenja u svakodnevnom životu?",
        ),
        _buildListItem(
          "3.",
          "Zadaci u grupama: Izabrati jednu aktuelnu vijest o kojoj pišu internetski portali i upoređivati tekstove; primjećivati sličnosti i "
              "razlike. Ili: Čitati više različitih tekstova na jednom portalu na osnovu kojih učenici postavljaju pitanja na osnovu sadržaja teksta, "
              "provjeravaju informacije, traže druge izvore i pokušavaju bolje napisati vijest s informacijama koje imaju.",
        ),
        _buildListItem(
          "4.",
          "Individualno ili u grupama učenika/ca, uraditi kviz o medijskoj pismenosti platforme Raskrinkavanje, dostupan na linku ispod.",
        ),
        _buildParagraphRich(
          [
            _buildUrlSpan(
              "https://medijskapismenost.raskrinkavanje.ba/kviz/",
              "https://medijskapismenost.raskrinkavanje.ba/kviz/",
            ),
          ],
          background: true,
        ),
        _buildParagraph(
          "Kviz od 24 pitanja podijeljen je u tri oblasti, a tačni odgovori i njihova objašnjenja dostupni su na kraju.",
          bold: true,
        ),
        _buildHeading("Modul 2"),
        _buildListItem(
          "1.",
          "S učenicima istražiti impressume medija koje koriste i učenici i nastavnici; vidjeti da li svi sadrže potrebne informacije o mediju - "
              "vlasnici, urednici, novinari, saradnici. Razgovarati o onome što su učenici našli - vidjeti da li su kao izvor informacija koristili "
              "medije koji nemaju potrebne podatke u impressumu?",
        ),
        _buildListItem(
          "2.",
          "Zadatak za učenike: u nekom dogovorenom vremenskom intervalu prate svoje medijske aktivnosti - na koje linkove kliknu, šta im izlazi "
              "kao učestala informacija s više medija, da li upoređuju različite medijske izvore koje govore o istom događaju? Šta najčešće gledaju, "
              "čitaju, slušaju? Učenici mogu bilježiti i ukupno vrijeme potrošeno na medije u tom dogovorenom periodu i razgovarati o tome da li je to "
              "dovoljno vremena, da li su mogli raditi nešto drugo; koliko su imali koristi od toga…",
        ),
        _buildListItem(
          "3.",
          "Pomoću grafičkog organizera vennov dijagram razmotriti, na primjer, različito konzumiranje medija sada i prije 20 godina. Naravno, "
              "potrebno je istražiti kako je izgledao medijski svijet 2003. godine.",
        ),
        _buildHeading("Modul 3"),
        _buildListItem(
          "1.",
          "Model 5 pitanja: Izabrati nekoliko novinskih članaka i odjeljenju provjeriti da li postoje odgovori na svih 5 pitanja; procijeniti koje "
              "su potpune, a koje nepotpune vijesti.",
        ),
        _buildListItem(
          "2.",
          "Na istim odabranim člancima provjeriti koliko je činjenica, a koliko mišljenja u samom tekstu. Prijedlog je da se i posebno analizira "
              "odnos mišljenja i činjenica u kolumnama i da se provjeri na osnovu kojih činjenica autorica ili autor kolumne kreira svoje mišljenje.",
        ),
        _buildHeading("Modul 4"),
        _buildListItem(
          "1.",
          "Razgovarati o drugim poznatim teorijama zavjere s učenicima; kroz istraživanje i pripremu koju nastavnici zajedno rade s učenicima, "
              "pokušati raskrinkati teoriju zavjere činjenicama, odnosno traženjem izvora informacija za pojedine segmente izabrane teorije zavjere.",
        ),
        _buildParagraph("Na primjer:", bold: true),
        _buildBulletPointItem("Slijetanje na Mjesec nikad se nije dogodilo, snimljen je u filmskom studiju"),
        _buildBulletPointItem("Covid 19 svjesno korišten da se stanovništvo zarazi"),
        _buildBulletPointItem("5G mreža čini čuda ljudima", last: true),
        _buildHeading("Modul 5"),
        _buildParagraphRich([
          const TextSpan(
            text: "Drvo problema - ",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const TextSpan(
            text: "„Drvo problema“ je strategija za analizu, odnosno vizuelno prezentovanje problema kroz njegove uzroke i posljedice. "
                "Aktivnost otpočinje definisanjem problema koji analizirate. Pretpostavka je da učenici/e već znaju dosta o tom problemu, "
                "ili imaju neka iskustva. Na tabli ili velikom papiru nacrtajte drvo s granama i korijenjem. Pored stabla drveta napišite "
                "ključni problem koji istražujete.",
          ),
        ]),
        _buildParagraph(
          "Prijedlog problema: Teško je prepoznati koje su istinite, a koje nepotpune ili lažne informacije",
          bold: true,
        ),
        _buildParagraph(
          "Zajedno sa učenicima/ama otpočnite aktivnost tako da prodiskutujete i ispod korijenja pokušate upisati što veći broj uzroka tog problema "
          "kojih se možete sjetiti, a iznad grana sve posljedice koje taj problem može izazvati. Učenici/e mogu na većem papiru, u grupama, nacrtati "
          "slično drvo i nastaviti raditi na istom problemu, ili osmisliti svoj.",
        ),
        _buildParagraph(
          "Tokom rada i diskusije javiće se potreba da neke uzroke i posljedice dodatno istražite i saznate konkretnije podatke. Zabilježite sva "
          "pitanja i dileme koje se javljaju i potaknite učenike da pronađu odgovore na postavljena pitanja.",
        ),
        _buildParagraph(
          "Kada završite prvi niz očiglednih uzroka i posljedica, možete krenuti u dalje istraživanje koje je polazna osnova za kauzalni model. Za "
          "svaki uzrok postavite pitanje: A šta uzrokuje tu pojavu, kako je do toga došlo? Kod posljedica možete razmatrati kratkoročne i dugoročne "
          "posljedice.",
        ),
        _buildParagraph(
          "Kompleksnija verzija drveta problema zahtijeva identifikaciju primarnih i sekundarnih uzroka, kao i primarnih i sekundarnih posljedica. "
          "Primarni uzroci su šire oblasti koje obuhvataju više sekundarnih uzroka. Primarne posljedice su one kratkoročne, one koje prve očukujemo, "
          "dok su sekundarne posljedice dugoročni rezultati. Ovakav pristup analizi problema ukazuje na moguća rješenja – koja proizlaze iz "
          "djelovanja na uzroke, i rezultata koje želimo postići – koja proizlaze iz posljedice.",
        ),
        _buildHeading("Modul 6"),
        _buildListItem(
          "1.",
          "Šest šešira je kretivna tehnika za rješavanje problema zasnovana na teoriji Edwarda de Bonoa o lateralnom (paralelnom) mišljenju. Za "
              "razliku od pristupa u rješavanju problema suočavanjem i sukobljavanjem mišljenja, ova tehnika omogućava djeci da surađuju, sagledavajući "
              "problem iz različitih perspektiva.",
        ),
        _buildParagraph(
          "Za početak je važno da svaki učenik/ca prođe kroz svih šest pristupa u sagledavanju problema (možete svaki dan posvetiti samo jednom "
          "šeširu). Tehnika se može koristiti na različite načine: svaka grupa može dobiti jednu karticu sa šeširom određene boje i opisom postupka. "
          "U tom slučaju odjeljenje je podijeljeno u šest grupa, a svaka grupa prakticira jedan od pristupa problemu.",
        ),
        _buildParagraph(
          "Druga mogućnost je da imamo šestočlane grupe unutar kojih svatko dobije jedan od šešira i doprinosi diskusiji iz svog ugla, dok u drugoj "
          "situaciji cijela grupa može preuzeti prvo ulogu „bijelog šešira“ i prikupiti sve informacije, a zatim preći na ostale šešire i sl.",
        ),
        _buildListItem("2.", "O šeširima"),
        _buildParagraph(
          "BIJELI ŠEŠIR zanimaju informacije. Kada stavimo bijeli šešir, tada postavljamo neka od sljedećih pitanja: Šta znamo? Koje informacije "
          "trebamo? Šta bismo trebali pitati? Bijeli šešir se koristi kako bismo usmjerili pažnju na informacije koje imamo ili nam nedostaju.",
        ),
        _buildParagraph(
          "CRVENI ŠEŠIR upućuje na vatru i toplinu, i povezan je s osjećajima i intuicijom. Svaka osoba ima određena osjećanja u vezi s predmetom "
          "analize ili izučavanja, i crveni šešir nam daje dozvolu da ih iskažemo i uzmemo u obzir prilikom analize.",
        ),
        _buildParagraph(
          "Crna boja nas podsjeća na plašt. CRNI ŠEŠIR nas poziva na oprez, ali i čuva od nepromišljenih odluka koje bi mogle biti štetne. Crni "
          "šešir nas upozorava na rizik i na moguće nedostatke naših odluka. Zadatak je da analiziramo probleme koji se mogu pojaviti, poteškoće "
          "na koje možemo naići, kao i posljedice koje bi mogle proizaći iz promjena, kako bismo ih preduprijedili.",
        ),
        _buildParagraph(
          "Žuto podsjeća na sunce i optimizam. Pod ŽUTIM ŠEŠIROM nastojimo pronaći sve ono što je pozitivno. To možemo učiniti postavljajući neka od "
          "sljedećih pitanja: Šta su prednosti? Ko će imati koristi? Koje pozitivne stvari mogu proizaći? Koje su ostale vrijednosti o kojima govorimo?",
        ),
        _buildParagraph(
          "Zeleno podsjeća na vegetaciju, koja upućuje na rast, energiju i život. ZELENI ŠEŠIR je kreativni šešir. On je namijenjen planiranju i "
          "stvaranju novih ideja. Razmišljajući iz perspektive zelenog šešira, možemo predlagati promjene i alternative predloženim idejama, ma "
          "kako „lude“ i kreativne one bile. On nam omogućuje da sagledamo niz različitih prilika i rješenja koja bi mogla postojati.",
        ),
        _buildParagraph(
          "PLAVI ŠEŠIR je namijenjen razmatranju samog procesa mišljenja. Naprimjer, možemo se zapitati što ćemo sljedeće učiniti, ili u čemu smo "
          "do sada uspjeli. Plavi šešir možemo koristiti na početku rasprave kako bismo odlučili o čemu ćemo raspravljati i šta očekujemo od "
          "rasprave. On nam može pomoći u dogovaranju rasporeda korištenja ostalih šešira. Plavi šešir može poslužiti za razmatranje učinjenog "
          "na kraju rasprave.",
        ),
        _buildImage(
          context,
          Image.asset("assets/images/about/Table 1 - Prijedlog vježbe za aktivnost šest šešira.png"),
          "Povećaj tabelu",
        ),
        _buildListItem(
          "3.",
          "Prijedlog vježbe za aktivnost šest šešira: Mladi provode mnogo vremena gledajući videa na YouTube-u",
        ),
        _buildHeading("Modul 7"),
        _buildListItemRich(
          "1.",
          [
            const TextSpan(
              text:
                  "Debata je organizovan način izmjene mišljenja, odnosno dijaloška komunikacija koja se temelji na procesu argumentacije. U debati "
                  "uglavnom nastupaju dvije strane, koje imaju jednake mogućnosti predstaviti svoje ",
            ),
            _buildUrlSpan(
              "argumente",
              "https://hr.wikipedia.org/wiki/Argument",
            ),
            const TextSpan(
              text: " sa ciljem da druge uvjere u svoje stanovište, odnosno da svoje mišljenje učine racionalno prihvatljivim za sagovornike.",
            ),
          ],
        ),
        _buildListItemRich(
          "2.",
          [
            const TextSpan(
              text: "U razredu sa učenicima možete povesti razgovor o nekoj od vijesti sa ",
            ),
            _buildUrlSpan(
              "Raskrinkavanje.ba",
              "https://raskrinkavanje.ba/",
            ),
            const TextSpan(
              text: " kao što je ova: ",
            ),
            _buildUrlSpan(
              "Snimak “tornada” u Srbiji star je nekoliko godina",
              "https://raskrinkavanje.ba/analiza/snimak-tornada-u-srbiji-star-je-nekoliko-godina",
            )
          ],
        ),
        _buildListItem(
          "3.",
          "Učenici čitaju vijest o istom događaju s više portala (linkovi su dostupni u tekstu); nakon toga čitaju ovaj cjeloviti tekst s "
              "Raskrinkavanja.ba",
        ),
        _buildListItem(
          "4.",
          "Razgovorajte o samom otkriću, metodama provjere fotografije, izborima koji se koriste, dokazima za tvrdnje…",
        ),
        _buildListItem(
          "5.",
          "Podijelite se u timove i organizirajte debatu sa svim njenim pravilima",
        ),
        _buildListItem(
          "6.",
          "Za ocjenjivanje debate možete koristiti i različite kriterije i indikatore. Ovo je primjer jedne tabele kriterija koju možete koristiti:",
        ),
        _buildImage(
          context,
          Image.asset("assets/images/about/Table 2 - tabela kriterija.png"),
          "Povećaj tabelu",
        ),
        _buildListItem(
          "7.",
          "Prijedlozi tema za debatu sa učenicima/ama:",
        ),
        _buildBulletPointItem(
          "Šta radimo s informacijama koje imamo?",
        ),
        _buildBulletPointItem(
          "Da li nas informacije pokreću da djelujemo, da sami objavljujemo mišljenja o temi koja nas tangira?",
        ),
        _buildBulletPointItem(
          "Koliko su informacije koje konzumiramo vezane za lokalne probleme i zajednicu u kojoj živimo?",
          last: true,
        ),
      ],
    ).padding(bottom: 16);
  }
}

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildParagraph(
          "Dobro došle/i u sekciju “Dodatne informacije” aplikacije Mislimetar! Za preuzimanje najnovije verzije aplikacije, kliknite dugme "
          "ispod. Preuzimanjem nove verzije poništavate vaše postojeće ostvarene rezultate.",
          bold: true,
        ),
        ResponseButton(
          text: "Preuzmi najnoviju verziju",
          image: Image.asset("assets/images/dl-update.png"),
          onTap: () {
            appState.resetAppState(context);
          },
        ).padding(horizontal: 16, vertical: 12),
        _buildParagraph(
          "U ovom dijelu aplikacije možete pronaći sljedeće informacije:",
          bold: true,
        ),
        _buildBulletPointItem("O Mislimetru"),
        _buildBulletPointItem("Sadržaj aplikacije"),
        _buildBulletPointItem("Korisni linkovi"),
        _buildBulletPointItem("Leksikon manje poznatih pojmova", last: true),
        _buildHeading("O Mislimetru"),
        _buildParagraph(
          "Mobilna aplikacija Mislimetar edukacijski je i zabavni alat namijenjen za korištenje u formalnom i neformalnom obrazovanju. Cilj je "
          "Mislimetra podsticanje razvoja kritičkog promišljanja i medijske pismenosti kod mladih.",
        ),
        _buildParagraph(
          "Aplikaciju su kreirala udruženja građana i građanki Centar za obrazovne inicijative “Step by Step” i “Zašto ne”. Za tehničku "
          "implementaciju aplikacije zadužena je organizacija “Danes je nov dan”. Razvoj aplikacije finansirala je Evropska unija.",
          bold: true,
          background: true,
        ),
        _buildParagraph(
          "Centar za obrazovne inicijative “Step by Step” profesionalna je nevladina organizacija osnovana s ciljem da promoviše obrazovnu "
          "filozofiju usmjerenu na dijete i pravo svakog djeteta na kvalitetan odgoj i obrazovanje na području cijele Bosne i Hercegovine od 1996. "
          "godine. Kroz razgranatu mrežu učitelja/ica, škola, certificiranih trenera/ica, kao i kroz saradnju s drugim lokalnim i međunarodnim "
          "organizacijama te ministarstvima obrazovanja i pedagoškim zavodima, Centar za obrazovne inicijative “Step by Step” prepoznat je kao "
          "jedna od vodećih organizacija u oblasti profesionalnog razvoja nastavnika/ca, unapređenja kvaliteta obrazovanja i promovisanja "
          "vrijednosti i principa društvene pravde.",
        ),
        _buildParagraph(
          "Udruženje građana i građanki “Zašto ne” organizacija je koja se bavi stvaranjem sigurnog, zdravog, aktivnog, efikasnog i odgovornog bh. "
          "društva u cjelini kako u smislu predstavnika/ca vlasti, tako i u smislu civilnog društva i građana/ki, kroz promociju i uspostavu "
          "mehanizama političke odgovornosti, jačanje i izgradnju građanskog aktivizma, promociju odgovornosti medija te korištenje novih medija "
          "i tehnologija.",
        ),
        _buildParagraph(
          "“Danes je nov dan” je organizacija civilnog društva sa sjedištem u Ljubljani, u Sloveniji. Njihova misija je da promovišu otvorenost "
          "podataka, odgovornu tehnologiju i participativno donošenje odluka.",
        ),
        _buildHeading("Sadržaj aplikacije"),
        _buildParagraph(
          "Sadržaj aplikacije podijeljen je na sedam tematskih modula. Sedam modula Mislimetra su:",
          bold: true,
        ),
        _buildListItem("1.", "Kritičko mišljenje i medijska i informacijska pismenost"),
        _buildListItem("2.", "Mediji i društvene mreže: Organizacija i analiziranje informacija"),
        _buildListItem("3.", "Svijet činjenica, mišljenja i dezinformacija"),
        _buildListItem("4.", "Ravna zemlja, gušteri-vanzemaljci i lažno slijetanje na Mjesec: Šta su teorije zavjere?"),
        _buildListItem("5.", "Snaga uzroka i posljedica"),
        _buildListItem("6.", "Tehnika šest šešira: Kako riješiti problem uz različite perspektive"),
        _buildListItem("7.", "Debate - praktična primjena kritičkog mišljenja i medijske i informacijeke pismenosti"),
        _buildParagraph(
          "Moduli su interaktivni i kreirani tako da obuhvataju različite segmente kritičkog mišljenja i medijske pismenosti. Sastoje se od "
          "videosnimaka, tekstualnih objašnjenja, slika i pitanja za korisnice i korisnike. Sažetke modula Mislimetra možete pronaći u dokumentu "
          "u nastavku.",
        ),
        ResponseButton(
          text: "Preuzmi PDF",
          image: Image.asset("assets/images/dl-pdf.png"),
          onTap: () {
            AppSystemSettings.openURL("https://drive.google.com/file/d/1emIt_XgKcbr0tt8lYNlbnczlDcfNn9GQ/view");
          },
        ).padding(horizontal: 16, vertical: 12),
        _buildHeading("Korisni linkovi"),
        _buildParagraphRich(
          [
            const TextSpan(text: "Udruženje građanki i građana “Zašto ne”: \n"),
            _buildUrlSpan("https://zastone.ba/", "https://zastone.ba/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Raskrinkavanje.ba: \n"),
            _buildUrlSpan("https://raskrinkavanje.ba/", "https://raskrinkavanje.ba/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Istinomjer.ba: \n"),
            _buildUrlSpan("https://istinomjer.ba/", "https://istinomjer.ba/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Centar za obrazovne inicijative “Step by Step”: \n"),
            _buildUrlSpan("https://sbs.ba/", "https://sbs.ba/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "InŠkola - Zajednica inovativnih nastavnika/nastavnica: \n"),
            _buildUrlSpan("https://inskola.com/", "https://inskola.com/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Više o medijskoj pismenosti: \n"),
            _buildUrlSpan("https://medijskapismenost.raskrinkavanje.ba/", "https://medijskapismenost.raskrinkavanje.ba/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Priručnik “Fact-checking i online novinarstvo”: \n"),
            _buildUrlSpan("https://raskrinkavanje.ba/uploads/Fact-checking%20i%20online%20novinarstvo.pdf",
                "https://raskrinkavanje.ba/uploads/Fact-checking%20i%20online%20novinarstvo.pdf"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Videolekcije o medijskoj pismenosti: \n"),
            _buildUrlSpan("https://www.youtube.com/playlist?list=PLS2ByUfTwzeaU1v1ywpNu8A2NuWh2rWVf",
                "https://www.youtube.com/playlist?list=PLS2ByUfTwzeaU1v1ywpNu8A2NuWh2rWVf"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Kviz medijske pismenosti i provjere činjenica: \n"),
            _buildUrlSpan("https://kviz.raskrinkavanje.ba/", "https://kviz.raskrinkavanje.ba/"),
            const TextSpan(text: "\n"),
            _buildUrlSpan("https://medijskapismenost.raskrinkavanje.ba/kviz/", "https://medijskapismenost.raskrinkavanje.ba/kviz/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Korisni nastavni resursi: \n"),
            _buildUrlSpan("https://inskola.com/publikacije-i-prirucnici/", "https://inskola.com/publikacije-i-prirucnici/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Obrazovni materijali o medijskoj pismenosti: \n"),
            _buildUrlSpan("https://www.medijskapismenost.hr/obrazovni-materijali-za-preuzimanje/",
                "https://www.medijskapismenost.hr/obrazovni-materijali-za-preuzimanje/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "“Step by Step” izdanja: \n"),
            _buildUrlSpan("https://shop.inskola.com/", "https://shop.inskola.com/"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "Besjede o obrazovanju: \n"),
            _buildUrlSpan("https://www.youtube.com/watch?v=du6znUywTGo", "https://www.youtube.com/watch?v=du6znUywTGo"),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(text: "“Step by Step” biblioteka: \n"),
            _buildUrlSpan("https://sbsbiblioteka.librarika.com/search/catalogs", "https://sbsbiblioteka.librarika.com/search/catalogs"),
          ],
        ),
        _buildHeading("Leksikon manje poznatih pojmova"),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Benigno - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "bezazleno, dobroćudno, bezopasno",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Činjenice - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "nešto što je istinito i što se može dokazati, potkrijepiti podacima",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Kohezija - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "međusobna povezanost, uravnoteženost",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Kreativno mišljenje - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "sposobnost da izađemo iz naučenih obrazaca mišljenja i sagledamo nove perspektive u rješavanju problema, stvaramo nove "
                  "vrijednosti i produkte",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Kredibilitet - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "pouzdanost, vjerodostojnost",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Kritičko mišljenje - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "sposobnost rješavanja problema, analize, rezonovanja i logičkog zaključivanja",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Mislimetar - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "pokazuje nam koliko se naš mozak napreže kad nešto mislimo",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Mišljenje - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "vještina koja se stiče i razvija, koja zahtijeva strpljenje, mnoštvo prilika za vježbanje, podržavajuće okruženje i modelovanje",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Protagonist/kinja - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "glavni lik u književnom, filmskom ili pozorišnom djelu; aktivan/na učesnik/ca u nekom događaju; lider/ka, zagovornik/ca ili "
                  "pristalica određenog cilja ili ideje (rječnik Merriam Webster)",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Relevantno - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "značajno, važno",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Strategije, metode i tehnike - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "načini rada i alati koji se koriste u procesu učenja i poučavanja",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Tri sprata intelekta - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "model koji je razvio Arthur Costa, jednostavna i dobro strukturirana taksonomija nižih i viših razina mišljenja",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Uredništvo medija - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "jedan/na ili više urednika/ca koji/e uređuju sadržaj nekog medija i donose odluke o njemu",
            ),
          ],
        ),
        _buildParagraphRich(
          [
            const TextSpan(
              text: "Validno - ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(
              text: "valjano, vrijedno",
            ),
          ],
        ),
      ],
    ).padding(bottom: 16);
  }
}
