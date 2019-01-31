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

    my($file, $line) = (__FILE__, 1 + __LINE__);
    eval { sudo { non_existent() }};
    like(
        $@,
        qr/Your code didn't compile.* at $file line $line\b/,
        "Uncompilable code dies correctly"
    );
}

END { done_testing }
