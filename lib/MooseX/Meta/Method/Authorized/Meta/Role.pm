package MooseX::Meta::Method::Authorized::Meta::Role;
use aliased 'MooseX::Meta::Method::Authorized::Application::ToInstance';
use aliased 'MooseX::Meta::Method::Authorized::Application::ToComposite';
use Moose::Role;
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter->setup_import_methods(also => 'Moose::Role');

sub init_meta {
    my ($class, %opts) = @_;#

    Moose::Role->init_meta(%opts);

    Moose::Util::MetaRole::apply_metaroles
      (
       for            => $opts{for_class},
       role_metaroles =>
       {
        application_to_instance       => [ ToInstance ],
        application_to_role_summation => [ ToComposite ],
       }
      );

    return $opts{for_class}->meta();
}


1;
