#!perl -w

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
#use vars qw($copy);

use Date::Calc qw(:all);

Language(Decode_Language("Deutsch"));

sub gen_start
{
    my($start) = @_;
    my($prev,$next,$date,$last);

    $next = '';
    @{$start} = Today();
    $last = sprintf("%04d%02d%02d", @{$start});
    $date = $last;
    if (($ENV{'QUERY_STRING'} =~ /^date=(\d\d\d\d)(\d\d)(\d\d)$/i) &&
        (check_date($1,$2,$3)) &&
        (Delta_Days($1,$2,$3,@{$start}) > 0))
    {
        @{$start} = ($1,$2,$3);
        $date = sprintf("%04d%02d%02d", @{$start});
        $next = sprintf("%04d%02d%02d", Add_Delta_Days(@{$start},+1));
    }
    $prev = sprintf("%04d%02d%02d", Add_Delta_Days(@{$start},-1));
    return($prev,$next,$date,$last);
}

sub gen_data
{
    my($path,$prefix,$suffix,$first) = @_;
    my(@Date,@First);
    my($file,$head,$tail,$name,$date,$text,$less,$more,$prev,$next,$last);
    my($maximum) = 30; # to prevent infinite loop

    $less = 1;
    $more = 0;
    $head = "Today's ";
    $tail = "";

    ($prev,$next,$date,$last) = &gen_start(\@Date);

    if ($next ne '')
    {
        $more = 1;
        $head = "";
        $tail = " Archive";
    }

    $name = "${prefix}${date}${suffix}";
    $file = "$path/$name";

    while ((! -f $file) && (--$maximum))
    {
        $more = 0;
        @Date = Add_Delta_Days(@Date,-1);
        $date = sprintf("%04d%02d%02d", @Date);
        $name = "${prefix}${date}${suffix}";
        $file = "$path/$name";
    }

    if ($first =~ /^(\d\d\d\d)(\d\d)(\d\d)$/i)
    {
        @First = ($1,$2,$3);
        if (check_date(@First) && (Delta_Days(@Date,@First) >= 0))
        {
            $less = 0;
        }
    }

    $text = sprintf("%s, den %d. %s %d",
                Day_of_Week_to_Text(Day_of_Week(@Date)),
                $Date[2],
                Month_to_Text($Date[1]),
                $Date[0]);
    $prev = sprintf("%04d%02d%02d", Add_Delta_Days(@Date,-1));
    $next = sprintf("%04d%02d%02d", Add_Delta_Days(@Date,+1));

    return($file,$head,$tail,$name,$date,$text,$less,$more,$prev,$next,$last);
}

$copy = <<"VERBATIM";
This Perl Software is<BR>
Copyright &copy; 1999 by <A HREF="mailto:sb\@engelschall.com">Steffen Beyer</A>.<BR>
All rights reserved.<P>
This program is free software; you can redistribute it<BR>
and/or modify it under the same terms as Perl itself.
VERBATIM

1;

