##########################################################################
#
#	Use Italian
#
##########################################################################


package lang;

# Errors #################################################################
our $read_file_error = "Impossibile aprire il file per la lettura";
our $write_file_error = "Impossibile aprire il file per la scrittura";
our $pic_too_big = "Il file è troppo grande! Ridimensionalo e torna a inviarlo.";
our $noblog = "Nessun post del blog è stato selezionato! Torna indietro e scegline uno per postare commenti.";
our $noemail = "Devi specificare un indirizzo email!";
our $noposts = "In questo blog non ci sono ancora post.";

# Words ##################################################################
our $oops = "Oops!";
our $search_blogs = "Cerca nel blog";
our $view_blogs = "Vedi il blog";
our $control = "Pannello di controllo";
our $subscribe = "Iscriviti a $svb::title";
our $subscribed = "Sei stato iscritto.";
our $unsubscribed = "Sei stato disiscritto.";
our $unsubscribe = "Disiscriviti da $svb::title";
our $howtounscr = "Puoi disiscriverti usando il link presente nelle mail di notificazione.";
our $title = "Titolo"; # noun
our $date = "Data";
our $page = "Pagina";
our $postto = "Posta a"; # followed by $svb::title
our $youposted = "Post nel blog avvenuto con successo!";
our $filesuploaded = "Hai caricato questi files per essere inclusi nel tuo post:";
our $text_document = "Documento di testo";
our $image = "File immagine";
our $unknown = "File sconosciuto";
our $archive = "Archivio";
our $movie = "Filmato";
our $code = "File di codice";
our $dbss = "Database o foglio di calcolo";
our $audio = "File audio";
our $attachedfile = "File allegato";
our $no_comments = "Nessun commento";
our $noattachedfiles = "Nessun file allegato";
our $Name = "Nome";
our $Email = "Email";
our $text = "Testo";
our $comments = "Commenti"; # noun
our $comment = "Commento"; # singular noun
our $postcomments = "Invia un commento";
our $readmore = "Leggi il resto...";
our $fulltext = "Testo e commenti";
our $total = "totale";
our $back = "Indietro"; # to go to front page
our $postingcomment = "Sto postando un commento";
our $nameorcomments = "Hai lasciato lo spazio del nome o del commento vuoto!";
our $noresults = "Nessun risultato per la tua ricerca.";
our $invalidemail = "Indirizzo e-mail non valido!";
our $processing = "Sto elaborando";
our $edit = "Modifica";
our $delete = "Cancella";


our $Submit = "Invia";
our $posted_on = "postato&nbsp;il&nbsp;"; # must have non-breaking spaces. this is followed by the date "posted on date" etc.

# Footer #################################################################
# needs translating!
our $powered_by = "Powered by"; # followed by $cmn::version
our $copyright = "Copyright 2003 FuzzyMonkey.org";
our $wizard = "Created by the scripting wizards at <a href=http://www.fuzzymonkey.org>FuzzyMonkey.org</a>.";

# Date and Time ##########################################################
our @months = (
	"Gennaio",
	"Febbraio",
	"Marzo",
	"Aprile",
	"Maggio",
	"Giugno",
	"Luglio",
	"Agosto",
	"Settembre",
	"Ottobre",
	"Novembre",
	"Dicembre"
);
