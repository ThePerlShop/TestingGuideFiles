package t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs;
use 5.026;
use strict;
use warnings;

use parent 'Exporter';

our @EXPORT = qw();

our @EXPORT_OK = qw(
    @BOARD_EMPTY @BOARD_X @BOARD_XO @BOARD_DRAW
    @BOARD_X_WINS_COL_0 @BOARD_O_WINS_COL_1 @BOARD_X_WINS_COL_2
    @BOARD_X_WINS_ROW_0 @BOARD_O_WINS_ROW_1 @BOARD_O_WINS_ROW_2
    @BOARD_X_WINS_BACKSLASH @BOARD_O_WINS_SLASH
);

our %EXPORT_TAGS = (
    moves => [qw(
        @BOARD_EMPTY @BOARD_X @BOARD_XO @BOARD_DRAW @BOARD_X_WINS_COL_0
    )],
    finished => [qw(
        @BOARD_DRAW
        @BOARD_X_WINS_COL_0 @BOARD_O_WINS_COL_1 @BOARD_X_WINS_COL_2
        @BOARD_X_WINS_ROW_0 @BOARD_O_WINS_ROW_1 @BOARD_O_WINS_ROW_2
        @BOARD_X_WINS_BACKSLASH @BOARD_O_WINS_SLASH
    )],
);


use Readonly;


=head1 NAME

t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs - read-only board
configurations, for use in unit tests of L<TicTacToe::BusinessLogic::Game>.

=head1 SYNOPSIS

    use t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs qw(@BOARD_EMPTY);

    cmp_deeply($board, @BOARD_EMPTY);

    cmp_deeply(
        $board,
        @t::lib::TicTacToe::BusinessLogic::Game::BoardConfigs::BOARD_X,
    );

=head1 DESCRIPTION

This module contains a number of game-board configurations in read-only
arrays. Any of these arrays may be exported, or may be referenced using
a fully-qualified package path.

By default B<no> symbols are exported.

This module uses C<Exporter> and supports all of its features.

=head1 EXPORT TAGS

The following tags can be used to export groups of board symbols.

=head2 :moves

Board configurations used in testing move logic. These are
C<@BOARD_EMPTY>, C<@BOARD_X>, C<@BOARD_XO>, C<@BOARD_DRAW>, and
C<@BOARD_X_WINS_COL_0>.

=head2 :finished

Board configurations of finished games, that is, those with no more
legal moves. These are C<@BOARD_DRAW> and all the winning boards.

=cut


=head1 SIMPLE BOARDS 

=head2 @BOARD_EMPTY

An empty board (the initial board state).

=cut

Readonly::Array our @BOARD_EMPTY =>
    ( ' ', ' ', ' ',
      ' ', ' ', ' ',
      ' ', ' ', ' ' );


=head2 @BOARD_X

A board with X in location 0, but otherwise empty.

=cut

Readonly::Array our @BOARD_X =>
    ( 'X', ' ', ' ',
      ' ', ' ', ' ',
      ' ', ' ', ' ' );


=head2 @BOARD_XO

A board with X in location 0, O in location 1, and all other locations
empty.

=cut


Readonly::Array our @BOARD_XO =>
    ( 'X', 'O', ' ',
      ' ', ' ', ' ',
      ' ', ' ', ' ' );


=head2 @BOARD_DRAW

A board with no empty spaces but with no winner.

=cut

Readonly::Array our @BOARD_DRAW =>
    ( 'X', 'O', 'X',
      'X', 'O', 'O',
      'O', 'X', 'X' );


=head1 WINNING BOARDS

=head2 @BOARD_X_WINS_COL_0

A board in which X has won by filling column 0.

This board has empty spaces at locations 5 and 7.

=cut

Readonly::Array our @BOARD_X_WINS_COL_0 =>
    ( 'X', 'O', 'O',
      'X', 'X', ' ',
      'X', ' ', 'O' );


=head2 @BOARD_O_WINS_COL_1

A board in which O has won by filling column 1.

This board has empty spaces at locations 

=cut

Readonly::Array our @BOARD_O_WINS_COL_1 =>
    ( 'X', 'O', 'X',
      'X', 'O', ' ',
      ' ', 'O', ' ' );


=head2 @BOARD_X_WINS_COL_2

A board in which X has won by filling column 2.

This board has empty spaces at locations 0, 3, 6, and 7.

=cut

Readonly::Array our @BOARD_X_WINS_COL_2 =>
    ( ' ', 'O', 'X',
      ' ', 'O', 'X',
      ' ', ' ', 'X' );


=head2 @BOARD_X_WINS_ROW_0

A board in which X has won by filling row 0.

This board has empty spaces at locations 3, 5, 7, and 8.

=cut

Readonly::Array our @BOARD_X_WINS_ROW_0 =>
    ( 'X', 'X', 'X',
      ' ', 'O', ' ',
      'O', ' ', ' ' );


=head2 @BOARD_O_WINS_ROW_1

A board in which O has won by filling row 1.

This board has an empty space at location 7.

=cut

Readonly::Array our @BOARD_O_WINS_ROW_1 =>
    ( 'X', 'X', 'O',
      'O', 'O', 'O',
      'X', ' ', 'X' );


=head2 @BOARD_O_WINS_ROW_2

A board in which O has won by filling row 2.

This board has empty spaces at locations 1, 3, and 5.

=cut

Readonly::Array our @BOARD_O_WINS_ROW_2 =>
    ( 'X', ' ', 'X',
      ' ', 'X', ' ',
      'O', 'O', 'O' );


=head2 @BOARD_X_WINS_BACKSLASH

A board in which X has won by filling diagonal upper-left to
lower-right.

This board has empty spaces at locations 2, 3, 6, and 7.

=cut

Readonly::Array our @BOARD_X_WINS_BACKSLASH =>
    ( 'X', 'O', ' ',
      ' ', 'X', 'O',
      ' ', ' ', 'X' );


=head2 @BOARD_O_WINS_SLASH

A board in which O has won by filling diagonal upper-right to
lower-left.

This board has empty spaces at locations 5, 7, and 8.

=cut

Readonly::Array our @BOARD_O_WINS_SLASH =>
    ( 'X', 'X', 'O',
      'X', 'O', ' ',
      'O', ' ', ' ' );


1;
