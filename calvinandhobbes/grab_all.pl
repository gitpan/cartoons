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

use Date::Calc qw(Today Month_to_Text Add_Delta_Days Delta_Days);
use File::Compare;

$path = "/u/sb/.www/cartoons/calvinandhobbes/img";
$prefix = "calvinandhobbes";
$suffix = ".gif";

$self = $0;
$self =~ s!^.*/!!;
$self =~ s!\.pl$!!;

$temp = "/tmp/${self}_$$.html";

$lynx = "/sw/bin/lynx -source";

#@Date = (1999,6,19);
@Date = Today();

while (1)
{

$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

@Past = Add_Delta_Days(@Date, Delta_Days(1999,6,18, 1988,6,17));
$yy = substr($Past[0], -2);
$mm = sprintf("%02d", $Past[1]);
$dd = sprintf("%02d", $Past[2]);

$base = "http://www.calvinandhobbes.com/strips/${yy}/${mm}";
$url = "$base/ch${yy}${mm}${dd}.html";

@Date = Add_Delta_Days(@Date,-1);

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
                    if ($html =~ m!<IMG\s+SRC="$base/(ch\d+\.gif)"\s+BORDER="0">\s*</A>!i)
                    {
                        $url = "$base/$1";
                        if (system("$lynx '$url' >'$file' 2>/dev/null") == 0)
                        {
                            if (-f $file && -s $file && -B $file)
                            {
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
                    } else { &alert("could not match the desired URL!"); }
                } else { &alert("could not read file '$temp'!"); }
            } else { &alert("file '$temp' is empty!"); }
            unlink($temp);
        } else { &alert("file '$temp' does not exist!"); }
    } else { &alert("system call #1: rc=$?"); }
} # else { &alert("file '$file' already exists!"); }

}

exit;

sub alert
{
    print STDERR "$self ($date): $_[0]\n";
}

__END__

