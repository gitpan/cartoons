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

use Date::Calc qw(Today Add_Delta_Days Delta_Days);
use File::Compare;

$path = "/u/sb/.www/cartoons/garfield/img";
$prefix = "garfield";
$suffix = ".gif";

@Date = Today();
$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

@Prev = Add_Delta_Days(@Date, Delta_Days(1999,6,22,1999,6,8));
$date = sprintf("%04d%02d%02d", @Prev);
$name = "${prefix}${date}${suffix}";
$prev = "$path/$name";

while (-f $prev)
{
#   print "rename '$prev' '$file'...\n";
    unless (rename($prev, $file))
    {
        warn "unable to rename '$prev' to '$file': $!\n";
    }
    @Date = Add_Delta_Days(@Date,-1);
    @Prev = Add_Delta_Days(@Prev,-1);
    $date = sprintf("%04d%02d%02d", @Date);
    $name = "${prefix}${date}${suffix}";
    $file = "$path/$name";
    $date = sprintf("%04d%02d%02d", @Prev);
    $name = "${prefix}${date}${suffix}";
    $prev = "$path/$name";
}

__END__

