package TicTacToe::BusinessLogic::Game;
use 5.026;
use Moose;
use namespace::autoclean;

use Carp qw(croak);


=head1 NAME

TicTacToe::BusinessLogic::Game - A class that encompasses the gameplay
of a Tic-Tac-Toe game.

=head1 SYNOPSIS

    use TicTacToe::BusinessLogic::Game;

    my $game = TicTacToe::BusinessLogic::Game->new();

    $game->move('X', 0); # puts an 'X' in slot 0 of the board

    my $board = $game->board;
    @$board; # a list of 9 slots, each ' ', 'X', or 'O'

    my $winner = $game->winner; # 'X', 'O', or undef

=cut 


## Private methods and functions

# Counts the number of each piece on the board and returns a hashref
# mapping each piece to its number of occurrences.
sub _piece_counts {
    my $board = shift;
    my %piece_counts = (X => 0, O => 0, ' ' => 0);
    $piece_counts{$_}++ for @$board;
    return \%piece_counts;
}


# Return an appropriate error message if the board is invalid.
# Otherwise, returns false.
sub _is_invalid_board {
    my $board = shift;

    return "value is not an arrayref"
        unless ref $board eq 'ARRAY';

    return "arrayref does not have exactly 9 items"
        unless @$board == 9;

    my $piece_counts = _piece_counts($board);

    return "'$_' is an invalid player piece"
        for grep { m/[^XO ]/i } keys %$piece_counts;

    return "'X' has moved out of turn"
        if $piece_counts->{X} - $piece_counts->{O} > 1;

    return "'O' has moved out of turn"
        if $piece_counts->{O} - $piece_counts->{X} > 0;

    return ();
}


# If all the of elements passed in are all 'X' or 'O', return that string.
# Otherwise return undef (an explicit undef, not an empty list).
sub _winning_seq {
    my $first = shift;
    return (undef) unless $first eq 'X' || $first eq 'O';
    while (@_) {
        return (undef) unless shift eq $first;
    }
    return $first;
}


=head1 CONSTRUCTOR

=head2 new

Starts a new game, with the board initialized to blank. (See L</board>.)

An initial board state may be specified as a Moose attribute
initializer. Such a board state must be valid, or else the constructor
will die with an appropriate error message.

=cut

# The new() method is inherited from Moose::Object


=head1 ATTRIBUTES

=head2 board

The current state of the game board, an arrayref of nine positions, each
' ', 'X', or 'O'.

The board is conceptually arranged as three rows of three columns each
(or three columns of three rows each), but represented as a flat array
of nine spaces. (The calling code must decide how to display these
spaces to the user, but regardless of whether they are displayed
rows-first or columns-first, gameplay proceeds identically.)

This attribute is read-write, and the underlying data can be written to.
However, normally this will be modified only by the L</move> method.

=cut

has board => (
    is => 'rw',
    default => sub { [ (' ') x 9 ] },
);


around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my $args = $class->$orig(@_);

    if (exists $args->{board}) {
        my $error_message = _is_invalid_board($args->{board});
        croak "'board': $error_message" if $error_message;
    }

    return $args;
};


=head1 METHODS

=head2 move

    $game->move($piece, $location)

Place a piece on a location on the board.

Does not return a value.

=over

=item *

C<$piece> must be C<'X'> or C<'O'>, and C<$location> must be an integer
0 through 8.

=item *

The location must not already be occupied.

=item *

The player specified must not be playing out of turn. That is, judging
from the pieces already on the board, the specified player goes next and
no player has already won the game.

=back

If these rules are not followed, this method will die with an
appropriate error message.

=cut

sub move {
    my $self = shift;
    my ($piece, $location) = @_;

    my $board = $self->board;

    croak "move to invalid location: $location\n"
        unless $location >= 0 && $location < 9;

    croak "move of invalid piece: $piece\n"
        unless $piece eq 'X' || $piece eq 'O';

    croak "location $location is already occupied by $board->[$location]\n"
        unless $board->[$location] eq ' ';

    my $winner = $self->winner;
    croak "$winner already won" if $winner;

    my $next_player = $self->next_player;
    croak "$piece attempted to move, but it's ${next_player}'s turn\n"
        unless $piece eq $next_player;

    $board->[$location] = $piece;
}


=head2 next_player

    $game->next_player

Returns C<'X'> or C<'O'>, depending on who is to play next. Returns
C<undef> if the game has been won.

=cut

sub next_player {
    my $self = shift;

    return (undef) if $self->winner;

    my $board = $self->board;

    my $piece_counts = _piece_counts($board);

    return (undef) unless $piece_counts->{' '} > 0;
    return ( $piece_counts->{X} > $piece_counts->{O} ) ? 'O' : 'X';
}


=head2 winner

    $game->winner

Returns C<'X'> or C<'O'>, depending on who has won. Returns C<undef> if
no one has yet won.

=cut

sub winner {
    my $self = shift;

    my $board = $self->board;

    my @winning_seqs = (
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6],
    );

    for my $idxs (@winning_seqs) {
        my $winner = _winning_seq( @{$board}[ @$idxs ] );
        return $winner if $winner;
    }

    return (undef);
}


__PACKAGE__->meta->make_immutable;

1;
