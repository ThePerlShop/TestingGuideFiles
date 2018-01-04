#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::<TEST SUBSECTION>::<CLASS UNDER TEST>::<TEST NAME>->runtests;


BEGIN {
package t::<TEST SUBSECTION>::<CLASS UNDER TEST>::<TEST NAME>;
use 5.026;
use strict;
use warnings;

use parent '<PARENT CLASS>::Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;


#use <USED CLASS> qw(<METHOD IMPORT>);


# load code to be tested
use <CLASS UNDER TEST>;


=head1 NAME

t::<TEST SUBSECTION>::<CLASS UNDER TEST>::<TEST NAME> - <DESCRIPTION>

=head1 SYNOPSIS

    # run all tests
    prove -lv t/<TEST SUBSECTION PATH>/<CLASS UNDER TEST PATH>/<TEST NAME>.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/<TEST SUBSECTION PATH>/<CLASS UNDER TEST PATH>/<TEST NAME>.t

=cut


## Private functions/methods

# <DESCRIPTION OF METHOD>
sub _<METHOD_NAME> {
    my $test = shift;
}


## Startup/shutdown/setup/teardown methods

# <DESCRIPTION OF METHOD>
sub <METHOD_NAME> : Test(startup) {
    my $test = shift;
}


## Tests

=head1 TESTS

=head2 test_<METHOD_NAME>

<DESCRIPTION OF TEST>

=cut

sub test_<METHOD_NAME> : Test(<NUMBER OF TESTS>) {
    my $test = shift;
}


1;

} # BEGIN
