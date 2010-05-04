package MooseX::Meta::Method::Authorized;
use Moose::Role;
use Moose::Util::TypeConstraints;
use aliased 'MooseX::Meta::Method::Authorized::CheckRoles';

has requires =>
  ( is => 'ro',
    isa => 'ArrayRef',
    default => sub { [] } );

my $default_verifier = CheckRoles->new();
has verifier =>
  ( is => 'ro',
    isa => duck_type(['authorized_do']),
    default => sub { $default_verifier } );

around 'wrap' => sub {
    my ($wrap, $method, $code, %options) = @_;

    my $meth_obj;
    $meth_obj = $method->$wrap
      (
       sub {
           $meth_obj->verifier->authorized_do($meth_obj, $code, @_)
       },
       %options
      );
    return $meth_obj;
};


1;

__END__

=head1 NAME

MooseX::Meta::Method::Authorized - Authorization in method calls

=head1 DESCRIPTION

This is a parameterized role that receives the list of roles to be
checked upon method invocation. It requires the instance class to
support an "user" method, which will return an object that should
support a "roles" method that should return all the roles given to
that user.

=head1 METHOD

=over

=item wrap

This role overrides wrap so that the actual method is only invoked
after the role being checked. 

=back

=head1 ATTRIBUTES

=over

=item schema

This attribute contains a CodeRef that should return the schema
object. It can be used to pass a schema object when it can be defined
in compile-time, otherwise it will call "schema" on the object
instance to find it.

=back

=head1 SEE ALSO

L<MooseX::TransactionalMethods>, L<Class::MOP::Method>

=head1 AUTHORS

Daniel Ruoso E<lt>daniel@ruoso.comE<gt>

With help from rafl and doy from #moose.

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Daniel Ruoso et al

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
