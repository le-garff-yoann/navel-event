# Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras
# navel-event is licensed under the Apache License, Version 2.0

#-> BEGIN

#-> initialization

package Navel::Event 0.1;

use Navel::Base;

use constant {
    I_STATUS => 0,
    I_TIME => 1,
    I_COLLECTION => 2,
    I_DATA => 3
};

use Navel::Event::Status;
use Navel::Utils qw/
    croak
    :sereal
    blessed
    isint
 /;

#-> class variables

my $decode_sereal_constructor = decode_sereal_constructor();

my $encode_sereal_constructor = encode_sereal_constructor();

#-> methods

sub deserialize {
    my ($class, $event) = (shift, $decode_sereal_constructor->decode(shift));

    croak('event must be a array') unless ref $event eq 'ARRAY';

    $class->new(
        status => $event->[I_STATUS],
        time => $event->[I_TIME],
        collection => $event->[I_COLLECTION],
        data => $event->[I_DATA]
    );
}

sub new {
    my ($class, %options) = @_;

    bless {
        status => blessed($options{status}) && $options{status}->isa('Navel::Event::Status') ? $options{status} : Navel::Event::Status->new($options{status}),
        time => isint($options{time}) ? $options{time} : time,
        collection => length $options{collection} ? $options{collection} : croak('collection length must be superior to 0'),
        data => $options{data}
    }, ref $class || $class;
}

sub serialize {
    my $self = shift;

    my @event;

    $event[I_STATUS] = $self->{status}->{status};
    $event[I_TIME] = $self->{time};
    $event[I_COLLECTION] = $self->{collection};
    $event[I_DATA] = $self->{data};

    $encode_sereal_constructor->encode(\@event);
}

# sub AUTOLOAD {}

# sub DESTROY {}

1;

#-> END

__END__

=pod

=encoding utf8

=head1 NAME

Navel::Event

=head1 COPYRIGHT

Copyright (C) 2015-2016 Yoann Le Garff, Nicolas Boquet and Yann Le Bras

=head1 LICENSE

navel-event is licensed under the Apache License, Version 2.0

=cut
