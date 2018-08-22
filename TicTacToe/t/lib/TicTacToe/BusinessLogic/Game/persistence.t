#!/usr/bin/env perl
use 5.026;
use strict;
use warnings;

t::lib::TicTacToe::BusinessLogic::Game::persistence->runtests;


BEGIN {
package t::lib::TicTacToe::BusinessLogic::Game::persistence;
use 5.026;
use strict;
use warnings;

use parent (
    'TicTacToe::Test::Class',
    't::lib::TicTacToe::BusinessLogic::Game::TestContext',
);

use Test::Most;
use Carp::Always;
use Data::Dumper;

use t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs qw(@BOARD_XO);


# load code to be tested
use TicTacToe::BusinessLogic::Game;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::persistence - Unit-test the
persistence features of L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    # run all tests
    prove -lv t/lib/TicTacToe/BusinessLogic/Game/persistence.t

    # run single test method
    TEST_METHOD=test_METHOD_NAME prove -lv t/lib/TicTacToe/BusinessLogic/Game/persistence.t

=cut


=head1 TESTS


=head1 TESTS

=head2 test_new_game

Instantiates a new C<TicTacToe::BusinessLogic::Game> object with a
context, and verifies several conditions:

=over

=item * that the constructor generates a single new row (requests only
one ID),

=item * that the constructed object has the expected C<id>, and

=item * that the data record was stored as expected (and was the only
record stored).

=back

=cut

sub test_new_game : Test(3) {
    my $test = shift;

    my $game = TicTacToe::BusinessLogic::Game->new( $test->{context} );

    my $all_ids = $test->{id_generator}->all_ids;
    is( scalar(@$all_ids), 1, 'one row generated' );

    my $id = $all_ids->[0];
    is( $game->id, $id, 'ID as expected' );

    cmp_deeply(
        $test->{game_rows},
        {
            $id => {
                id => $id,
                board => $game->board,
            },
        },
        'game record stored',
    ) or note(Data::Dumper->Dump([$test->{game_rows}], ['game_rows']));
}


=head2 test_existing_game

Instantiates a new C<TicTacToe::BusinessLogic::Game> object with a
context and the ID of a game state that has already been created in
the data model, and verifies that the game is properly initialized
from the data model.

=cut

sub test_existing_game : Test(1) {
    my $test = shift;

    my $game_row = $test->{game_rs}->create( { board => \@BOARD_XO } );
    my $id = $game_row->id;

    my $game = TicTacToe::BusinessLogic::Game->new(
        $test->{context},
        id => $id,
    );

    cmp_deeply(
        $game,
        methods(
            id => $id,
            board => \@BOARD_XO,
        ),
        'game record retrieved',
    ) or note(Data::Dumper->Dump([$game], ['game']));
}


1;

} # BEGIN
