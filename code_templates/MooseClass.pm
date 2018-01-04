package <MOOSECLASS>;
use 5.026;
use Moose;
use namespace::autoclean;

extends '<SUPERCLASS>';

with '<ROLE>';

use <USED CLASS> qw(<METHOD IMPORT>);


=head1 NAME

<MOOSECLASS> - <DESCRIPTION>

=head1 SYNOPSIS

    use <MOOSECLASS>;

    ### how to use <MOOSECLASS> here

=cut


=head1 ATTRIBUTES

=head2 <ATTRIBUTE>

<DESCRIPTION OF ATTRIBUTE>

=cut

has <ATTRIBUTE> => (
);


## Private attributes.

# <DESCRIPTION OF ATTRIBUTE>
has <ATTRIBUTE> => (
);


=head1 METHODS

=head2 <METHOD>

<DESCRIPTION OF METHOD>

=cut

sub <METHOD> {
    my $self = shift;
    my ($arg1, $arg2, $arg3, %args) = @_;

}


## Private methods.

# <DESCRIPTION OF METHOD>
sub <METHOD> {
    my $self = shift;
    my ($arg1, $arg2, $arg3, %args) = @_;

}


__PACKAGE__->meta->make_immutable;

1;
