#!/usr/bin/perl
# path to where your photos are stored
$photo_path = "/home/knoxshop/www/photo/";
# path to where the index.cgi is
$script_path = "/home/knoxshop/www/cgi-bin/photo/";
$script_url = "http://www.spiceland.org/cgi-bin/photo";

unless(-e "$script_path/sitevariables.pl"){exit(3);}
require "$script_path/sitevariables.pl";

srand();
@folders = `find $photo_path -iname "*.jpg"`;

$picture = $folders[rand(int(@folders))];
chomp($picture);

if($picture =~ /$photoroot\/(.*)\/(.*)/i){
	$album = $1;
	$picture = $2;
	$album_cgi = $album;
	$album_cgi =~ s/ /+/g;
	$link = "$script_url/index.cgi?mode=view&album=$album_cgi";
	print "Random Photo<br><a href=\"$link\"><img src=\"$dataurl/$album/thumbnails/$picture\" border=0></a><br>
	<small><small>from $album</small></small>\n";

}

