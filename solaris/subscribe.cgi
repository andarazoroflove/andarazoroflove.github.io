#!/usr/bin/perl

use lib "./lib";
use CGI;
use strict;
use CGI::Carp qw(fatalsToBrowser);
use sitevariables;
use common;
use lang;

package dft;
our $cur = CGI::new();



our $mode = $cur->param('mode');
our $email = $cur->param('email');
our $content;



if ($mode eq $lang::subscribe){
	$content .= add_subscription();
}elsif($mode eq $lang::unsubscribe){
	if(!$email){
		cmn::dienice("$lang::invalidemail  <a href=subscribe.cgi?mode=u>$lang::unsubscribe.</a>");
	}
	$content .= remove_subscription();
}elsif($mode eq "u"){
	$content .= remove_form();
}else{
	$content .= form();
}




print "Content-type:text/html\n\n" . cmn::printpage($svb::templatefile,$content);


sub form{

	my $return .= "\n<center>
<table width=100%>
	<tr>
		<td align=center>
			<center>
			<span class=header>$lang::subscribe</span><br><br>
			</center>
		</td>
	</tr>
	<tr>
		<td align=center>
			<form>
			<span class=default>$lang::Email:</span> <input type=text name=email>
		</td>
	</tr>
	<tr>
		<td align=center><br>
			<input type=submit name=mode value='$lang::subscribe'><br><br>
			<span class=default>$lang::howtounscr</span>
		</td>
	</tr>
</table></center>";
	return $return;
	
}

sub remove_form{

	my $return .= "\n<center>
<table width=100%>
	<tr>
		<td align=center>
			<center>
			<span class=header>$lang::unsubscribe</span><br><br>
			</center>
		</td>
	</tr>
	<tr>
		<td align=center>
			<form>
			<span class=default>$lang::Email:</span> <input type=text name=email>
		</td>
	</tr>
	<tr>
		<td align=center><br>
			<input type=submit name=mode value='$lang::unsubscribe'><br><br>
			<span class=default>$lang::howtounscr</span>
		</td>
	</tr>
</table></center>";
	return $return;
	
}



sub add_subscription{
	if(!$email){cmn::dienice($lang::noemail);}
	my $return .= "<html>
<head>
<title>$svb::title</title>
<META HTTP-EQUIV=\"Refresh\" CONTENT=\"1; URL=index.cgi\">
<link rel=\"stylesheet\" href=\"$svb::cssfile\">
</head>
<body><br><br><center><span class=default>$lang::subscribed</span></center>
</body>
</html>
";
	open(OUT,">>subscriptions.blog")||cmn::dienice("$lang::write_file_error - subscriptions.blog\: $!!");
;
	print OUT "$email\n";
	close OUT;
	return $return;

}


sub remove_subscription{
	my @emails;
	my $return .= "<html>
<head>
<title>$svb::title</title>
<META HTTP-EQUIV=\"Refresh\" CONTENT=\"1; URL=index.cgi\">
</head>
<body><br><br><center><span class=default>$lang::unsubscribed</span></center>
</body>
</html>
";
	open(IN,"subscriptions.blog")||cmn::dienice("$lang::read_file_error - subscriptions.blog\: $!!");
	while(<IN>){
		chomp;
		push(@emails,$_);
	}
;
	close IN;

	open(OUT,">subscriptions.blog")||cmn::dienice("$lang::write_file_error - subscriptions.blog\: $!!");
;
	foreach(@emails){
		unless($_ eq $email){
			print OUT "$_\n";
		}
	}
	close OUT;

	return $return;

}

