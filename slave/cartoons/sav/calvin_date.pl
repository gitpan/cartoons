#!/u/sb/sw/bin/perl -w

use Date::Calc qw(:all);

@Date = Today();
@Date = (1999,10,1);
@Past = Add_Delta_Days(@Date, Delta_Days(1999,6,18, 1988,6,17));
print Date_to_Text_Long(@Date), "\n";
print Date_to_Text_Long(@Past), "\n";

__END__

