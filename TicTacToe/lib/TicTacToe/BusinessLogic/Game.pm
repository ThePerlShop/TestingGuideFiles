package TicTacToe::BusinessLogic::Game;
use 5.026;
use Moose;
use namespace::autoclean;


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

    die "move to invalid location: $location\n"
        unless $location >= 0 && $location < 9;

    die "move of invalid piece: $piece\n"
        unless $piece eq 'X' || $piece eq 'O';

    die "location $location is already occupied by $board->[$location]\n"
        unless $board->[$location] eq ' ';

    my $winner = $self->winner;
    die "$winner already won" if $winner;

    my $next_player = $self->next_player;
    die "$piece attempted to move, but it's ${next_player}'s turn\n"
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

    return undef if $self->winner;

    my $board = $self->board;

    my %num_on_board = (X => 0, O => 0, ' ' => 0);
    $num_on_board{$_}++ for @$board;

    return undef unless $num_on_board{' '} > 0;
    return ( $num_on_board{X} > $num_on_board{O} ) ? 'O' : 'X';
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

    return undef;
}


# If all the of elements passed in are all 'X' or 'O', return that string.
# Otherwise return undef.
sub _winning_seq {
    my $first = shift;
    return undef unless $first eq 'X' || $first eq 'O';
    while (@_) {
        return undef unless shift eq $first;
    }
    return $first;
}


__PACKAGE__->meta->make_immutable;

1;
