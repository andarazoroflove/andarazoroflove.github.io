#!/usr/bin/perl


# load required modules
use lib "./lib";
use CGI;
use strict;
use CGI::Carp qw(fatalsToBrowser);
use BBCode;
use sitevariables;
use common;
use lang;
if($svb::use_imagemagick eq "yes"){
	require "lib/imagemagick.pm";
}


# prepare
package dft;
our $cur = CGI::new();
our $bbc = HTML::BBCode->new({no_html=>0,linebreaks=>1,allowed_tags=>["b", "u", "i", "color", "size", "quote", "code", "list", "url", "email", "img"]});
our $mode = $cur->param('mode');
our $onpage = $cur->param('page');
if(!$onpage){$onpage = 1;}
our $content;




# program
if ($mode eq "single"){
	$content .= viewsingle();
}elsif($mode eq "viewone"){
	$content .= viewone();
}else{
	$content .= viewall();
}
print "Content-type:text/html\n\n" . cmn::printpage($svb::templatefile,$content);



# subroutines
sub viewall{

	my ($return,$filetype,$temp,$printfiles,@lines,$num);
	$num = 1;
	$return .= "\n
<table width=100% class=outside>
	<tr>
		<td width=70%>
			<center>
				<span class=header>$svb::title<span>
			</center>
		</td>
		<td align=right>
			<span class=default><form method=get action=search.cgi>
			<input type=text name=searchfor><br>
			<input type=submit value=\"$lang::search_blogs\"></form><br>";
	if($svb::subscriptions eq "yes"){
		$return .= "
			<a href=subscribe.cgi>$lang::subscribe</a><br>";
	}
	$return .= "
			<a href=$svb::htmlpath/index.rss><img src=$svb::htmlpath/rss.gif border=0></a></span><br>
		</td>
	</tr>
	<tr>
		<td valign=top colspan=2>\n";

	open (INFILE, "./$svb::post_template")||cmn::dienice("$lang::read_file_error - ./$svb::post_template\: $!!");
	while (<INFILE>){
		$temp .= $_;
	}
	close INFILE;

	$temp =~ s/<!--*-->//;
	
	open (INFILE, "./entries.blog")||cmn::dienice("$lang::read_file_error - ./entries.blog\: $!!");
	@lines = <INFILE>;
	close INFILE;

	my $total = @lines;


	my $countpages = 1;
	if ($total > $svb::page){
                if($onpage != 1){
                        $return .= "<p align=right><span class=default>$lang::page <a href=index.cgi?page=$countpages>1</a> ";
                }else{
                        $return .= "<p align=right><span class=default>$lang::page 1 ";
                }
                while ($total-($svb::page*$countpages) > 0){
                        $countpages++;
                        if($onpage != $countpages){
                                $return .= "<a href=index.cgi?page=$countpages>$countpages</a> ";
                        }else{
                                $return .= "$countpages ";
                        }
                }
		$return .= "</span></p>";
	}



	
	@lines = reverse @lines;

	if(!@lines){
		$return .= "<div style='margin-left: 40px\;'><span class=default>$lang::noposts</span></div>"
	}

        my $count4;
        if($onpage > 1){
                while ($count4 < $svb::page*($onpage-1)){
                        shift @lines;
                        $count4++;
                }
        }

	
	foreach (@lines){
		if($num <= $svb::page){
			chomp ($_);
			my $temp2 = "\n\n
						$temp\n\n\n";
			my ($date,$title,$text) = split(/###/,$_);
			$text =~ s/\n/<br>\n/ig;
			my @files = glob("$svb::htmlsystempath/$date*");
			foreach (@files){
				$_ =~ s/.*\/(\d+-\d+(-big)?\.[\w\d]+)/$1/ig;
				if($_ =~ /(\.wmv|\.mpg|\.mov|\.avi|\.rm|\.ra|\.asf|\.moov|\.movie)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/movie.png border=0 alt='$lang::movie'></a> ";
				}elsif($_ =~ /(\.jpg|\.gif|\.tif|\.png|\.bmp|\.jpeg)$/ig){

					# begin changed by mike to allow for thumbnails
					my $link_text = "";
					my $link_text_end = "";
					my ($width,$height);
					if(-e "$svb::htmlsystempath/big/$_" && $svb::use_imagemagick =~ /yes/i){
						($width,$height) = IMG::get_size("$svb::htmlsystempath/big/$_");
						$width += 20;
						$height += 20;
						$link_text = "<A HREF=\"#null\" OnClick=\" javascript:window.open('$svb::htmlpath/big/$_','Popup','width=$width,height=$height,scrollbars=1')\">";	
						$link_text_end = "</a>";
					}
					$temp2 =~ s/\[picture\]/$link_text<img class=border src=$svb::htmlpath\/$_ align=$svb::picalign border=0>$link_text_end/ig;
					# end changed by mike
				}elsif($_ =~ /(\.pcx|\.pict|\.pdf|\.ps|\.prn|\.eps)$/ig){
				$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/image.png border=0 alt='$lang::image'></a> ";
				}elsif($_ =~ /(\.doc|\.rtf|\.wps|\.txt|\.htm|\.html|\.shtml|\.pwd|\.wks|\.wpd|\.wri|\.hed|\.lwp|\.wp|\.pp|\.sxc|\.sxi)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/document.png border=0 alt='$lang::text_document'></a> ";
				}elsif($_ =~ /(\.tar|\.tar.gz\.tgz|\.bz2|\.bz|\.zip|\.cab)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/archive.png border=0 alt='$lang::archive'></a> ";
				}elsif($_ =~ /(\.c|\.cpp|\.cxx|\.h|\.o|\.p|\.pl|\.pm|\.cgi|\.php|\.asp|\.prg|\.sc|\.asm|\.cob
									|\.cpi|\.cv|\.sh|\.tsh|\.csh|\.scp)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/code.png border=0 alt='$lang::code'></a> ";
				}elsif($_ =~ /(\.wdb|\.adb|\.cdx|\.dbc|\.dbf|\.dbt|\.mdb|\.ntf|\.dif|\.slk|\.syl|\.wkq|\.wkr|\.xls)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/database.png border=0 alt='$lang::dbss'></a> ";
				}elsif($_ =~ /(\.au|\.mp3|\.wav|\.ogg|\.aif|\.wma|\.ra|\.ram|\.cda|\.mp2|\.snd|\.voc|\.mod|\.mid|\.midi)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/audio.png border=0 alt='$lang::audio'></a> ";
				}else{
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/unknown.png border=0 alt='$lang::unknown'></a> ";
				}
			} # foreach @files
			my $readmore_text;
			$text = $bbc->parse($text);
			if(length($text) > $svb::textmax && $svb::textmax > 0){
				$text = substr($text,0,$svb::textmax);
				$text =~ s/\b\w+$/\.\.\./ig;
				$readmore_text = "<a href=index.cgi?mode=viewone&blog=$date>$lang::readmore<\/a> | ";
			}else{
				$readmore_text = "";
			}
			my $pdate = cmn::mydate($date + (60*60*$svb::timetoadd));
			$temp2 =~ s/\[date\]/$pdate/ig;
			$temp2 =~ s/\[readmore\]/$readmore_text/ig;
			$temp2 =~ s/\[text\]/$text/ig;
			$temp2 =~ s/\[title\]/$title/ig;
			$temp2 =~ s/\[picture\]//ig;
			if ($filetype){
				$filetype = "<br><br>$lang::attached_file\: &nbsp; $filetype<br>";
			}
			$temp2 =~ s/\[attachedfiles\]/$filetype/ig;
			my $cstring = $lang::comments;
			if (-e "./comments/$date.txt"){
				open(COMMENTS,"<./comments/$date.txt");
				my @count = (<COMMENTS>);
				my $count = @count;
				close COMMENTS;
	
				$cstring = "<A HREF=\"#null\" OnClick=\" javascript:window.open('comments.cgi?blog=$date','Popup','width=500,height=600,scrollbars=1')\">$count $cstring</a> <img src=\"$svb::htmlpath/comments.gif\">";
			}else{
				$cstring = "<A HREF=\"#null\" OnClick=\" javascript:window.open('comments.cgi?blog=$date','Popup','width=500,height=600,scrollbars=1')\">$lang::no_comments</a>";
			}
			$temp2 =~ s/\[comments\]/$cstring/ig;
			$return .= $temp2;
			undef $printfiles;
			undef $temp2;
			undef $filetype;
			$num++;
		} # if $num <= $svb::page

	} # foreach @lines
	
	my $countpages = 1;
	if ($total > $svb::page){
		if($onpage != 1){
			$return .= "<p align=right><span class=default>$lang::page <a href=index.cgi?page=$countpages>1</a> ";
		}else{
			$return .= "<p align=right><span class=default>$lang::page 1 "; 
		}
		while ($total-($svb::page*$countpages) > 0){
			$countpages++;
			if($onpage != $countpages){
				$return .= "<a href=index.cgi?page=$countpages>$countpages</a> ";
			}else{
				$return .= "$countpages ";
			}
		}
		$return .= "</span></p>";
	}


	$return .= "
		</td>
	</tr>
</table>";

	return $return;

} # sub viewall




sub viewone{

	my ($return,$filetype,$temp,$printfiles,@lines);
	my $blog = $cur->param('blog');
	$return .= "\n<center>
<table width=100%>
	<tr>
		<td width=70%>
			<center>
			<span class=header>$svb::title</span>
			</center>
		</td>
		<td align=right>
			<form method=get action=search.cgi>
			<input type=text name=searchfor>
			<input type=submit value='$lang::search_blogs'></form>
			<span class=default><a href=subscribe.cgi>$lang::subscribe</a></span><br>
		</td>
	</tr>
	<tr>
		<td valign=top colspan=2>\n";

	open (INFILE, "./$svb::post_template")||cmn::dienice("$lang::read_file_error - ./$svb::post_template\: $!!");
	while (<INFILE>){
		$temp .= $_;
	}
	close INFILE;

	$temp =~ s/<!--*-->//;
	
	open (INFILE, "./entries.blog")||cmn::dienice("$lang::read_file_error - ./entries.blog\: $!!");
	@lines = <INFILE>;
	close INFILE;
	
	@lines = reverse @lines;

	foreach (@lines){
		chomp ($_);
		my $temp2 = "\n\n
		<br><br>
			<table width=98%>
				<tr>
					<td>
					$temp
					</td>
				</tr>
			</table>\n\n\n";
		my ($date,$title,$text) = split(/###/,$_);
		if($date == $blog){
			$text =~ s/\n/<br>\n/ig;
			my @files = glob("$svb::htmlsystempath/$date*");
			foreach (@files){
				$_ =~ s/.*\/(\d+-\d+\.[\w\d]+)/$1/ig;
				if($_ =~ /(\.wmv|\.mpg|\.mov|\.avi|\.rm|\.ra|\.asf|\.moov|\.movie)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/movie.png border=0 alt='$lang::movie'></a> ";
				}elsif($_ =~ /(\.jpg|\.gif|\.tif|\.png|\.bmp|\.jpeg)$/ig){
					# begin changed by mike to allow for thumbnails
					my $base_name = $_;
					my $link_text = "";
					my $link_text_end = "";
					my ($width,$height);
					$base_name =~ s/\.[\w\d]+$//;
					if(-e "$svb::htmlsystempath/$base_name-big.jpg" && $svb::use_imagemagick =~ /yes/i){
						($width,$height) = IMG::get_size("$svb::htmlsystempath/$base_name-big.jpg");
						$link_text = "<A HREF=\"#null\" OnClick=\" javascript:window.open('$svb::htmlpath/$base_name-big.jpg','Popup','width=$width,height=$height,scrollbars=1')\">";	
						$link_text_end = "</a>";
					}
					$temp2 =~ s/\[picture\]/$link_text<img src=$svb::htmlpath\/$_ align=$svb::picalign>$link_text_end/ig;
					# end changed by mike
				}elsif($_ =~ /(\.pcx|\.pict|\.pdf|\.ps|\.prn|\.eps)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/image.png border=0 alt='$lang::image'></a> ";
				}elsif($_ =~ /(\.doc|\.rtf|\.wps|\.txt|\.htm|\.html|\.shtml|\.pwd|\.wks|\.wpd|\.wri|\.hed|\.lwp|\.wp|\.pp|\.sxc|\.sxi)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/document.png border=0 alt='$lang::text_document'></a> ";
				}elsif($_ =~ /(\.tar|\.tar.gz\.tgz|\.bz2|\.bz|\.zip|\.cab)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/archive.png border=0 alt='$lang::archive'></a> ";
				}elsif($_ =~ /(\.c|\.cpp|\.cxx|\.h|\.o|\.p|\.pl|\.pm|\.cgi|\.php|\.asp|\.prg|\.sc|\.asm|\.cob
									|\.cpi|\.cv|\.sh|\.tsh|\.csh|\.scp)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/code.png border=0 alt='$lang::code'></a> ";
				}elsif($_ =~ /(\.wdb|\.adb|\.cdx|\.dbc|\.dbf|\.dbt|\.mdb|\.ntf|\.dif|\.slk|\.syl|\.wkq|\.wkr|\.xls)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/database.png border=0 alt='$lang::dbss'></a> ";
				}elsif($_ =~ /(\.au|\.mp3|\.wav|\.ogg|\.aif|\.wma|\.ra|\.ram|\.cda|\.mp2|\.snd|\.voc|\.mod|\.mid|\.midi)$/ig){
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/audio.png border=0 alt='$lang::audio'></a> ";
				}else{
					$filetype .= "<a href=$svb::htmlpath/$_><img src=$svb::htmlpath/unknown.png border=0 alt='$lang::unknown'></a> ";
				}
			} # foreach @files
			
			my $pdate = cmn::mydate($date + (60*60*$svb::timetoadd));
			$temp2 =~ s/\[date\]/$pdate/ig;
			$temp2 =~ s/\[readmore\]/<a href=index.cgi>$lang::back<\/a> |/ig;
			$text = $bbc->parse($text);
			$temp2 =~ s/\[text\]/$text/ig;
			$temp2 =~ s/\[title\]/$title/ig;
			$temp2 =~ s/\[picture\]//ig;
			$temp2 =~ s/\[attachedfiles\]/$filetype/ig;
			$temp2 =~ s/\[comments\]/<A HREF=\"#null\" OnClick=\" javascript:window.open('comments.cgi?blog=$date','Popup','width=550,height=600,scrollbars=1')\">$lang::comments<\/a>/ig;
			$return .= $temp2;
			undef $printfiles;
			undef $temp2;
			undef $filetype;
		} # if date == blog
	} # foreach @lines
	
	$return .= "
		</td>
	</tr>
</table><br><br><br></center>
<span class=header>$lang::comments</span><center>
<table width=100%><tr><td class=horidiv></td></tr></table>";
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

	return $return;


} # sub viewone


