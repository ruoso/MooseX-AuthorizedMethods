package MooseX::Meta::Method::Authorized::Meta::Role;
use aliased 'MooseX::Meta::Method::Authorized::Application::ToInstance';
use Moose::Role;
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter->setup_import_methods(also => 'Moose::Role');

sub init_meta {
    my ($class, %opts) = @_;
    my $meta = Moose::Role->init_meta(%opts);

    return Moose::Util::MetaRole::apply_metaroles
      (
       for_class                           => $meta,
       application_to_instance_class_roles => [ ToInstance ],
      );
}


1;
