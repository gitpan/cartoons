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

$name = 'dilbert';
$path = "/u/sb/.www/cartoons/";
$prefix = "/img/";
$suffix = ".gif";

@Date = (1999,8,16);

$date = sprintf("%04d%02d%02d", @Date);
$prev = "${path}${name}${prefix}${name}${date}${suffix}";

@Date = Add_Delta_Days(@Date, 1);

$j = Delta_Days(@Date, Today());

for ( $i = 0; $i < $j; $i++ )
{
    $date = sprintf("%04d%02d%02d", @Date);
    $file = "${path}${name}${prefix}${name}${date}${suffix}";
    print "rename($file,$prev);\n";
    rename($file,$prev);
    $prev = $file;
    @Date = Add_Delta_Days(@Date, 1);
}

exit;

__END__

