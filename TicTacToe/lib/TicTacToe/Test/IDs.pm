package TicTacToe::Test::IDs;
use 5.026;
use strict;

=head1 NAME

TicTacToe::Test::IDs - Generate a pseduorandom sequence of numeric IDs for
testing.

=head1 SYNOPSIS

    use TicTacToe::Test::IDs;

    my $id_generator = TicTacToe::Test::IDs->new();

    my $some_id = $id_generator->next;
    my $another_id = $id_generator->next;
    my @ten_more_ids = $id_generator->next(10);

    # An arrayref of all of the previously returned IDs.
    my $expected_ids = $id_generator->all_ids;

=cut


=head1 CONSTRUCTOR

=head2 new

Instantiate a new ID generator.

=cut

sub new {
    my $class = shift;
    $class = ref $class || $class;
    my $obj = {
        all_ids => [],
        seen_ids => {},
    };
    return bless $obj, $class;
}


=head1 METHODS

=head2 next($count)

Returns one or more unique, pseudorandom IDs.

By default, returns a single ID.

    my $id = $id_generator->next;

If C<$count> is specified, returns that many IDs. (Count may be C<0>
to return an empty array. A C<$count> of C<undef> also produces an
empty array.)

    my @ids = $id_generator->next($count);

If assigned to a scalar, only the first requested ID will be returned,
or C<undef> if no IDs were requested.

=cut

sub next {
    my $self = shift;
    my $count = !@_ ? 1 : shift;

    my $all_ids = $self->{all_ids};
    my $seen_ids = $self->{seen_ids};

    my @ids;
    for ( my $i ; $i < $count ; $i++ ) {
        my $id;
        do {
            $id = int( rand(0x800000) );
        } until !$seen_ids->{$id};
        $seen_ids->{$id} = 1;

        push @ids, $id;
        push @$all_ids, $id;
    }

    return @ids if wantarray;
    return $ids[0];
}


=head2 all_ids

Returns an arrayref containing all ids output by this array generator.

=cut

sub all_ids {
    my $self = shift;
    return $self->{all_ids};
}


1;
