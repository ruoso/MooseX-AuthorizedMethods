package MooseX::AuthorizedMethods;
use Moose ();
use Moose::Exporter;
use aliased 'MooseX::Meta::Method::Authorized';
use Sub::Name;

our $VERSION = 0.003;

Moose::Exporter->setup_import_methods
  ( with_meta => [ 'authorized' ],
    also      => [ 'Moose' ],
  );


my $method_metaclass = Moose::Meta::Class->create_anon_class
  (
   superclasses => ['Moose::Meta::Method'],
   roles => [ Authorized ],
   cache => 1,
  );

sub authorized {
    my ($meta, $name, $requires, $code, %extra_options) = @_;

    my $m = $method_metaclass->name->wrap
      (
       subname(join('::',$meta->name,$name),$code),
       package_name => $meta->name,
       name => $name,
       requires => $requires,
       %extra_options,
      );

    $meta->add_method($name, $m);
}

1;


__END__

=head1 NAME

MooseX::AuthorizedMethods - Syntax sugar for authorized methods

=head1 SYNOPSIS

  package Foo::Bar;
  use MooseX::AuthorizedMethods; # includes Moose
  
  has user => (is => 'ro');
  
  authorized foo => ['foo'], sub {
     # this is going to happen only if the user has the 'foo' role
  };

=head1 DESCRIPTION

This method exports the "authorized" declarator that will enclose
the method in a txn_do call.

=head1 DECLARATOR

=over

=item authorized $name => $code

When you declare with only the name and the coderef, the wrapper will
call 'schema' on your class to fetch the schema object on which it
will call txn_do to enclose your coderef.

=item authorized $name => $schema, $code

When you declare sending the schema object, it will store it in the
method metaclass and use it directly without any calls to this object.

NOTE THAT MIXING DECLARTIONS WITH SCHEMA AND WITHOUT SCHEMA WILL LEAD
TO PAINFULL CONFUSION SINCE THE WRAPPING IS SPECIFIC TO THAT CLASS AND
THE BEHAVIOR IS NOT MODIFIED WHEN YOU OVERRIDE THE METHOD. PREFER
USING THE DYNAMIC DECLARATOR WHEN POSSIBLE.

=back

=head1 AUTHORS

Daniel Ruoso E<lt>daniel@ruoso.comE<gt>

With help from rafl and doy from #moose.

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Daniel Ruoso et al

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
