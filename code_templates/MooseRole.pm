package <MOOSEROLE>;
use 5.026;
use Moose::Role;
use namespace::autoclean;

with '<ROLE>';

use <USED CLASS> qw(<METHOD IMPORT>);


=head1 NAME

<MOOSEROLE> - <DESCRIPTION>

=head1 SYNOPSIS

    use <MOOSEROLE>;

    ### how to use <MOOSEROLE> here

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


1;
