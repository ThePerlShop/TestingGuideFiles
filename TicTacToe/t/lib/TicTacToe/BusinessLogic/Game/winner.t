#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::winner->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::winner;
use 5.026;
use strict;
use warnings;

use parent 'TicTacToe::Test::Class';

use Test::Most;
use Carp::Always;
use Data::Dumper;

use t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs qw(:finished);


# load code to be tested
use TicTacToe::BusinessLogic::Game;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::winner - Unit-test the
L<winner|TicTacToe::BusinessLogic::Game/winner> method of
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/winner.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/winner.t

=cut


=head1 TESTS

=head2 test_draw

Instantiates a new C<TicTacToe::BusinessLogic::Game> object with a board
in which no one has won, and verifies that C<winner> returns C<undef>.

=cut

sub test_draw : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new(
        board => [@BOARD_DRAW],
    );

    my $winner = $game->winner;

    is($winner, undef, 'no one is winner');
}


=head2 test_winners

Instantiates a series of C<TicTacToe::BusinessLogic::Game> objects
initialized with boards containing the various winning combinations
(each row, each column, and each diagonal). In each case, verify that
C<winner> reports the correct player has won.

=cut

sub test_winners : Test(8) {
    my $test = shift;

    my @cases = (
        # [$name, $initial_board, $winner],
        ['X wins column 0', \@BOARD_X_WINS_COL_0, 'X'],
        ['O wins column 1', \@BOARD_O_WINS_COL_1, 'O'],
        ['X wins column 2', \@BOARD_X_WINS_COL_2, 'X'],
        ['X wins row 0', \@BOARD_X_WINS_ROW_0, 'X'],
        ['O wins row 1', \@BOARD_O_WINS_ROW_1, 'O'],
        ['O wins row 2', \@BOARD_O_WINS_ROW_2, 'O'],
        ['X wins \\ diagonal', \@BOARD_X_WINS_BACKSLASH, 'X'],
        ['O wins / diagonal', \@BOARD_O_WINS_SLASH, 'O'],
    );

    for my $case (@cases) {
        my ($name, $initial_board, $expected_winner) = @$case;

        subtest $name => sub {
            my $game = TicTacToe::BusinessLogic::Game->new(
                board => [@$initial_board],
            );

            my $got_winner = $game->winner;

            is($got_winner, $expected_winner, "$expected_winner is winner");
        };
    }
}


1;

} # BEGIN
