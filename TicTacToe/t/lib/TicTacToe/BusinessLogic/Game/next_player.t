#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::next_player->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::next_player;
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

t::lib::TicTacToe::BusinessLogic::Game::next_player - Unit-test the
L<next_player|TicTacToe::BusinessLogic::Game/next_player> method of
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/next_player.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/next_player.t

=cut


=head1 TESTS

=head2 test_next_players

Instantiates a series of C<TicTacToe::BusinessLogic::Game> objects
initialized with boards at various stages of play. Verify that
C<next_player> returns the expected piece.

=cut

sub test_next_players : Test(3) {
    my $test = shift;

    my @cases = (
        # [$name, $initial_board, $next_player],
        ['empty board', \@BOARD_EMPTY, 'X'],
        ['X has played', \@BOARD_X, 'O'],
        ['O has played', \@BOARD_XO, 'X'],
    );

    for my $case (@cases) {
        my ($name, $initial_board, $expected_next_player) = @$case;

        subtest $name => sub {
            my $game = TicTacToe::BusinessLogic::Game->new(
                board => [@$initial_board],
            );

            my $got_next_player = $game->next_player;

            is(
                $got_next_player,
                $expected_next_player,
                "next player is $expected_next_player",
            );
        };
    }
}


=head2 test_game_already_won

Instantiates a new C<TicTacToe::BusinessLogic::Game> object with a board
in which the game has already been won, and verifies that C<next_player>
returns C<undef>.

=cut

sub test_game_already_won : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new(
        board => [@BOARD_X_WINS_COL_0],
    );

    my $next_player = $game->next_player;

    is($next_player, undef, 'no next player');
}


=head2 test_game_draw

Instantiates a new C<TicTacToe::BusinessLogic::Game> object with a board
in which the game has ended without a winner, and verifies that
C<next_player> returns C<undef>.

=cut

sub test_game_draw : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new(
        board => [@BOARD_DRAW],
    );

    my $next_player = $game->next_player;

    is($next_player, undef, 'no next player');
}


1;

} # BEGIN
