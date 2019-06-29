#!/usr/bin/perl

####################################################################
#
#This software is released under the GPL.  Please
#see the included LICENSE file.
#
#Copyright (C) 2001  Michael Spiceland
#
#This program is free software; you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#Use this script at your own risk!  I make no 
#warranties that it is hack proof!
#
#
# This script is part of the Fuzzymonkey Perl Script Archive at
# www.fuzzymonkey.org/perl/
#
####################################################################

use CGI qw(:standard);
####################################################################
# Configuration 
####################################################################
$calendar_link = "http://www.spiceland.org/cgi-bin/calendar/index.cgi";
$calendar_path = "/home/knoxshop/www/cgi-bin/calendar";

####################################################################
# Colors
####################################################################
#Weekday Header background colors- the color that goes on Sunday, Monday, etc
$weekdaybg     = '#c9dfea';
#weekday font color-
$weekdayfont      = '#cccccc';
#day background color- the color of the calendar
$daybg         = '#C9dfea';
#today's color
$todaybg    = '#eae2ff';
#bgcolor if there is an event
$busydaybg     = '#deecf2';
#blank days (the padding) has a different background
$blankday      = '#c9dfea';
#day font- the font of the date numbers, and the events
$dayfont    = '#000000';
#edit page colors
$edittitlebg      = '#0D33A5';
$edittitlefont    = '#FFFFFF';
$editborder    = '#FCFCFC'; #note, these are most likely not what you think they are, try em
$editbg        = '#FFFFFF';
$editfont      = '#000000';

############ BEGIN MAIN PROGRAM ################################
($sec,$min,$hr,$mday,$mon,$year_localtime,$wday,$yday,$isdst) = localtime(time());
$year = $year_localtime + 1900;
$month = $mon + 1;

@pretty_months = ("","January","Febuary","March","April","May","June","July","August","September","October","November","December");
%apps = get_appointments("$calendar_path/appointments.txt");
%apps = add_appointments("$calendar_path/appointments-imported.txt",%apps);

$content.= print_month($month,$day);
print "$content";

############ BEGIN SUBROUTINES #################################

# Print the calendar
sub print_month($$) {
	my $return;
	my $month = $_[0];
	my $day = $_[1];


	$calendar = '';

	$cal = `cal $month $year`;
	@weeks= split(/\n/,"$cal");
	shift @weeks; shift @weeks;
	$calendar .= "<table cellspacing=1 cellpadding=2 border=0>";
	$calendar .= "<tr><td colspan=7 align=center><font color=$weekdayfont size=-1><b>$pretty_months[$month], $year</b></font></td></tr>";
	$calendar .= "<tr bgcolor=$weekdaybg>
			<td align=middle><font color=$weekdayfont size=-2><b>S</b></font></td>
			<td align=middle><font color=$weekdayfont size=-2><b>M</b></font></td>
			<td align=middle><font color=$weekdayfont size=-2><b>T</b></font></td>
			<td align=middle><font color=$weekdayfont size=-2><b>W</b></font></td>
			<td align=middle><font color=$weekdayfont size=-2><b>T</b></font></td>
			<td align=middle><font color=$weekdayfont size=-2><b>F</b></font></td>
			<td align=middle><font color=$weekdayfont size=-2><b>S</b></font></td>
		</tr>";
	foreach $week (@weeks){
		$calendar .= "<tr height=20%>";
		@days= split " ",$week;

		# Pad @days with leading blanks if it's the first week
		if ($days[0] == 1) {
			foreach (0 .. (6 - $days[-1])) {
	        		$calendar .= "<td bgcolor=$blankday>&nbsp;</td>";
			}
		}

		foreach my $day (@days){
			$calendar .= print_day($month,$day);
		}
		unless($days[0] ==1){
			$left = 7-@days;
			until ($left == 0){
	        		$calendar .= "<td bgcolor=$blankday>&nbsp;</td>";
				$left--;
			}
		}

		$calendar .= "</tr>";
	}

	$calendar .= "</table>";

	$return .= $calendar;

	return $return;


}

sub print_day($$) {
	my $return;
	my $month = $_[0];
	my $day = $_[1];
	my $appointment;
	my $appointment_text;
	my @appointment_array;

	
	@appointments_array = @{$apps{"$month-$day-$year"}};
	@appointments_array = (@appointments_array,@{$apps{"$month-$day-*"}});
	@appointments_array = (@appointments_array,@{$apps{"*-$day-*"}});
	$numapps=0;
	foreach $appointment (@appointments_array){
		$numapps++;
		if ($numapps > 3) {
			$appointment_text .= "...";
			last;
		}
		$_ = $appointment;
		$count = tr///c; #dont display more than 20 chars
		#if ($count > 40) {
		#	$appointment = substr($appointment,0,40) . "...";
		#}
		$appointment_text .="$appointment<br>";
	}

	if(($year == ($year_localtime+1900)) && ($mon == ($month-1)) && ($mday == $day)){
		$color = "$todaybg";
	} elsif ("$appointment_text") {
		$color = "$busydaybg";
	} else {
		$color = "$daybg";
	}
	if($appointment_text){	
		$return .= "<td bgcolor=$color align=right><font color=$dayfont size=-1><a href=\"$calendar_link\">$day</a></font></td>";
	}else{
		$return .= "<td bgcolor=$color align=right><font color=$dayfont size=-1>$day</font></td>";
	}

	return $return;

}

sub get_appointments ($){
   my $app_day;
   my $app;
   my %apps;
   if (open(INFILE, "<$_[0]")){
	   while(<INFILE>){
	      unless(/^#/){ # ignore comments
	         chomp;
            ($date,$text,$id) = split(/\t/,$_);
            push(@{$apps{"$date"}},"$text");
         }
      }
      close INFILE;
  }
  return %apps;
}
sub add_appointments($%){
   my ($file,%apps) = @_;
	$return .= "adding from $file<br>";
	if(-e "$file"){
		if(open(APPOINTMENTS,"<$file")){
			flock(2,APPOINTMENTS);
			while(<APPOINTMENTS>){
				unless(/^#/){ # ignore comments
					chomp;
					($date,$text,$id) = split(/\t/,$_);
					push(@{$apps{"$date"}},"$text");
				}
			}
			flock(8,APPOINTMENTS);
			close(APPOINTMENTS);
		}
	}
	return %apps;
}


