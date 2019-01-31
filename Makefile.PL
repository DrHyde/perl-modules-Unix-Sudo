use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Unix::Sudo',
    META_MERGE => {
        license => 'open_source',
        resources => {
            repository => 'https://github.com/DrHyde/perl-modules-Unix-Sudo',
            bugtracker => 'https://github.com/DrHyde/perl-modules-Unix-Sudo/issues'
        }
    },
  VERSION_FROM => 'lib/Unix/Sudo.pm',
  PREREQ_PM    => {
    'B::Deparse'     => 0,
    'Capture::Tiny', => 0,
    'Data::Dumper'   => 0,
    'PadWalker'      => 0,
    'Probe::Perl',   => 0,
    'Test::More'     => '0.88', # need done_testing (0.88)
    'tainting'       => 0,
  },
);
