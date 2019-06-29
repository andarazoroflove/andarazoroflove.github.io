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

print "Content-type:text/html\n\n";

print cmn::printpage($svb::templatefile,results());

sub results{
	my (@results,$line,$return,@lines);
	my $count = 0;
	my @searchthings = split(/ /,$cur->param('searchfor'));
	
	open (INFILE, "./entries.blog")||cmn::dienice("$lang::read_file_error\:  ./entries.blog.");
	while (<INFILE>){
		push (@lines,$_);
	}
	close INFILE;

	foreach $line (@lines){
		foreach (@searchthings){
			if ($line !~ /$_/ig){
				$line = "";
			}
		}
	}
	$return .= "<center>
<table width=98%>
	<tr>
		<td>
			<center><span class=header>$lang::search $svb::title</span></center><br><br>
		</td>
		<td align=right>
			<form method=get action=search.cgi>
			<input type=text name=searchfor>
			<input type=submit value=Search>
			</form>
		</td>
	</tr>
	<tr>
		<td colspan=2>
			<table width=100% cellpadding=2 cellspacing=0>
				<tr>
					<td class=headercell><span class=default><b>$lang::title</b></span></td>
					<td width=20% class=headercell><span class=default><b>$lang::date</b></span>
					</td>
				</tr>";

	my $c=0;
	foreach (@lines){
		if($_){
			$c++;
			my ($date,$title,$text) = split(/###/,$_);
			my $pdate = cmn::mydate($date + (60*60*$svb::timetoadd));
			$pdate =~ s/ /&nbsp;/ig;
			$return .= "
				<tr>
					<td class=\"alt$count\"><a href=index.cgi?mode=viewone&blog=$date><span class=default>$title</span></a></td>
					<td class=\"alt$count\"><span class=default>$pdate</span></td>
				</tr>\n";
			$count++;
			if($count == 2){
				$count = 0;
 			}
		}
	}
	if(!$c){
		$return .= "<tr><td colspan=2 class=\"alt$count\"><span class=default>$lang::noresults</span></td></tr>";
	}
	$return .= "
			</table>
		</td>
	</tr>
</table>
</center>";

	return $return;
	
}
