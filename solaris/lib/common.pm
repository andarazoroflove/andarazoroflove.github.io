##########################################################################
#
#	TITLE: common.pm
#	
#	FUNCTION: Include file housing subroutines common to many
#	aspects of My Classifieds SQL, many of which function as
#	asthetic/format-specific blocks of code.
#	
#	DATE: last edited 12.07.2003
#	
#	AUTHOR: Erin Spice
#	
#	PACKAGE: My Weblog
#
#	DETAILS: This include file contains dienice, 
#	mydate, and $fuzzymonkey.
#
#########################################################################

use lib "./lib";
use sitevariables;
use lang;

package cmn;


our $version = "My Blog 1.51";

### DIENICE ##############################################################
#
#	TITLE: dienice
#
#	INPUT: $msg - error message to be printed.
#	
#	FUNCTION: Formats $msg, prints to browser, and dies.
#	
#	OUTPUT: HTML for the page.
#	
#	FUNCTIONS CALLED: 	none
#
#	CALLED BY:		too many to name
#
##########################################################################
sub dienice {
	my $content .= "Content-type:text/html\n\n
<html>
<head>
<link rel=stylesheet href=$svb::cssfile>
</head>
<body>
<center>
<table width=100%>
	<tr>
		<td align=center class=headercell>
		<span class=header>$lang::oops!</span>
		</td>
	</tr>
	<tr>
		<td align=center><span class=default>$_[0]</span>
		</td>
	</tr>
</table>
</center>
</body>
</html>";
	print $content;
	exit(3);
}




########################################################################################
##  Sends an email using  variables $subject, $to, $from, $body in @_                 ##
########################################################################################
sub email ($$$$)
{
    my ($subject, $to, $from, $body) = @_;
                                                                                                                             
    open (MAIL, "| $svb::sendmail" ) || cmn::dienice("could not open mail");
    print MAIL <<MAIL_MESSAGE;
Subject:$subject
To:$to
Reply-to:$from
From:$from

$body
MAIL_MESSAGE
     close MAIL;
}





### MYDATE ###############################################################
#
#	TITLE: mydate
#
#	INPUT: output of time() or previously saved time() data.
#	
#	FUNCTION: Prints the date formatted nicely.
#	
#	OUTPUT: One line of text including date.
#	
#	FUNCTIONS CALLED: 		none
#
#	CALLED BY:			deletead
#					dodelete
#					edit
#					viewcategory
#					viewsinglead
#					searchresults
#
##########################################################################
sub mydate{
	my $datenum = $_[0] + (60*60*2);
	my ($sec,$min,$hour,$day,$mon,$year,$weekday,$yearday,$dst) = localtime($datenum);
	my $ampm = "am";
	$year = 1900 + $year;
	if ($hour > 12){
		$hour = $hour - 12;
		$ampm = "pm";
	}
	$min = sprintf("%02d",$min);
	$hour = sprintf("%02d",$hour);
	$sec = sprintf("%02d",$sec);
	return "$day $lang::months[$mon], $year, $hour\:$min $ampm";
}


# this is the fuzzymonkey signature at the bottom of every page ##########
our $fuzzymonkey = "\n\n\n
<br>
<table align=center width=98% cellpadding=2 cellspacing=0>
	<tr>
		<td align=center class=headercell>
		<span class=default>$lang::powered_by $version. $lang::copyright.<br>
$lang::wizard</span>
		</td>
	</tr>
</table>";



sub printpage {
        my ($file,$content) = @_;
        $content .= $fuzzymonkey;
	my $baby;
	if(-e "baby.pl"){
		$baby = `./baby.pl`;
	}
	my $calendar;
	if(-e "calendar.pl"){
		$calendar = `./calendar.pl`;
	}
	my $photo;
	if(-e "photo.pl"){
		$photo = `./photo.pl`;
	}
        my $page;
        open (TEMPLATE, "./$file")
                        || dienice("$lang::read_file_error ./$svb::templatefile\: $!");
        while (<TEMPLATE>){
                $page .= $_;
        }
        close TEMPLATE;
        $page =~ s/<!-- ?content ?-->/$content/ig;
        $page =~ s/<!-- ?baby ?-->/$baby/ig;
        $page =~ s/<!-- ?calendar ?-->/$calendar/ig;
        $page =~ s/<!-- ?photo ?-->/$photo/ig;
        $page =~ s/<head>/<head>\n<link rel=\"stylesheet\" href=\"$svb::cssfile\">\n/ig;
        return $page;
}


sub menu{ 
        my $return .= "<center><span class=default><b>$svb::title Administration</b></span<br>         <span class=default><a href=manage.cgi?mode=edit>Manage&nbsp;Blogs</a></span><br>
        <span class=default><a href=manage.cgi?mode=config>Edit&nbsp;Configuration</a></span><br>         <span class=default><a href=post.cgi>Post&nbsp;a&nbsp;Blog</a></span><br>
        </center><br><br>\n"; 
        return $return;
} 


sub write_rss{	

	my($rss);
	open (INFILE, "../entries.blog")||cmn::dienice("Can't read file - ../entries.blog\: $!!");
	my @lines = <INFILE>;
	close INFILE;
	
	@lines = reverse @lines;
	
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	foreach($sec,$min,$hour,$mday){
		$_ = sprintf("%02d",$_);
	}
	my $timestr = $year+1900;
	$timestr .= "-";
	$timestr .= sprintf("%02d",$mon+1);
	$timestr .= "-$mday";
	$timestr .= "T$hour\:$min\:$sec";
	$timestr .= "+";
	$timestr .= sprintf("%02d",6-$isdst);
	$timestr .= ":00";
	open(OUT,">$svb::htmlsystempath/index.rss")||cmn::dienice("Can't write to $svb::htmlsystempath/index.rss: $!!");

	print OUT "<?xml version=\"1.0\"?>
	<rss version=\"0.91\">
		<channel>
			<title>$svb::title</title>
			<link>$svb::rsslink</link>
			<description>$svb::rssdescription</description>
			<language>$svb::rsslang</language>
			<copyright>$svb::rssrights</copyright>\n";
	foreach(@lines){
		chomp;
		$_ =~ s/<br>/ /ig;
		$_ =~ s/<.*?>//ig;
		our ($date,$title,$text) = split(/###/,$_);
		$title = HTML::Entities::encode($title);
		$title =~ s/[^\w\s]//ig;
		$text = HTML::Entities::encode($text);
		$rss .= "\t<item>
		<title>$title</title>
		<link>$svb::rsslink" . "?mode=viewone&amp;blog=$date</link>\n";

		if(length($text) > $svb::rsstextmax && $svb::rsstextmax > 0){
			$text = substr($text,0,$svb::textmax);
			$text =~ s/\b\w+$/\.\.\./ig;
		}
		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($date);
		foreach($sec,$min,$hour,$mday){
		        $_ = sprintf("%02d",$_);
		}
		$timestr = $year+1900;
		$timestr .= "-";
		$timestr .= sprintf("%02d",$mon+1);
		$timestr .= "-$mday";
		$timestr .= "T$hour\:$min\:$sec";
		$timestr .= "+";
		$timestr .= sprintf("%02d",6-$isdst);
		$timestr .= ":00";

		$rss .= "\t\t<description>$text</description>
	</item>\n";
	}

	print OUT "$rss
	</channel>
</rss>
\n";
} # sub write_rss{

return 1;
