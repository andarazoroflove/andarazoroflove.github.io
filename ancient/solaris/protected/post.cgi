#!/usr/bin/perl

use lib "../lib";
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use HTML::Entities;
use strict;
use sitevariables;
use common;
use lang;

our $cur = CGI::new();

print "Content-type:text/html\n\n";

our $mode = $cur->param('mode');
our $content;


if($mode eq "post"){
	$content .= post();
}else{
	$content .= form();
}

$content = "<table>
	<tr>
		<td valign=top width=200>\n" . cmn::menu() . "\t\t</td>
		<td class=vertdiv>&nbsp;
		</td>
		<td>
$content
		</td>
	</tr>
</table>";
print cmn::printpage("../$svb::templatefile",$content);

sub form{
	my $return;

	$return .= "
<table width=100%>
	<tr>
		<td colspan=2 class=headercell>
		<span class=default><b>$lang::postto $svb::title</b></span>";
	
	$return .= "
		</td>
	</tr>
	<tr>
		<td>
		</td>
		<td valign=top>
			<form method=post enctype='multipart/form-data'>
				<table>
					<tr>
						<td width=40% align=right>
							<span class=default>Title:&nbsp;&nbsp;&nbsp;</span>
						</td>
						<td>
							<input type=text name=\"title\"><br>
						</td>
					</tr>
					<tr>
						<td align=right>
							<span class=default>Picture:&nbsp;&nbsp;&nbsp;</span>
						</td>
						<td>
							<input type=file name=file1><br>
						</td>
					</tr>
					<!--
					<tr>
						<td align=right>
							<span class=default>File 2:&nbsp;&nbsp;&nbsp;</span>
						</td>
						<td>
							<input type=file name=file2><br>
						</td>
					</tr>
					<tr>
						<td align=right>
							<span class=default>File 3:&nbsp;&nbsp;&nbsp;</span>
						</td>
						<td>
							<input type=file name=file3><br>
						</td>
					</tr>
					-->
					<tr>
						<td valign=top align=right>
							<span class=default>Text:&nbsp;&nbsp;&nbsp;</span>
						</td>
						<td>
							<textarea name=\"text\" rows=20 cols=60></textarea>
						</td>
					</tr>
					<tr>
						<td>
						</td>
						<td>
							<input type=hidden name=mode value=post>
							<input type=submit value='&nbsp;&nbsp;&nbsp;Post&nbsp;&nbsp;&nbsp;'>
						</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>
</center>";
	
	return $return;
}

sub post{
	my ($buffer,$return,$ext);
	my ($title,$file1,$file2,$file3,$text);
	$title = $cur->param('title');
	$file1 = $cur->param('file1');
	$file2 = $cur->param('file2');
	$file3 = $cur->param('file3');
	$text = $cur->param('text');


	my $date = time();
	my $count = 0;
	my $count1 = 0;
	if($svb::use_imagemagick =~ /yes/i){
		require "../lib/imagemagick.pm";
	}

	if($file1){
		foreach($file1){
			$ext = $_;
			$ext =~ s/.*\.(.*)$/$1/ig;
			if($ext =~ /exe/i){
				$ext = ".executable";
			}
			open (OUTFILE,">$svb::htmlsystempath/$date-$count1.$ext")
         	||cmn::dienice("$lang::write_file_error $svb::htmlsystempath/$date-$count1.$ext\: $!!");
         		while(my $bytesread = read($_,$buffer,1024)){
            			print OUTFILE $buffer;
            			$count++;
            			if ($count > $svb::maxpicsize){
               				unlink "$svb::htmlsystempath/$date-$count1.$ext";
               				cmn::dienice("$lang::pic_too_big");
            			}
         		}
      			close OUTFILE;
			if($svb::use_imagemagick =~ /yes/i){
				IMG::resize("$svb::htmlsystempath/$date-$count1.$ext","$svb::htmlsystempath/big/$date-$count1.$ext",$svb::full_width,95);
				IMG::resize("$svb::htmlsystempath/$date-$count1.$ext","$svb::htmlsystempath/$date-$count1.$ext",$svb::preview_width,95);
			}
			$count1++;
 		}
	}
	
	$text =~ s/\n/<br>/ig;
	
	open (OUTFILE,">>../entries.blog")||cmn::dienice("$lang::write_file_error - ../entries.blog\: $!!");
	print OUTFILE "$date###$title###$text\n";
	close OUTFILE;

	my @emails;
	open(INF,"../subscriptions.blog")||cmn::dienice("$lang::read_file_error\: $!!");
	while(<INF>){
		chomp;
		push(@emails,$_);
	}
	close INF;

	my $email;
	
	foreach $email (@emails){
		my $scriptpath = $svb::scriptpath;
		my $email_body = "You are signed up to receive notifications of new entries posted to $svb::title.  This email is to inform you that a new entry is ready for viewing!  Please click the following link to visit $svb::title.\n\n";

		$scriptpath .= "\/index.cgi";

		$email_body .= "$scriptpath

If you wish to unsubscribe from notifications to this blog, please click the following link.\n\n";
		$scriptpath =~ s/index\.cgi//i;
		$scriptpath .= "subscribe.cgi?mode=$lang::unsubscribe&email=$email";
		$scriptpath =~ s/ /%20/ig;
		$email_body .= $scriptpath;
		cmn::email("New Post to $svb::title!", $email, $svb::webmaster, $email_body);
	}

	cmn::write_rss();
	$return .= "<center>
<table width=100%>
	<tr>
		<td colspan=2>
			<center><span class=header>$lang::postto $svb::title</b></span></center>";
	
	$return .= "
		</td>
	</tr>
	<tr>
		<td>
			<center><span class=default>$lang::youposted<br>
			<a href=../index.cgi>$svb::title</a></center>
			<blockquote>
			Date: ";
	$return .= cmn::mydate($date);
	$return .= "<br>
			Title: $title<br><br>
			$text<br><br><br><br>
			<b>$lang::filesuploaded</b>
				<blockquote>
				$file1<br>
				$file2<br>
				$file3</span>
				</blockquote>
			</blockquote>
		</td>
	</tr>
</table>
</center>";


}


