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

$base = "http://www.unitedmedia.com";
$path = "/u/sb/.www/cartoons/dilbert/img/archive";
$prefix = "dilbert";
$suffix = ".gif";

$self = $0;
$self =~ s!^.*/!!;
$self =~ s!\.pl$!!;

#$temp = "/tmp/${self}_$$.html";

$lynx = "/sw/bin/lynx -source";

$count = '01';
@Date = (1995, 1, 1);

while(1)
{

$date = sprintf("%04d%02d%02d", @Date);
$name = "${prefix}${date}${suffix}";
$file = "$path/$name";

#$yy = substr($Date[0], -2);
#$mm = sprintf("%02d", $Date[1]);
#$dd = sprintf("%02d", $Date[2]);

@Date = Add_Delta_Days(@Date,1);

unless (-f $file && -s $file)
{
#   if (system("$lynx '$url' >'$temp' 2>/dev/null") == 0)
#   {
#       if (-f $temp)
#       {
#           if (-s $temp)
#           {
#               {
#                   local($/);
#                   undef $/;
#                   if (open(TEMP, "<$temp"))
#                   {
#                       $html = <TEMP>;
#                       close(TEMP);
#                   }
#                   else { $html = ''; }
#               }
#               if ($html ne '')
#               {
#                   if ($html =~ m!!i)
#                   {
                        $url = "$base/comics/dilbert/scott/dawn/images/pg${count}.gif";
                        if (system("$lynx '$url' >'$file' 2>/dev/null") == 0)
                        {
                            if (-f $file && -s $file && -B $file)
                            {
#                               $date = sprintf("%04d%02d%02d", @Date);
#                               $name = "${prefix}${date}${suffix}";
#                               $prev = "$path/$name";
#                               if (-f $prev)
#                               {
#                                   if (compare($prev,$file) == 0)
#                                   {
#                                       unlink($file);
#                                       &alert("same file as yesterday!");
#                                   }
#                                   else { chmod(0444, $file); }
#                               }
#                               else { chmod(0444, $file); }
                                chmod(0444, $file);
                            }
                            else
                            {
                                unlink($file);
                                &alert("download was unsuccessful!");
                            }
                        } else { &alert("system call #2: rc=$?"); }
#                   } else { &alert("could not match the desired URL!"); }
#               } else { &alert("could not read file '$temp'!"); }
#           } else { &alert("file '$temp' is empty!"); }
#           unlink($temp);
#       } else { &alert("file '$temp' does not exist!"); }
#   } else { &alert("system call #1: rc=$?"); }
} # else { &alert("file '$file' already exists!"); }

$count++;
}

exit;

sub alert
{
    print STDERR "$self ($date): $_[0]\n";
}

__END__

