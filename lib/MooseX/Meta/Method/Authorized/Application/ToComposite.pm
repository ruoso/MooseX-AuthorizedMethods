package MooseX::Meta::Method::Authorized::Application::ToComposite;
use Moose::Role;

sub apply {
    use Data::Dumper;
    die Data::Dumper->Dump(\@_);
}

1;
