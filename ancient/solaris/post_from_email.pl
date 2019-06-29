#!/usr/bin/perl

###############################################################################
# post_from_email.pl - post to your My Blog (from FuzzyMonkey.org) by sending
#                      an email.  This script will even convert a picture
#                      attachment and post it to your blog as well.
#
# requires - A fully working install of Image Magick (with Perl Magick) to
#            resize attached pictures.
#
# install - To install this script, leave it in the cgi-bin/blog/ directory.
#           Next, edit the variables below to match those in 
#           lib/sitevariables.pm.  Now you will have to set up your email to
#           forward emails to this script.  This can be done with procmail,
#           but users of our webhosting can simply log into cpanel and add
#           a forwarder from some address such as blog@yourdomain.com
#           to "|/home/username/www/cgi-bin/blog/post_from_email.pl"
#
# by Michael from FuzzyMonkey.org
#
###############################################################################

###############################################################################
# variables - 
#
# (some of these should be identical to the ones in # lib/sitevariables.pm 
# and simply have the name of the variable that they # should be the same as.
###############################################################################
# set the same as lib/sitevariables.pm
$htmlsystempath = '/home/knoxshop/www/blog';
$htmlpath = 'http://www.spiceland.org/blog';
# What is the max width (in pixels) that you want the preview images to be
$preview_width = 250;
# What is the max width (in pixels) that you want the full res version to be
$full_width = 600;
# What is the full path to the cgi-bin/blog/ directory??
$blog_path = "/home/knoxshop/www/cgi-bin/blog";
# Please specify a password that must be at the top of the body of any email
# you want to be posted to your blog.  You can set this equal to the same one
# that you protect your protected/ directory with or a different one.  This
# script will only check this one.
$blog_password = "blogpass"; #leave this blank to disable passwords
###############################################################################

use MIME::Base64;

$date = time();

open(TEXT,">>$blog_path/entries.blog")||die("Could not open the entries.blog file. $!");
open(DEBUG,">$blog_path/debugemail.txt")||die("Could not open the debugemail.txt file. $!");

$start_text=0;
$start_pic=0;
if($blog_password){ # go ahead and set it to 1 if we want to ignore it
	$pass_found=0;
}else{
	$pass_found=1;
}
while(<STDIN>){
	print DEBUG $_;
	if($start_pic && $pass_found){ # we found a picture attachment
		if($_ && !($_ =~ /Content/i)){
			print PICTURE decode_base64($_);
		}
	}
	if($_ =~ /Subject:(.*)/){
		$subject = "$1";
	}
	if($_ =~ /--=/){
		$start_text=0;
	}

	if($start_text && $pass_found){
		$msg .= $_;
	}
	if($_ =~ /$blog_password/){
		$pass_found = 1;
	}
	if($_ =~ /base64/){ # we have an attachment so lets do picture stuff
		$start_pic=1;
		open(PICTURE,">$htmlsystempath/tmp.jpg")||die("Could not open temporary attachment file $!");
	}
	if($_ =~ /7bit/){
		$start_text=1;
	}
}

$msg =~ s/\n/<br>/g; # turn line breaks into HTML breaks

if(!($pass_found)){
	die("The correct password was not found.  Try again with the password at the top
		of the message body.");
}


# post the text to the blog
print TEXT "$date###$subject###$msg\n";

close(TEXT);
close(DEBUG);
if($start_pic){
	close(PICTURE);
	# post the picture to the blog
	if($svb::use_imagemagick =~ /yes/i){
		require "lib/imagemagick.pm";
		IMG::resize("$htmlsystempath/tmp.jpg","$htmlsystempath/$date-1.jpg",$preview_width,95);
		IMG::resize("$htmlsystempath/tmp.jpg","$htmlsystempath/big/$date-1.jpg",$full_width,95);
	}
}


