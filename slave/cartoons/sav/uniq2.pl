#!/sw/bin/perl -w

use strict;
use vars qw( $Logfile $Archive $Source $Target %ID $Logfile @Date $ask );

use File::Find;
use File::Path;
use File::Copy;
use File::Compare;
use Date::Calc qw(:all);

$Target = "/u/sb/merge";

%ID = ();

$Logfile = $0;
$Logfile =~ s!\.+[^/\.]*$!!;
$Logfile .= ".log";

unless (open(LOG, ">$Logfile"))
{
    die "Can't write '$Logfile': $!\n";
}

select(LOG);
$| = 1;
select(STDOUT);

print LOG "------------------------------------------------------------------------------\n";
@Date = (Today_and_Now())[2,1,0,3,4,5];
$Date[1] = Month_to_Text($Date[1]);
printf(LOG "%02d-%.3s-%4d %02d:%02d:%02d\n",@Date);
print LOG "------------------------------------------------------------------------------\n";

$Archive = "/u/sb/.www/cartoons/dilbert/img";
print "Scanning '$Archive'...\n";
find(\&pass1, $Archive);

$Archive = "/u/sb/.www/cartoons/userfriendly/img";
print "Scanning '$Archive'...\n";
find(\&pass1, $Archive);

$Archive = "/u/sb/.www/cartoons/peanuts/img";
print "Scanning '$Archive'...\n";
find(\&pass1, $Archive);

$Archive = "/u/sb/.www/cartoons/calvinandhobbes/img";
print "Scanning '$Archive'...\n";
find(\&pass1, $Archive);

$Archive = "/u/sb/.www/cartoons/garfield/img";
print "Scanning '$Archive'...\n";
find(\&pass1, $Archive);

print LOG "------------------------------------------------------------------------------\n";
@Date = (Today_and_Now())[2,1,0,3,4,5];
$Date[1] = Month_to_Text($Date[1]);
printf(LOG "%02d-%.3s-%4d %02d:%02d:%02d\n",@Date);
print LOG "------------------------------------------------------------------------------\n";

print "\n";

#$Source = "D:/addfiles";
#print "Scanning '$Source'...\n";
#find(\&pass2, $Source);

#$Source = "D:/addmorefiles";
#print "Scanning '$Source'...\n";
#find(\&pass2, $Source);

print LOG "------------------------------------------------------------------------------\n";
@Date = (Today_and_Now())[2,1,0,3,4,5];
$Date[1] = Month_to_Text($Date[1]);
printf(LOG "%02d-%.3s-%4d %02d:%02d:%02d\n",@Date);
print LOG "------------------------------------------------------------------------------\n";

$Source = "E:/";

#while (1)
while (0)
{
    $ask = '';
    while ($ask !~ /^[ynYN]/)
    {
        print "Do you want to copy any additional files\n";
        print "  from '$Source'\n";
        print "    to '$Target'?\n";
        print "Answer 'yes' or 'no':\n";
        $ask = <STDIN>;
    }
    if ($ask =~ /^[yY]/)
    {
        print "Scanning '$Source'...\n";
        find(\&pass2, $Source);
    }
    else { last; }
}

print LOG "------------------------------------------------------------------------------\n";
@Date = (Today_and_Now())[2,1,0,3,4,5];
$Date[1] = Month_to_Text($Date[1]);
printf(LOG "%02d-%.3s-%4d %02d:%02d:%02d\n",@Date);
print LOG "------------------------------------------------------------------------------\n";

close(LOG);

exit;

