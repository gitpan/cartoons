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

use Date::Calc qw(Today Add_Delta_Days);
use File::Compare;

$path = "/u/sb/.www/cartoons/peanuts/img";
$prefix = "peanuts";
$suffix = ".gif";

$self = $0;
$self =~ s!^.*/!!;
$self =~ s!\.pl$!!;

$temp = "/tmp/${self}_$$.html";

$lynx = "/sw/bin/lynx -source";

@Date = Today();

while(1)
{

$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

$base = "http://www.snoopy.com";
$url = "$base/comics/peanuts/archive/peanuts${date}.html";

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
#                   if ($html =~ m!<A\s+HREF="[^"]+">\s*<IMG\s+SRC="/(comics/peanuts/archive/images/peanuts\d+\.gif)"\s+BORDER=0\s+ALT="Daily\s+Strip">\s*</A>!i)
                    if ($html =~ m!<IMG\s+SRC="/(comics/peanuts/archive/images/peanuts\d+\.gif)"\s+ALIGN=MIDDLE\s+BORDER="0">!i)
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

