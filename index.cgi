#!/sw/bin/perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 1999 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

#use strict;
#use vars qw($path $first $title $prefix $suffix $copy);

require "gen_data.pl";

my(%conf,@URL,$url,$tag,$top,$flag);

################ Begin of user configurable constants section: ################

$tag = "Daily";
$top = "Cartoons";
@URL = ( "dilbert", "userfriendly", "peanuts", "calvinandhobbes", "garfield" );

################# End of user configurable constants section. #################

my(@Date,$file,$head,$tail,$name,$date,$text,$less,$more,$prev,$next,$last);

foreach $url (@URL)
{
    require "$url/config.pl";
    $conf{$url}{'path'}   = $path;
    $conf{$url}{'first'}  = $first;
    $conf{$url}{'title'}  = $title;
    $conf{$url}{'prefix'} = $prefix;
    $conf{$url}{'suffix'} = $suffix;
}

print <<"VERBATIM";
Content-type: text/html

<HTML>
<HEAD>
    <TITLE>${tag} ${top}</TITLE>
    <META HTTP-EQUIV="pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="expires" CONTENT="now">
</HEAD>
<BODY BGCOLOR="#FFFFFF" BACKGROUND="img/udjat.gif">
<CENTER>
<P><HR NOSHADE SIZE="2"><P>
    <H1>${tag} ${top}</H1>
<P><HR NOSHADE SIZE="2"><P>
VERBATIM

foreach $url (@URL)
{
    $path   = $conf{$url}{'path'};
    $first  = $conf{$url}{'first'};
    $title  = $conf{$url}{'title'};
    $prefix = $conf{$url}{'prefix'};
    $suffix = $conf{$url}{'suffix'};

    ($file,$head,$tail,$name,$date,$text,$less,$more,$prev,$next,$last)
        = &gen_data($path,$prefix,$suffix,$first);

    if (-f $file)
    {
print <<"VERBATIM";
<A HREF="$url/?date=$date"><H2>$title</H2></A>
<A HREF="$url/?date=$date"><IMG SRC="$url/img/$name" ALT="[${title} ($date)]" BORDER="0"></A>
<P>
<FONT COLOR="#FF0000">$text</FONT>
VERBATIM
    }
    else
    {
print <<"VERBATIM";
<A HREF="$url/"><H2>$title</H2></A>
<H3>(None available)</H3>
VERBATIM
    }
print <<"VERBATIM";
<P><HR NOSHADE SIZE="2"><P>
VERBATIM
}

($prev,$next,$date,$last) = &gen_start(\@Date);

print <<"VERBATIM";
<TABLE CELLSPACING="5" CELLPADDING="5" BORDER="0">
<TR>
<TD ALIGN="CENTER">
<A HREF="?date=$prev">Previous Day's ${top}</A>
</TD>
VERBATIM

    if ($next ne '')
    {
print <<"VERBATIM";
<TD ALIGN="CENTER">
<A HREF="?date=$next">Next Day's ${top}</A>
</TD>
VERBATIM
    }

print <<"VERBATIM";
</TR>
</TABLE>
<P><HR NOSHADE SIZE="2"><P>
VERBATIM

$flag = 0;
foreach $url (@URL)
{
    $title = $conf{$url}{'title'};
    print "<BR>\n" if ($flag);
print <<"VERBATIM";
<A HREF="$url/img/">${title} Archive Directory</A>
VERBATIM
    $flag = 1;
}

print <<"VERBATIM";
<P><HR NOSHADE SIZE="2"><P>
${copy}<P><HR NOSHADE SIZE="2"><P>
</CENTER>
</BODY>
</HTML>
VERBATIM

__END__

