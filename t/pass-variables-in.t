use strict;
use warnings;
use Test::More;

use Unix::Sudo qw(sudo);

SKIP: {
    skip "You must not be running as root", 1
        if($> == 0);

    my $sudo_works = !system(
        "sudo", "-p",
        "The tests for Unix::Sudo need your password. They'll run 'whoami'\n".
        "  and some perl code as root: ",
        "true"
    );
    skip "Your sudo doesn't work", 1
        unless($sudo_works);

    my $scalar = 'foo';
    my %hash   = (
        scalar => 11,
        hash   => { yow => { wooee => 9, owie => [qw(cats and dogs)] } },
        array  => [11, { lemon => 'curry' }, [42, 41]],
        code   => sub { 4 }
    );
    my @array  = reverse @{$hash{array}};
    my $code = sub {
        eval "use Data::Compare";
        if(
            $hash{code}->() == 4 &&  # check it's passed properly
            delete($hash{code}) &&   # delete from hash because comparing coderefs is a pain
            Compare(
                [$scalar, \%hash, \@array],
                [
                    'foo',
                    {
                        scalar => 11,
                        hash   => { yow => { wooee => 9, owie => [qw(cats and dogs)] } },
                        array  => [11, { lemon => 'curry' }, [42, 41]],
                    },
                    [ [42, 41], { lemon => 'curry' }, 11],
                ]
            )
        ) { return 11; }
         else { return 94; }
    };

    is(sudo { $code->() }, 11, "Can read variables from the parent context");
}

END { done_testing }
