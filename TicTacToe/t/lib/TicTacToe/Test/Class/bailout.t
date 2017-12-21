#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

# Set RUN_BAILOUT_TESTS environment variable to actually run the tests herein.
t::lib::TicTacToe::Test::Class::bailout->SKIP_CLASS('These tests require special manual handling; set RUN_BAILOUT_TESTS=1 to run them')
    unless $ENV{RUN_BAILOUT_TESTS};

t::lib::TicTacToe::Test::Class::bailout->runtests;


BEGIN {
package t::lib::TicTacToe::Test::Class::bailout;
use 5.026;
use strict;
use warnings;

use parent 'TicTacToe::Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;


=head1 NAME

t::lib::TicTacToe::Test::Class::bailout - Unit-test
TicTacToe::Test::Class bailout functionality.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/Test/Class/bailout.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/Test/Class/bailout.t

=cut


=head1 TESTS

=head2 test_skipping_with_prefix_syntax

=cut

sub test_1_skipping_with_prefix_syntax : Test(2) {
    my $test = shift;
    pass 'test 1';
    $test->bailout() and return 'skipping test 2';
    fail 'test 2';
}


=head2 test_skipping_with_postfix_syntax

=cut

sub test_2_skipping_with_postfix_syntax : Test(2) {
    my $test = shift;
    pass 'test 1';
    return $test->bailout('skipping test 2');
    fail 'test 2';
}


=head2 test_failed_early_exit

=cut

sub test_3_failed_early_exit : Test(2) {
    my $test = shift;
    pass 'test 1';
    diag 'The following operation we expect to result in test failure.';
    return 'skipping test 2'; # This is expected to fail
    fail 'test 2';
}


1;

} # BEGIN
