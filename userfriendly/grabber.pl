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

use Date::Calc qw(Today Month_to_Text Add_Delta_Days);
use File::Compare;

$path = "/u/sb/.www/cartoons/userfriendly/img";
$prefix = "userfriendly";
$suffix = ".gif";

$self = $0;
$self =~ s!^.*/!!;
$self =~ s!\.pl$!!;

$temp = "/tmp/${self}_$$.html";

$lynx = "/opt/bin/lynx -source";

@Date = Today();
$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

$yy = substr($Date[0], -2);
$mm = substr(Month_to_Text($Date[1]), 0, 3);
$mm =~ tr/A-Z/a-z/;

$base = "http://www.userfriendly.org/cartoons/archives/${yy}${mm}";
$url = "$base/$date.html";

unless (-f $file && -s $file)
{
    if (system("$lynx '$url' >'$temp' 2>/dev/null") == 0)
    {
        if (-f $temp)
        {
            if (-s $temp)
            {
                {
                    local($/);
                    undef $/;
                    if (open(TEMP, "<$temp"))
                    {
                        $html = <TEMP>;
                        close(TEMP);
                    }
                    else { $html = ''; }
                }
                if ($html ne '')
                {
                    if ($html =~ m!<IMG\s+SRC="/cartoons/archives/${yy}${mm}/((?:uf)?\d+\.gif)">!i)
                    {
                        $url = "$base/$1";
                        if (system("$lynx '$url' >'$file' 2>/dev/null") == 0)
                        {
                            if (-f $file && -s $file && -B $file)
                            {
                                @Date = Add_Delta_Days(@Date,-1);
                                $date = sprintf("%04d%02d%02d", @Date);
                                $name = "${prefix}${date}${suffix}";
                                $prev = "$path/$name";
                                if (-f $prev)
                                {
                                    if (compare($prev,$file) == 0)
                                    {
                                        unlink($file);
#                                       &alert("same file as yesterday!");
                                    }
                                    else { chmod(0444, $file); }
                                }
                                else { chmod(0444, $file); }
                            }
                            else
                            {
                                unlink($file);
                                &alert("download was unsuccessful!");
                            }
                        } else { &alert("system call #2: rc=$?"); }
                    } else { &alert("could not match the desired URL!")
                          if ($html =~ /<!--\s+Comic\s+Strip\s+-->/i); }
                } else { &alert("could not read file '$temp'!"); }
            } else { &alert("file '$temp' is empty!"); }
            unlink($temp);
        } else { &alert("file '$temp' does not exist!"); }
    } else { &alert("system call #1: rc=$?"); }
} # else { &alert("file '$file' already exists!"); }

exit;

sub alert
{
    print STDERR "$self: $_[0]\n";
}

__END__

