#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::board->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::board;
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

t::lib::TicTacToe::BusinessLogic::Game::board - Unit-test the
L<board|TicTacToe::BusinessLogic::Game/board> method of
L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/board.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/board.t

=cut


=head1 TESTS

=head2 test_board_initialized_blank

Instantiates a new C<TicTacToe::BusinessLogic::Game> object, and
verifies that its C<board> attribute returns a blank board,
an arrayref of 9 elements, each a space.

=cut

sub test_board_initialized_blank : Test(1) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new();

    my $board = $game->board;

    cmp_deeply(
        $board,
        [ ' ', ' ', ' ',
          ' ', ' ', ' ',
          ' ', ' ', ' ' ],
        'blank game board',
    );
}


1;

} # BEGIN
