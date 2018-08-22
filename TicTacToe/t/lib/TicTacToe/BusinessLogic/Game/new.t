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

use t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs qw(:invalid);


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


=head2 test_board_initialized_invalid

Instantiates new C<TicTacToe::BusinessLogic::Game> objects, specifying
initial board states, but ones that are invalid. Verifies that the
constructor throws an appropriate error for each condition.

The error conditions tested are as follows:

=over

=item 1.

A board that is not an arrayref.

=item 2.

A board with fewer than 9 spaces.

=item 3.

A board with more than 9 spaces.

=item 4.

A board with at least one space that is neither C<'X'>, C<'O'>, nor C<' '>.

=item 5.

A board with more 'O' than 'X' (meaning that 'O' has gone too many times).

=item 6.

A board with two more 'X' than 'O' (meaning that 'X' has gone too many times).

=back

=cut

sub test_board_initialized_invalid : Tests() {
    my $test = shift;

    my @cases = (
        {
            description => 'not an arrayref',
            board => 'NOT AN ARRAYREF',
            error => qr/value is not an arrayref/,
        },
        {
            description => 'fewer than 9 spaces',
            board => \@BOARD_INVALID_SHORT_ARRAY,
            error => qr/arrayref does not have exactly 9 items/,
        },
        {
            description => 'more than 9 spaces',
            board => \@BOARD_INVALID_LONG_ARRAY,
            error => qr/arrayref does not have exactly 9 items/,
        },
        {
            description => 'invalid player piece',
            board => \@BOARD_INVALID_WRONG_PIECE,
            error => qr/'A' is an invalid player piece/,
        },
        {
            description => 'X has moved out of turn',
            board => \@BOARD_INVALID_TOO_MANY_X,
            error => qr/'X' has moved out of turn/,
        },
        {
            description => 'O has moved out of turn',
            board => \@BOARD_INVALID_TOO_MANY_O,
            error => qr/'O' has moved out of turn/,
        },
    );

    for my $case (@cases) {
        subtest $case->{description} => sub {
            throws_ok {
                TicTacToe::BusinessLogic::Game->new(
                    board => $case->{board},
                )
            } $case->{error}, "throws $case->{error}";
        };
    }
}


1;

} # BEGIN
