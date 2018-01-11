#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

use <USED CLASS> qw(<METHOD IMPORT>);

use Getopt::Long::Descriptive;

=head1 NAME

<SCRIPT NAME> - <DESCRIPTION>

=cut


# Parse command-line options and usage message
my @opts = (
    # <ADDITIONAL OPTIONS GO HERE>
    [ 'verbose|v=i' => 'Verbosity', { default => 1 } ],
    [ 'help|?' => 'Display usage information' ],
);

my ( $opt, $usage ) = describe_options( "usage: %c %o <files>", @opts );

if ( $opt->help ) {
    print $usage->text;
    exit;
}


## <SCRIPT CODE GOES HERE>


__END__