sub pass1
{
    my($path,$name,$file) = ($File::Find::dir,$_,$File::Find::name);
    my($base,$dot,$ext,$new_name,$new_file,$length,$old_file,$cmp,$answer);

    return unless(-f $file);
    $length = -s $file;
#   if ($name =~ /^(.+?)(\.*)(gif|psd|jpe?g)$/i)
    if ($length && ($name =~ /^(.*[^\.])(\.*)([^\.]*)$/))
    {
        ($base,$dot,$ext) = ($1,$2,$3);
        chmod(0644,$file);
#       if ($dot ne '.')
        if (($dot ne '.') && ($ext ne ''))
        {
            $new_name = "$base.$ext";
            $new_file = "$path/$new_name";
            print "Renaming '$name' to '$new_name'...\n";
            if (rename($file,$new_file))
            {
                print LOG "Renamed '$file' to '$new_file'.\n";
                $name = $new_name;
                $file = $new_file;
            }
            else
            {
                warn "Could not rename '$name' to '$new_name': $!\n";
                print LOG "Could not rename '$file' to '$new_file': $!\n";
            }
        }
#       print "File   = '$file'\n";
#       print "Length = '$length'\n";
        if ( (exists  $ID{$length}) &&
             (defined $ID{$length}) &&
             (ref     $ID{$length}) &&
             (ref     $ID{$length} eq 'HASH') &&
             (keys  %{$ID{$length}}) )
        {
            foreach $old_file (keys %{$ID{$length}})
            {
                $cmp = compare($old_file,$file);
                if ($cmp == 0)
                {
                    $answer = -1;
                    while (($answer < 0) || ($answer > 3))
                    {
                        print LOG "File '$old_file'\n";
                        print LOG " and '$file'\n";
                        print LOG " are identical.\n";
                        print "Delete which one?\n";
                        print "(0 = none, 1 = first, 2 = latter, 3 = both)\n";
#                       $answer = <STDIN>;
#                       $answer = ord($answer) - ord('0');
                        $answer = 0;
                    }
                    if ($answer > 0)
                    {
                        if ($answer & 1)
                        {
                            print "Deleting '$old_file'...\n";
                            chmod(0644,$old_file);
                            if (unlink($old_file) == 1)
                            {
                                print LOG "Deleted '$old_file'.\n";
                            }
                            else
                            {
                                warn "Could not delete '$old_file': $!\n";
                                print LOG "Could not delete '$old_file': $!\n";
                                return;
                            }
                            delete ${$ID{$length}}{$old_file};
                            unless ($answer & 2)
                            {
                                ${$ID{$length}}{$file} = 1;
                            }
                        }
                        if ($answer & 2)
                        {
                            print "Deleting '$file'...\n";
                            chmod(0644,$file);
                            if (unlink($file) == 1)
                            {
                                print LOG "Deleted '$file'.\n";
                            }
                            else
                            {
                                warn "Could not delete '$file': $!\n";
                                print LOG "Could not delete '$file': $!\n";
                                return;
                            }
                        }
                    }
                }
                elsif ($cmp == 1)
                {
                    ${$ID{$length}}{$file} = 1;
                }
                else
                {
                    print LOG "Error while comparing\n";
                    print LOG "file '$old_file'\n";
                    print LOG " and '$file'!\n";
                    print LOG "Reason: $!\n";
                    ${$ID{$length}}{$file} = 1;
                }
            }
        }
        else
        {
            ${$ID{$length}}{$file} = 1;
        }
    }
}

sub pass2
{
    my($path,$name,$file) = ($File::Find::dir,$_,$File::Find::name);
    my($base,$ext,$length,$flag,$old_file,$cmp,$new_path,$new_name,$new_file,$count);

    return unless(-f $file);
    $length = -s $file;
#   if ($name =~ /^(.+?)\.*(gif|psd|jpe?g)$/i)
    if ($length && ($name =~ /^(.+?)\.*([^\.]*)$/))
    {
        ($base,$ext) = ($1,$2);
        $flag = 1;
        if ( (exists  $ID{$length}) &&
             (defined $ID{$length}) &&
             (ref     $ID{$length}) &&
             (ref     $ID{$length} eq 'HASH') &&
             (keys  %{$ID{$length}}) )
        {
            foreach $old_file (keys %{$ID{$length}})
            {
                $cmp = compare($old_file,$file);
                if ($cmp == 0)
                {
                    $flag = 0;
                    last;
                }
                elsif ($cmp == 1)
                {
                    # files differ
                }
                else
                {
                    print LOG "Error while comparing\n";
                    print LOG "file '$old_file'\n";
                    print LOG " and '$file'!\n";
                    print LOG "Reason: $!\n";
                }
            }
        }
        if ($flag)
        {
            $new_path = $path;
            $new_path =~ s!^$Source/*!!;
            $new_path = "$Target/$new_path";
            mkpath($new_path);
            $new_name = "$base.$ext";
            $new_file = "$new_path/$new_name";
            if (-f $new_file)
            {
                $count = '000';
                $new_name = "${base}_" . ++$count . ".$ext";
                $new_file = "$new_path/$new_name";
                while (-f $new_file)
                {
                    $new_name = "${base}_" . ++$count . ".$ext";
                    $new_file = "$new_path/$new_name";
                }
            }
            print "Copying '$file'\n";
            print "     to '$new_file'...\n";
            if (copy($file,$new_file))
            {
                print LOG "Copied '$file' to '$new_file'.\n";
                ${$ID{$length}}{$new_file} = 1;
            }
            else
            {
                warn "Could not copy '$file'\n";
                warn "            to '$new_file'!\n";
                warn "Reason: $!\n";
                print LOG "Could not copy '$file'\n";
                print LOG "            to '$new_file'!\n";
                print LOG "Reason: $!\n";
            }
        }
    }
}

__END__

