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

use Date::Calc qw(Today Delta_Days Add_Delta_Days);
use File::Compare;

$path = "/u/sb/.www/cartoons/";
$prefix = "/img/";
$suffix = ".gif";

@Date = (1999,6,18);

@Toons = qw(dilbert userfriendly peanuts calvinandhobbes garfield);

$j = Delta_Days(@Date, Today());

for ( $i = 0; $i <= $j; $i++ )
{
    $date = sprintf("%04d%02d%02d", @Date);
    foreach $name (@Toons)
    {
        $file = "${path}${name}${prefix}${name}${date}${suffix}";
        print "$file\n" unless (-f $file && -s $file);
    }
    @Date = Add_Delta_Days(@Date, 1);
}

exit;

__END__

