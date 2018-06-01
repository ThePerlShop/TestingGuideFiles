#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::move->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::move;
use 5.026;
use strict;
use warnings;

use parent 'TicTacToe::Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;

use t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs qw(:moves);


# load code to be tested
use TicTacToe::BusinessLogic::Game;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::move - Unit-test the
L<move|TicTacToe::BusinessLogic::Game/move> method of
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/move.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/move.t

=cut


## Private functions and methods

# Assert that a game's board matches the specified board configuration.
sub _cmp_board {
    my ($game, $board_configuration, $description) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $board = $game->board;
    cmp_deeply(
        $board,
        $board_configuration,
        $description,
    );
}


=head1 TESTS

=head2 test_move_X_to_0

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, moves X to
location 0, and verifies that the final board state is as expected.

=cut

sub test_move_X_to_0 : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new();

    $game->move('X', 0);

    _cmp_board($game, \@BOARD_X, 'game board with X at location 0');
}


=head2 test_move_O_to_1

Instantiates a new C<TicTacToe::BusinessLogic::Game> object with a board
in which X is at location 0, moves O to location 1, and verifies that
the final board state is as expected.

=cut

sub test_move_O_to_1 : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new(
        board => [@BOARD_X],
    );

    $game->move('O', 1);

    _cmp_board($game, \@BOARD_XO, 'game board with O added at location 1');
}


=head2 test_move_invalid

Tests a number of invalid moves by instantiating a new
C<TicTacToe::BusinessLogic::Game> object with the board in an
appropriate state, attempting an invalid move, and verifying that the
board state does not change and that the operation throws an appropriate
error.

Tests the following cases:

=over

=item * Move to location 9

=item * Move to location -1

=back

=cut

# One "test" per case in @cases.
sub test_move_invalid : Test(8) {
    my $test = shift;

    my @cases = (
        # [$name, $initial_board, [$piece, $location], $error_regex],
        ['move to 9', \@BOARD_EMPTY, ['X', 9], qr/invalid location: 9/],
        ['move to -1', \@BOARD_EMPTY, ['X', -1], qr/invalid location: -1/],
        ['piece is H', \@BOARD_EMPTY, ['H', 0], qr/invalid piece: H/],
        ['move to occupied location', \@BOARD_X, ['O', 0], qr/already occupied by X/],
        ['O moves first', \@BOARD_EMPTY, ['O', 2], qr/it's X's turn/],
        ['X moves twice', \@BOARD_X, ['X', 1], qr/it's O's turn/],
        ['O moves twice', \@BOARD_XO, ['O', 2], qr/it's X's turn/],
        ['O moves after X won', \@BOARD_X_WINS_COL_0, ['O', 5], qr/X already won/],
    );

    for my $case (@cases) {
        my ($name, $initial_board, $move_args, $error_regex) = @$case;

        subtest $name => sub {
            my $game = TicTacToe::BusinessLogic::Game->new(
                board => [@$initial_board],
            );

            throws_ok {
                $game->move(@$move_args);
            } $error_regex, "throws $error_regex";

            _cmp_board($game, $initial_board, 'game board unchanged');
        }
    }
}


1;

} # BEGIN
