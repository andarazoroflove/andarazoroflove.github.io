#!/usr/bin/perl

$width = 200;
$font = "<font face=verdana size=1 color=1f32a3>";
$conception_date = 1104105600-(280*24*60*60); #December 27th 2004 - 280 days or:
#$conception_date = 1080004308; # March 22 2004
# use the Unix timestamp converter at http://www.onlineconversion.com/unix_time.htm
$name = "example of a baby ";

print border_table("Our Baby's Progress",babydate());

sub border_table($){
	return <<HTML;
<table bgcolor=#376f9e cellpadding=0 cellspacing=1 border=0 width=$width>
<tr>
	<td align=center><font color=\"#FFFFFF\"><b>$_[0]</b></font></td>
</tr>
<tr><td bgcolor=#E3EAED>
	<table cellpadding=10 cellspacing=0 border=0 width=100%>
		<tr>
			<td>$_[1]</td>
		</tr>
	</table>
</td></tr></table>
HTML
}

sub babydate(){
	my $return;
	my $time = time(); 
	# 604800 seconds in a week

	my $days = sprintf("%.0f",($time - $conception_date)/60/60/24);
	my $weeks = sprintf("%.1f",$days/7);
	my $months = sprintf("%.1f",$days/30);
	my $left = sprintf("%.0f",280-(($time - $conception_date)/60/60/24));
	my $weeks_left = sprintf("%.1f",$left/7);
	my $months_left = sprintf("%.1f",$left/30);

	my $expected_date = $conception_date + (280*24*60*60);# plus 280 days;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($expected_date);
	$year += 1900;
	$mon += 1;
	my $birthday = "$mon/$mday/$year";

	if($weeks < 6){
		$img = "http://my.webmd.com/NR/rdonlyres/1FA067A3-F1B4-433A-9217-EAD4F781178D.jpg";
		$caption = 4;
	}elsif($weeks <10){
		$img = "http://my.webmd.com/NR/rdonlyres/FD36E703-095C-4FC4-9F98-28A98E75DC2D.jpg";
		$caption = 6;
	}elsif($weeks <14){
		$img = "http://my.webmd.com/NR/rdonlyres/2AC85BEA-E863-4DFA-807D-661CD78D7243.jpg";
		$caption = 12;
	}elsif($weeks <18){
		$img = "http://my.webmd.com/NR/rdonlyres/EDBEA6CF-21EF-4B37-A9FB-174073D34936.jpg";
		$caption = 16;
	}elsif($weeks <22){
		$img = "http://my.webmd.com/NR/rdonlyres/75281688-42E2-49A1-AE6C-4A07C70FD6ED.jpg";
		$caption = 20;
	}elsif($weeks <26){
		$img = "http://my.webmd.com/NR/rdonlyres/9A9B8A2F-1957-45BC-B702-5396E702607E.jpg";
		$caption = 24;
	}elsif($weeks <30){
		$img = "http://my.webmd.com/NR/rdonlyres/8A7F3F69-BEFD-4CEE-B127-D0754F0ECA2B.jpg";
		$caption = 28;
	}elsif($weeks <34){
		$img = "http://my.webmd.com/NR/rdonlyres/1959C6DA-D6CC-4E34-82BF-B99551A3B9C7.jpg";
		$caption = 32;
	}else{
		$img = "http://my.webmd.com/NR/rdonlyres/9052FDEE-00BF-457F-B6B1-949624446C89.jpg";
		$caption = 36;
	}

	$days_width = $days/280*$width;
	$left_width = $left/280*$width;

	$return .= <<HTML;
<center>
<table bgcolor=#000000 cellpadding=0 cellspacing=1 border=0 width=140><tr><td>
	<table bgcolor=#FFFFFF cellpadding=0 cellspacing=0 border=0 width=100%>
		<tr>
			<td width=\"$days_width\" bgcolor=\"blue\">&nbsp;</td>
			<td width=\"$left_width\" bgcolor=\"#FFFFFF\"></td>
		</tr>
	</table>
</td></tr></table>
</center>
HTML
	
	#$return .= "$days out of $left days till figment!\n";
	$return .= "$font Age:<blockquote><li>$days days <li>$weeks weeks <li>$months months</blockquote>\n";
	$return .= "Birthday ($birthday):<blockquote><li>$left days <li>$weeks_left weeks <li>$months_left months</blockquote>\n";
	$return .= "<center>$name at $caption weeks<br><img src=\"$img\"><br>(picture from <a href=\"http://my.webmd.com/health_and_wellness/pregnancy_family/\" target=\"new\">WebMD</a>).</center></font>\n";

	return $return;
}
