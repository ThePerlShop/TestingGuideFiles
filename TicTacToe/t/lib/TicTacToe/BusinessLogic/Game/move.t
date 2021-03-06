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


=head1 TESTS

=head2 test_move_X_to_0

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, moves X to
location 0, and verifies that the final board state is as expected.

=cut

sub test_move_X_to_0 : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new();

    $game->move('X', 0);

    my $board = $game->board;
    cmp_deeply(
        $board,
        [ 'X', ' ', ' ',
          ' ', ' ', ' ',
          ' ', ' ', ' ' ],
        'game board with X at location 0',
    );
}


=head2 test_move_invalid_location_9

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, moves X to
location 9, and verifies that the board state does not change and that
the operation throws an "invalid location" error.

=cut

sub test_move_invalid_location_9 : Test(2) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new();

    throws_ok {
        $game->move('X', 9);
    } qr/invalid location: 9/, 'invalid location thrown';

    my $board = $game->board;
    cmp_deeply(
        $board,
        [ ' ', ' ', ' ',
          ' ', ' ', ' ',
          ' ', ' ', ' ' ],
        'game board unchanged',
    );
}


=head2 test_move_invalid_location_negative_1

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, moves X to
location -1, and verifies that the board state does not change and that
the operation throws an "invalid location" error.

=cut

sub test_move_invalid_location_negative_1 : Test(2) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new();

    throws_ok {
        $game->move('X', -1);
    } qr/invalid location: -1/, 'invalid location thrown';

    my $board = $game->board;
    cmp_deeply(
        $board,
        [ ' ', ' ', ' ',
          ' ', ' ', ' ',
          ' ', ' ', ' ' ],
        'game board unchanged',
    );
}


1;

} # BEGIN
