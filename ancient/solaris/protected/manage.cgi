#!/usr/bin/perl

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use strict;
use lib "../lib/";
use Entities;
use sitevariables;
use common;
use lang;

our $q = CGI->new();
our $mode = $q->param('mode');
our $content;
package dft;

print "Content-type:text/html\n\n";

if($mode eq "config"){
	$content .= config();
}elsif($mode eq "edit"){
	$content .= edit();
}elsif($mode eq "Save"){
	$content .= save();
}elsif($mode eq "editblog"){
	$content .= editblog();
}elsif($mode eq "post"){
	post();
	$content .= edit();
}elsif($mode eq "deleteblog"){
	deleteblog();
	$content .= edit();
}else{
	$content .= edit();
}
$content = "<table width=100% class=outside>
	<tr>
		<td valign=top width=200>\n" . cmn::menu() . "\t\t</td>
		<td class=vertdiv>&nbsp;
		</td>
		<td>
$content
		</td>
	</tr>
<table>";
print cmn::printpage("../$svb::templatefile",$content);

sub post{
	my $date = $q->param('date');
	my $title = $q->param('title');
	my $text = $q->param('text');
	$text =~ s/\n/<br>/ig;
	my $file = $q->param('file1');
	my ($count,$buffer,$count1);
	
	open(INFILE,"../entries.blog")||cmn::dienice("$lang::read_file_error\:  ../entries.blog.");
	my @file = <INFILE>;
	close INFILE;


	if($file){
		my $ext = $file;
		$ext =~ s/.*\.(.*)$/$1/ig;
		if($ext =~ /exe/i){
			$ext = ".executable";
		}
		open (OUTFILE,">$svb::htmlsystempath/$date-0.$ext")
			||cmn::dienice("$lang::write_file_error $svb::htmlsystempath/$date-$count1.$ext\: $!!");
		while(my $bytesread = read($file,$buffer,1024)){
			print OUTFILE $buffer;
			$count++;
			if ($count > $svb::maxpicsize){
				unlink "$svb::htmlsystempath/$date-$count1.$ext";
				cmn::dienice("$lang::pic_too_big");
			}
		}
		if($svb::use_imagemagick =~ /yes/i){
			require "../lib/imagemagick.pm";
			IMG::resize("$svb::htmlsystempath/$date-0.$ext","$svb::htmlsystempath/big/$date-0.$ext",$svb::full_width,95);
			IMG::resize("$svb::htmlsystempath/$date-0.$ext","$svb::htmlsystempath/$date-0.$ext",$svb::preview_width,95);
		}
		close OUTFILE;
	}
	open(OUTFILE,">../entries.blog")||cmn::dienice("$lang::write_file_error\:  ../entries.blog.");
	foreach(@file){
		chomp;
		my ($a,$b,$c) = split(/###/,$_);
		if($a ne $date){
			print OUTFILE "$a###$b###$c\n";
		}else{
			print OUTFILE "$date###$title###$text\n";
		}
	}
	close OUTFILE;
	cmn::write_rss();
}

sub editblog{
	my $blog = $q->param('blog');
	my($a,$b,$c,$date,$title,$text);
	open(INFILE,"../entries.blog")||cmn::dienice("$lang::read_file_error\:  ../entries.blog.");
	while(<INFILE>){
		chomp;
		my ($a,$b,$c) = split(/###/,$_);
		if($a eq $blog){
			($date,$title,$text) = ($a,$b,$c);
		}
	}
	close INFILE;
	$text =~ s/<br>/\n/ig;

	my $return .= "
				<table width=100%>
					<tr>
						<td colspan=2 class=headercell>
	<span class=default><b>Editing</b></span>
	<form method=post enctype='multipart/form-data'>
						</td>
					</tr>
					<tr>
						<td width=40% align=right>
							<span class=default>Title:&nbsp;&nbsp;&nbsp;</span>

						</td>
						<td>
							<input type=text name='title' value='$title'><br>
						</td>
					</tr>
					<tr>
						<td align=right>
							<span class=default>Picture:&nbsp;&nbsp;&nbsp;</span>

						</td>
						<td>
							<input type=file name=file1>
							<span class=smalltext>Uploading a new picture will overwrite your old picture.</span><br>
						</td>
					</tr>					<tr>
						<td valign=top align=right>
							<span class=default>Text:&nbsp;&nbsp;&nbsp;</span>

						</td>
						<td>
							<textarea name='text' rows=20 cols=60>$text</textarea>
						</td>
					</tr>
					<tr>
						<td>
						</td>
						<td>

							<input type=hidden name=mode value=post>
							<input type=hidden name=date value=$date>
							<input type=submit value='&nbsp;&nbsp;&nbsp;Post&nbsp;&nbsp;&nbsp;'>
						</td>
					</tr>
				</table>
			</form>";

	return $return;
	cmn::write_rss();
}

sub deleteblog{

	my $blog = $q->param('blog');
	open(INFILE,"../entries.blog")||cmn::dienice("$lang::read_file_error\:  ../entries.blog.");
	my @file = <INFILE>;
	close INFILE;

	open(OUTFILE,">../entries.blog")||cmn::dienice("$lang::write_file_error\:  ../entries.blog.");
	foreach(@file){
		chomp;
		my ($a,$b,$c) = split(/###/,$_);
		if($a ne $blog){
			print OUTFILE "$a###$b###$c\n";
		}
	}
	close OUTFILE;
	cmn::write_rss();
}


sub edit{
	my (@results,$line,@lines,$count);
	my $return;


	open (INFILE, "../entries.blog")||cmn::dienice("$lang::read_file_error\:  ../entries.blog.");
	while (<INFILE>){
		push (@lines,$_);
	}
	close INFILE;
	@lines = reverse @lines;

	$return .= "
<table width=100%>
	<tr>
		<td colspan=2>
			<table width=100% cellpadding=2 cellspacing=0>
				<tr>
					<td class=headercell width=20%><span class=default><b>$lang::date</b></span></td>
					<td class=headercell><span class=default><b>$lang::title</b></span></td>
					<td class=headercell align=center><span class=default><b>Function</b></span></td>
				</tr>";

	my $c=0;
	foreach (@lines){
		$c++;
		my ($date,$title,$text) = split(/###/,$_);
		my $pdate = cmn::mydate($date + (60*60*$svb::timetoadd));
		$pdate =~ s/ /&nbsp;/ig;
		$return .= "
							<tr>
								<td class=\"alt$count\"><span class=default>$pdate</span></td>
								<td class=\"alt$count\"><span class=default><a href=../index.cgi?mode=viewone&blog=$date>$title</a></span></td>
								<td class=\"alt$count\" align=center><span class=default><a href=manage.cgi?mode=editblog&blog=$date>Edit</a> or <a href=manage.cgi?mode=deleteblog&blog=$date>Delete</a></span></td>
							</tr>\n";
		$count++;
		if($count == 2){
			$count = 0;
 		}
	}
	if(!$c){
		$return .= "<tr><td colspan=3 class=\"alt$count\"><span class=default>$lang::noresults</span></td></tr>";
	}
	$return .= "
						</table>
		</td>
	</tr>
</table>
</center>";

	
	return $return;
}

sub config{
	my $return;
	$return = "
<form action=manage.cgi>
	<table>
	<tr><td class=headercell colspan=2><span class=default><b>Program Configuration</b></span></td></tr>
	<tr><td width=200><span class=default>Title:</span></td><td><input type=text name=title size=60 value=\"$svb::title\"></td></tr>
	<tr><td><span class=default>Template File:</span></td><td><input type=text name=templatefile value=\"$svb::templatefile\"></td></tr>
	<tr><td><span class=default>Post Template File:</span></td><td><input type=text name=post_template value=\"$svb::post_template\"></td></tr>
	<tr><td><span class=default>HTML Path to Blog folder:</span></td><td><input type=text size=60 name=htmlpath value=\"$svb::htmlpath\"></td></tr>
	<tr><td><span class=default>System Path to Blog folder:</span></td><td><input type=text size=60 name=htmlsystempath value=\"$svb::htmlsystempath\"></td></tr>
	<tr><td><span class=default>HTML Path to index.cgi:</span></td><td><input type=text size=60 name=scriptpath value=\"$svb::scriptpath\"></td></tr>
	<tr><td><span class=default>Maximum Text before Truncating Front Page Display:</span></td><td><input type=text name=textmax value=\"$svb::textmax\"></td></tr>
	<tr><td><span class=default>Maximum Number of Blogs per Page:</span></td><td><input type=text name=page value=\"$svb::page\"></td></tr>
	<tr><td><span class=default>Number of hours to add to the system time:</span></td><td><input type=text size=60 name=timetoadd value=\"$svb::timetoadd\"></td></tr>
	<tr><td><span class=default>URL of CSS file:</span></td><td><input type=text size=60 name=cssfile value=\"$svb::cssfile\"></td></tr>
	<tr><td class=headercell colspan=2><span class=default><b>Email Configuration</b></span></td></tr>
	<tr><td><span class=default>Allow visitors to subscribe to post notifications:</span></td><td><input type=text name=subscriptions value=\"$svb::subscriptions\"></td></tr>
	<tr><td><span class=default>Webmaster's Email:</span></td><td><input type=text name=webmaster value=\"$svb::webmaster\"></td></tr>
	<tr><td><span class=default>Path and Arguments to Sendmail:</span></td><td><input type=text name=sendmail value=\"$svb::sendmail\"></td></tr>
	<tr><td class=headercell colspan=2><span class=default><b>Pictures Configuration</b></span></td></tr>
	<tr><td><span class=default>Maximum Picture Size in KB:</span></td><td><input type=text name=maxpicsize value=\"$svb::maxpicsize\"></td></tr>
	<tr><td><span class=default>Full Sized Picture Width:</span></td><td><input type=text name=full_width value=\"$svb::full_width\"></td></tr>
	<tr><td><span class=default>Align Picture Right, Left or Center:</span></td><td><input type=text name=picalign value=\"$svb::picalign\"></td></tr>
	<tr><td><span class=default>Thumbnail Picture Width:</span></td><td><input type=text name=preview_width value=\"$svb::preview_width\"></td></tr>
	<tr><td><span class=default>Use ImageMagick to Resize Pictures:</span></td><td><input type=text name=use_imagemagick value=\"$svb::use_imagemagick\"></td></tr>
	<tr><td class=headercell colspan=2><span class=default><b>RSS Configuration</b></span></td></tr>
	<tr><td><span class=default>Language for RSS Feed:</span></td><td><input type=text name=rsslang value=\"$svb::rsslang\"></td></tr>
	<tr><td><span class=default>Main Site Link for RSS Feed:</span></td><td><input type=text name=rsslink size=60 value=\"$svb::rsslink\"></td></tr>
	<tr><td><span class=default>Description for RSS Feed:</span></td><td><input type=text size=60 name=rssdescription value=\"$svb::rssdescription\"></td></tr>
	<tr><td><span class=default>Copyright Notice for RSS Feed:</span></td><td><input type=text name=rssrights size=60 value=\"$svb::rssrights\"></td></tr>
	<tr><td><span class=default>Max Characters of Entry to Display in RSS Feed:</span></td><td><input type=text name=rsstextmax value=\"$svb::rsstextmax\"></td></tr>
	<tr><td><span class=default>Max Number of Entries to Display in RSS Feed:</span></td><td><input type=text name=rssmaxentries value=\"$svb::rssmaxentries\"></td></tr>
	<tr><td colspan=2 align=center><input type=submit name=mode value=Save></td></tr></table>";
	return $return;

}

sub save{

	my ($return,$file);

	$return .= "<center><span class=header>$svb::title Administration</span></b><br><br>
	<span class=default>Configuration Saved!<br><Br>
	<a href=manage.cgi>Back</a></span></center>
	<textarea cols=100 rows=40>";
	$file = "package svb;
	
";	
	my $temp;
	foreach($q->param()){
		unless($_ eq "mode"){
			$temp = $q->param($_);
			$temp =~ s/'/&apos;/ig;
			$file .= "our \$$_ = '".$temp."';\n";	
		}
	}


	$file .= "\nreturn 1;";


	open(OUT, ">../lib/sitevariables.pm") || diehard("Could not open sitevariables.pm! $!!");
	print OUT "$file";
	close OUT;

	$return .= "$file
</textarea>
</body>
</html>";

	return $return;
}

sub diehard{
	print "$_[0]";
	exit(3);
}


