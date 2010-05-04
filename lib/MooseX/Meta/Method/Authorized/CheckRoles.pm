package MooseX::Meta::Method::Authorized::CheckRoles;
use Moose;
use List::Util qw/first/;
use UNIVERSAL;

sub authorized_do {
    my $self = shift;
    my $method = shift;
    my $roles = $method->requires;
    my $code = shift;

    my ($instance) = @_;
    my $user = $instance->user;
    if (grep { my $r = $_;
               (grep { $r eq $_ } @$roles) ? 1 : 0 } $user->roles) {
        $code->(@_);
    } else {
        my $message = 'Access Denied. User';
        if ($user->can('id')) {
            $message .= ' "'.$user->id.'"';
        }
        $message .= ' does not have any of the required roles ('
          .(join ',', map { '"'.$_.'"' } @$roles)
            .') required to invoke method "'.$method->name
              .'" on class "'.$method->package_name.'". User roles are: ('
                .(join ',', map { '"'.$_.'"' } $user->roles).')';
        die $message;
    }

}

1;
