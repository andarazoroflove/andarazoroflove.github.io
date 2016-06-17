#!/usr/bin/perl

use lib "./lib";
use CGI;
use strict;
use CGI::Carp qw(fatalsToBrowser);
use Entities;
use sitevariables;
use common;
use lang;



package dft;
our $cur = CGI::new();
our $mode = $cur->param('mode');
our $content;

#print "Content-type:text/html\n\n";

if ($mode eq $lang::Submit){
	$content .= post();
	$content .= viewone();
}else{
	$content .= viewone();
}

printpage_comments($content);

sub printpage_comments($){
	print "Content-type:text/html\n\n<html>
<head>
	<title>Blog Comments</title>
	<link rel=\"stylesheet\" href=\"$svb::cssfile\">
</head>
<body>
$_[0]
</body>";
	exit();
}



sub viewone{

	my ($return,$filetype,$temp,$printfiles,@lines);
	my $blog = $cur->param('blog');
	if (!$blog){
		cmn::dienice($lang::noblog);
	}
        $return .= "
<span class=header>$lang::comments</span><br><br>\n";
        my @comments;
        if(!(-e "./comments/$blog.txt")){
                $return .= "</center>
<span class=default>$lang::no_comments</span><br><br>

<center>";
        }else{
                open(INFILE,"./comments/$blog.txt")||cmn::dienice("$lang::read_file_error\: comments file for $blog\: $!!");
                @comments = <INFILE>;
                close INFILE;
                $return .= "<table width=100% cellspacing=0>\n";
                foreach(@comments){
                        my ($date,$a,$name,$email,$comments) = split(/###/,$_);
								my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($date);
								$year +=1900;
								$date = $mon+=1; $date .= "/$mday/$year";
                        if($email =~ /^[\w\-\.]+\@[\w\-\.]+\.[\w\-\.]+$/i){
                                $return .= "\t<tr>
                <td class=headercell>
                        <span class=default><b>$name</b> - </span>
                        <span class=smalltext><i>$lang::posted_on$date</i></span>
                </td>
			<td align=right class=headercell><a href=mailto:$email><img src=$svb::htmlpath/email.gif border=0></a></td>\n";
                        }else{
	                        $return .= "\t<tr>
                <td class=headercell colspan=2>
                        <span class=default><b>$name</b> - </span>
                        <span class=smalltext><i>$lang::posted_on$date</i></span>
                </td>\n";

			}
                        $return .= "
	</tr>
	<tr>
		<td colspan=3>
			<span class=default>$comments</span>
			<br>
			<br>
		</td>
	</tr>";
                } # foreach comments
                $return .= "</table>";
        } # if the comments file exists

	$return .= "\n<center>
<table width=100%>
	<tr>
		<td width=70%>
			<span class=header>$lang::postcomments</span><span class=default> - $lang::usebbcode</span>
			<table><tr><td class=vertdiv></td></tr></table>
		</td>
	</tr>
	<tr>
		<td>
			<form method=post>
				<table>
					<tr>
						<td><span class=default>$lang::Name\:</span>
						</td>
						<td><input type=text name=name>
						</td>
						<td><span class=default>$lang::Email (optional):</span>
						</td>
						<td><input type=text name=email>
						</td>
					</tr>
					<tr>
						<td colspan=4 valign=top><span class=default>$lang::comments\:</span><br>
						<textarea rows=3 cols=55 name=comments></textarea><br>
						<input type=submit name=mode value='$lang::Submit'>
						<input type=hidden name=blog value=$blog>
						</td>
					</tr>

				<table>
			</form>
		</td>
	</tr></table>";

	return $return;


} # sub viewone


sub post{

	my $comments = $cur->param('comments');
	my $name = $cur->param('name');
	my $email = $cur->param('email');
	my $blog = $cur->param('blog');
	if($blog =~ /\D/){cmn::dienice("Were you trying to hack the script?");}
	my $date = time();

	# check for malicious code
	foreach($comments,$name){
		$_ = HTML::Entities::encode($_);
	}

	if (!$name or !$comments){
		cmn::dienice("$lang::nameorcomments");
	}
	if($comments =~ /\S{30,30}/){
		cmn::dienice("$lang::longwords");
	}
	unless($name =~ /.{1,30}/){
		cmn::dienice("$lang::longname");
	}
	unless($comments =~ /.{1,1000}/){
		cmn::dienice("$lang::longcomments");
	}
        if ($email !~ /^[\w\-\.]+\@[\w\-\.]+\.[\w\-\.]+$/i && $email){
		cmn::dienice("$lang::invalidemail");
	}
	$comments =~ s/\n/<br>/ig;
	
	open(OUTFILE,">>./comments/$blog.txt")||cmn::dienice("$lang::write_file_error\: $!!");
	print OUTFILE "$date###$blog###$name###$email###$comments\n";
	close OUTFILE;

	cmn::email("Blog comment", $svb::webmaster, $email, $comments);
	
	return "";
}

