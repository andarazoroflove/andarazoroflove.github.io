##########################################################################
#
#	Use English
#
##########################################################################


package lang;

# Errors #################################################################
our $read_file_error = "Couldn't open file for reading";
our $write_file_error = "Couldn't open file for writing";
our $pic_too_big = "Your filesize is too large!  Please resize and reupload!";
our $noblog = "No blog entry was selected!  Please go back and choose one to post comments to.";
our $noposts = "There have been no posts to this blog yet.";
our $noemail = "You must specify an email address!";

# Words ##################################################################
our $oops = "Oops!";
our $search_blogs = "Search Blogs";
our $view_blogs = "View Blogs";
our $control = "Control Panel";
our $title = "Title"; # noun
our $date = "Date";
our $page = "Page";
our $postto = "Post to"; # followed by $svb::title
our $youposted = "Blog post successful!  RSS Feed updated!";
our $subscribe = "Subscribe to $svb::title";
our $unsubscribe = "Unsubscribe from $svb::title";
our $howtounscr = "You can unsubscribe using the link in any notification email.";
our $subscribed = "You have been subscribed.";
our $unsubscribed = "You have been unsubscribed.";
our $filesuploaded = "You uploaded these files to be included in this post:";
our $text_document = "Text Document";
our $image = "Image File";
our $unknown = "Unknown File";
our $archive = "Archive";
our $movie = "Movie";
our $code = "Code File";
our $dbss = "Database/Spreadsheet";
our $audio = "Audio File";
our $attachedfile = "Attached Files";
our $no_comments = "No Comments Yet";
our $noattachedfiles = "No Attached Files.";
our $Name = "Name";
our $Email = "Email";
our $text = "Text";
our $comments = "Comments"; # noun
our $comment = "Comment"; # singular noun
our $postcomments = "Post Comments"; # noun
our $readmore = "Read More";
our $fulltext = "Full Text and Comments";
our $total = "total";
our $back = "Back"; # to go to front page
our $postingcomment = "Posting a Comment";
our $nameorcomments = "You either left your name or your comments blank!  Please go back and fix it.";
our $noresults = "No results for your search.";
our $usebbcode = "Use BBCode for formatting.";
our $processing = "Processing";
our $edit = "Edit";
our $delete = "Delete";
# new in version 1.21
our $Submit = "Submit";
our $invalidemail= "Invalid Email Address!";
our $longwords = "Please do not use words longer than 30 characters.";
our $longname = "Please limit your name to 30 characters.";
our $longcomments = "Please limit your comments to 1000 characters.";
our $posted_on = "posted&nbsp;on&nbsp;"; # must have non-breaking spaces. this is followed by the date "posted on date" etc.

# Footer #################################################################
our $powered_by = "Powered by"; # followed by $cmn::version
our $copyright = "Copyright 2004 FuzzyMonkey.org";
our $wizard = "Created by the scripting wizards at <a href=http://www.fuzzymonkey.org>FuzzyMonkey.org</a>.";

# Date and Time ##########################################################
our @months = (
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December"
);
