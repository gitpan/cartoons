#!/u/sb/sw/bin/perl -w

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
#use vars qw(@INC $path $first $title $prefix $suffix $copy);

unshift(@INC, '..');
unshift(@INC, '.');

require "gen_data.pl";
require "config.pl";

my($capt) = " Cartoon";

my($file,$head,$tail,$name,$date,$text,$less,$more,$prev,$next,$last)
    = &gen_data($path,$prefix,$suffix,$first);

print <<"VERBATIM";
Content-type: text/html

<HTML>
<HEAD>
    <TITLE>${head}${title}${capt}${tail}</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" BACKGROUND="../img/udjat.gif">
<CENTER>
<P><HR NOSHADE SIZE="2"><P>
    <H1>${head}${title}${capt}${tail}</H1>
<P><HR NOSHADE SIZE="2"><P>
VERBATIM

if (-f $file)
{
print <<"VERBATIM";
<IMG SRC="img/$name" ALT="[${title} ($date)]">
<P>
<FONT COLOR="#FF0000">$text</FONT>
<P><HR NOSHADE SIZE="2"><P>
<TABLE CELLSPACING="5" CELLPADDING="5" BORDER="0">
<TR>
VERBATIM
    if ($less && $more)
    {
print <<"VERBATIM";
<TD ALIGN="CENTER">
<A HREF="?date=$prev">Previous Day's ${title}${capt}</A>
</TD>
<TD ALIGN="CENTER">
<A HREF="?date=$next">Next Day's ${title}${capt}</A>
</TD>
VERBATIM
    }
    else
    {
print <<"VERBATIM";
<TD ALIGN="CENTER" COLSPAN="2">
VERBATIM
        if ($less)
        {
print <<"VERBATIM";
<A HREF="?date=$prev">Previous Day's ${title}${capt}</A>
VERBATIM
        }
        if ($more)
        {
print <<"VERBATIM";
<A HREF="?date=$next">Next Day's ${title}${capt}</A>
VERBATIM
        }
print <<"VERBATIM";
</TD>
VERBATIM
    }
print <<"VERBATIM";
</TR><TR>
<TD ALIGN="CENTER">
<A HREF="?date=$first">First ${title}${capt} ($first)</A>
</TD>
<TD ALIGN="CENTER">
<A HREF="?date=$last">Today's ${title}${capt} ($last)</A>
</TD>
</TR>
</TABLE>
VERBATIM
}
else
{
print <<"VERBATIM";
<H2>(None available)</H2>
VERBATIM
}

print <<"VERBATIM";
<P><HR NOSHADE SIZE="2"><P>
<A HREF="img/">${title} Archive Directory</A>
<P><HR NOSHADE SIZE="2"><P>
${copy}<P><HR NOSHADE SIZE="2"><P>
</CENTER>
</BODY>
</HTML>
VERBATIM

__END__

