import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/footer_logos.dart';
import 'package:styled_widget/styled_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBarWithBackButton(
        context,
        "Za nastavnike/ce",
        color: AppColors.selectAboutBackground,
        logo: Image.asset('assets/images/icon-info.png'),
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
                      const AboutText(),
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

class AboutText extends StatelessWidget {
  const AboutText({super.key});

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(number)
            .textStyle(AppTextStyles.aboutParagraph)
            .fontWeight(bold ? FontWeight.w600 : FontWeight.w400)
            .padding(vertical: 2, horizontal: 6)
            .backgroundColor(AppColors.selectInfoBackground)
            .clipOval()
            .padding(right: 8),
        Expanded(
          child: Text(text).textStyle(AppTextStyles.aboutParagraph).fontWeight(bold ? FontWeight.w600 : FontWeight.w400).padding(top: 2, bottom: 12),
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
        const Text('TODO PDF GUMB'),
        _buildHeading("Modul 1"),
        _buildListItem(
          "1.",
          "Koristeći ovaj link sa Raskrinkavanje.ba saznajte više o pojmu medijske pismenosti:",
          bold: true,
        ),
        _buildParagraph(
          "https://medijskapismenost.raskrinkavanje.ba/saznajte-vise/sta-je-medijska-pismenost/",
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
        _buildParagraph(
          "https://medijskapismenost.raskrinkavanje.ba/kviz/",
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
        _buildParagraph(
          "TODO: Table 1 - Prijedlog vježbe za aktivnost šest šešira.png",
          background: true,
        ),
        _buildListItem(
          "3.",
          "Prijedlog vježbe za aktivnost šest šešira: Mladi provode mnogo vremena gledajući videa na YouTube-u",
        ),
        _buildHeading("Modul 7"),
        _buildListItem(
          "1.",
          "Debata je organizovan način izmjene mišljenja, odnosno dijaloška komunikacija koja se temelji na procesu argumentacije. U debati "
              "uglavnom nastupaju dvije strane, koje imaju jednake mogućnosti predstaviti svoje argumente sa ciljem da druge uvjere u svoje stanovište, "
              "odnosno da svoje mišljenje učine racionalno prihvatljivim za sagovornike.",
        ),
        _buildListItem(
          "2.",
          "U razredu sa učenicima možete povesti razgovor o nekoj od vijesti sa Raskrinkavanje.ba kao što je ova: Snimak “tornada” u Srbiji star je "
              "nekoliko godina",
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
        _buildParagraph(
          "TODO: Table 2 - tabela kriterija.png",
          background: true,
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
