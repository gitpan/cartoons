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

use Date::Calc qw(Today);

$prefix = '';
$suffix = '';

$path = $0;
$path =~ s!/*[^/]*$!!;

unshift(@INC, $path);
require "config.pl";

$self = $0;
$self =~ s!^.*/!!;
$self =~ s!\.pl$!!;

$lynx = "/opt/bin/lynx -source";

@Date = Today();
$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

$path =~ s!/u/sb/\.www/!/u/sb/!;
$path =~ s!^/+!!;

$url = "http://www.engelschall.com/$path/$name";

#print "url = '$url'\n";
#print "file = '$file'\n";

unless (-f $file && -s $file)
{
    if (system("$lynx '$url' >'$file' 2>/dev/null") == 0)
    {
        if (-f $file && -s $file && -B $file)
        {
            chmod(0444, $file);
        }
        else
        {
            unlink($file);
#           &alert("download was unsuccessful!");
        }
    } else { &alert("system call: rc=$?"); }
} # else { &alert("file '$file' already exists!"); }

exit;

sub alert
{
    print STDERR "$self: $_[0]\n";
}

__END__

