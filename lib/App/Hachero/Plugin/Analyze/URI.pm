package App::Hachero::Plugin::Analyze::URI;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use URI::QueryParam;

sub initialize :Hook {
    my ($self, $context) = @_;
    my $config = $self->config->{config};
    $self->{result_key} = $config->{result_key} || 'URI';
    my @primary = keys %{$config->{result}};
    my $r = App::Hachero::Plugin::Analyze::URI::Result->new(
        {
            primary => @primary ? [ @primary ] : ['URI']
        }
    );
    $context->result->{$self->{result_key}} = $r;
}

sub analyze :Hook {
    my ($self, $context) = @_;
    my $req = $context->currentinfo->{request}->{uri} or return;
    my $hash = $self->config->{config}->{result};
    my $result = {};
    if (keys %$hash) {
        for my $key (keys %$hash) {
            my $meth = $hash->{$key};
            if (ref $meth eq 'HASH') {
                my ($meth, $param) = %$meth;
                $result->{$key} = $req->$meth($param);
            } else {
                $result->{$key} = $req->$meth;
            }
        }
    } else {
        $result->{URI} = $req->as_string;
    }
    $context->result->{$self->{result_key}}->push( $result );
}

package # hide from PAUSE
    App::Hachero::Plugin::Analyze::URI::Result;
use base qw(App::Hachero::Result::PrimaryPerInstance);

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Analyze::URI - simple URI analyzer for App::Hachero

=head1 SYNOPSYS

  ---
  plugins:
    - module: Analyze::URI
      config:
        result_key: URI
        result:
            foo: path
            bar:
                query_form: keyword

=head1 DESCRIPTION

=head2 implemented hooks

=over 4

=item * analyze

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<App::Hachero::Result>

=cut
