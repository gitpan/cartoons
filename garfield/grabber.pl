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

$self = $0;
$self =~ s!^.*/!!;
$self =~ s!\.pl$!!;

$temp = "/tmp/${self}_$$.html";

$lynx = "/sw/bin/lynx -source";

#@Date = Add_Delta_Days(Today(), Delta_Days(1999,6,22,1999,6,8));
@Date = Today();
$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

$base = "http://www.garfield.com";
$url = "$base/comics/pages/index.html";

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
                    if ($html =~ m!\.cgi\?code=http://www\.garfield\.com/comics/strips/ga\d+\.gif">\s*<IMG\s+SRC="/(comics/strips/ga\d+\.gif)"!i)
                    {
                        $url = "$base/$1";
                        if (system("$lynx '$url' >'$file' 2>/dev/null") == 0)
                        {
                            if (-f $file && -s $file && -B $file)
                            {
                                $max = 30;
                                while ($max--)
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
#                                           &alert("same file as $date!");
                                        }
                                        else { chmod(0444, $file); }
                                        last;
                                    }
                                    else { chmod(0444, $file) unless ($max); }
                                }
                            }
                            else
                            {
                                unlink($file);
                                &alert("download was unsuccessful!");
                            }
                        } else { &alert("system call #2: rc=$?"); }
                    } else { &alert("could not match the desired URL!"); }
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

