package App::Hachero::Plugin::Filter::URI;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use URI::QueryParam;

sub filter :Hook {
    my ($self, $context) = @_;
    my $req = $context->currentinfo->{request}->{uri};
    my $config = $self->config->{config};
    my $include = 0;
    for my $set (@$config) {
        my ($type, $value) = each %$set;
        my $match = 1;
        if (ref $value eq 'HASH') {
            my ($meth, $rule) = each %$value;
            my @r = $req->$meth;
            my $result = scalar @r == 1 ? $r[0] : {@r};
            if (ref $rule eq 'Regexp') {
                $match = ($result =~ $rule);
            } elsif (ref $rule eq 'HASH') {
                for my $key (keys %$rule) {
                    unless ($result->{$key} && ($result->{$key} eq $rule->{$key})) {
                        $match = 0;
                        last;
                    }
                }
            } else {
                $match = ($result eq $rule);
            }
        } # else => [include|exclude]: all
        if ($match) {
            $include = $type eq 'include' ? 1 : 0;
        }
    }
    unless ($include) {
        $context->currentline('');
        $context->log(debug => 'skip');
    }
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Filter::URI - includes/excludes requests in specified uri

=head1 SYNOPSYS

  ---
  plugins:
    - module: Filter::URI
      config:
        - exclude: all
        - include:
            path: !!perl/regexp (?-xism:^/some/path)
        - exclude:
            query_form:
                ref: rss

=head1 DESCRIPTION

excludes requests in specified time.

=head2 implemented hooks

=over 4
    
=item * filter

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
