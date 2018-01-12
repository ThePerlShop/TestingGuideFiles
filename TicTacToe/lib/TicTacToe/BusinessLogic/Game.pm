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

=cut

sub move {
    my $self = shift;
    my ($piece, $location) = @_;

    die "move to invalid location: $location\n"
        unless $location < 9;
    die "move to invalid location: $location\n"
        unless $location >= 0;

    $self->board->[$location] = $piece;
}


__PACKAGE__->meta->make_immutable;

1;
