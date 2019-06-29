##########################################################################
#
#	Suomenkielinen - Finnish lang.pm for MyBlog 1.2.
#
##########################################################################


package lang;

# Errors #################################################################
our $read_file_error = "Tiedostoa ei voida lukea";
our $write_file_error = "Tiedostoon ei voida kirjoittaa";
our $pic_too_big = "Tiedostosi on liian iso!  Ole hyv‰, muokkaa sit‰ ja yrit‰ sitten uudelleen!";
our $noblog = "Et valinnut mihin blog- merkint‰‰n haluat j‰tt‰‰ kommentin! Ole hyv‰, palaa takaisin ja yrit‰ uudelleen.";
our $noemail = "You must specify an email address!";
our $noposts = "T‰m‰ blog ei viel‰ sis‰ll‰ kirjoituksia.";

# Words ##################################################################
our $oops = "Huppista!";
our $search_blogs = "Etsi";
our $view_blogs = "N‰yt‰ blogit";
our $control = "Ohjauspaneeli";
our $title = "Titteli"; # noun
our $date = "Pvm";
our $subscribe = "Tilaa ilmoitus uusista $svb::title:n uusista viesteist‰";
our $unsubscribe = "Poista $svb::title:n tilaus";
our $subscribed = "Sinut on merkitty tilauslistalle.";
our $unsubscribed = "Osoitteesi on poistettu tilauslistalta.";
our $howtounscr = "Voit poistaa tilauksesi k‰ytt‰m‰ll‰ uutiskirjeest‰ lˆytyv‰‰ linkki‰.";
our $page = "Sivu";
our $postto = "&nbsp;\|&nbsp;Lis‰t‰‰n merkint‰"; # followed by $svb::title
our $youposted = "Kirjoituksen tallennus onnistui!";
our $filesuploaded = "Latasit n‰m‰ tiedostot liitett‰v‰ksi kirjoitukseesi:";
our $text_document = "Tekstitiedosto";
our $image = "Kuva";
our $unknown = "Tuntematon tiedostomuoto";
our $archive = "Arkisto";
our $movie = "Elokuva";
our $code = "Ohjelmatiedosto";
our $dbss = "Taulukko";
our $audio = "Audiotiedosto";
our $attachedfile = "Liitetty tiedosto";
our $no_comments = "Ei viel‰ kommentteja";
our $noattachedfiles = "Ei liitettyj‰ tiedostoja.";
our $Name = "Nimi";
our $Email = "S-posti";
our $title = "Otsikko";
our $text = "Teksti";
our $comments = "kommentti(a)"; # noun
our $comment = "Kommentti"; # singular noun
our $postcomments = "Lis‰‰ kommentti"; # noun
our $readmore = "Lue lis‰‰";
our $fulltext = "Teksti ja kommentti kokonaisuudessaan";
our $total = "yhteens‰";
our $back = "Takaisin"; # to go to front page
our $postingcomment = "Lis‰t‰‰n kommentti";
our $nameorcomments = "J‰tit jonkun kentist‰ t‰ytt‰m‰tt‰! Ole hyv‰ ja palaa takaisin t‰ytt‰‰ksesi vaadittu/vaaditut kent‰t.";
our $noresults = "Etsint‰ ei tuottanut tulosta.";
our $invalidemail= "T‰m‰ s‰hkˆpostiosoite ei ole kelvollinen!";
our $processing = "K‰sitell‰‰n";
our $edit = "Muokkaa";
our $delete = "Poista";
# Footer #################################################################
our $powered_by = "Powered by"; # followed by $cmn::version
our $copyright = "Copyright 2004 FuzzyMonkey.org";
our $wizard = "Created by the scripting wizards at <a href=\"http://www.fuzzymonkey.org\" target=\"_blank\">FuzzyMonkey.org</a>.";

# Date and Time ##########################################################
our @months = (
	"Tammikuu",
	"Helmikuu",
	"Maaliskuu",
	"Huhtikuu",
	"Toukokuu",
	"Kes‰kuu",
	"Hein‰kuu",
	"Elokuu",
	"Syyskuu",
	"Lokakuu",
	"Marraskuu",
	"Joulukuu"
);
