#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::new->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::new;
use 5.026;
use strict;
use warnings;

use parent 'TicTacToe::Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;


# load code to be tested
use TicTacToe::BusinessLogic::Game;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::new - Unit-test the
L<new|TicTacToe::BusinessLogic::Game/new> method (constructor) of
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/new.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/new.t

=cut


=head1 TESTS

=head2 test_basic_construction

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, and
verifies that constructor succeeds.

=cut

sub test_basic_construction : Test(1) {
    my $test = shift;

    ok( TicTacToe::BusinessLogic::Game->new() );
}


1;

} # BEGIN
