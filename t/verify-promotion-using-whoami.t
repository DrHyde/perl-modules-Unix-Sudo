use strict;
use warnings;
use Test::More;

use Capture::Tiny qw(capture);

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

    my($stdout, $stderr, $rv) = capture {
        sudo {
            eval "no tainting;";
            print `whoami`;
        }
    };
    chomp($stdout);
    is($stdout, 'root', "ran 'whoami' as root");
}

END { done_testing }
