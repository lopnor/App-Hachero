package App::Hachero::Plugin::Output::DBIC;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $schema = App::Hachero::Plugin::Output::DBIC::Schema
        ->connect(@{$self->config->{config}->{connect_info}});
    unless ($schema) {
        $context->log(error => "connection error");
        return;
    }
    for my $key (keys %{$context->result}) {
        (my $table = $key) =~ s/\:\://g;
        my $rs = eval {$schema->resultset($table)};
        if ($@) {
            $context->log(error => $!);
            next;
        }
        if ($rs) {
            my $result = $context->result->{$key};
            for my $data ($result->values) {
                eval {
                    $rs->update_or_create($data->hashref)
                };
                if ($@) {
                    $context->log(error => $!);
                }
            }
        } else {
            $context->log(error => "$table not found");
        }
    }
}

package # hide from PAUSE
    App::Hachero::Plugin::Output::DBIC::Schema;
use base qw(DBIx::Class::Schema::Loader);

__PACKAGE__->load_classes;

1;
__END__

=pod

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Output::DBIC - writes results to databases via DBIx::Class

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 IMPLEMENTED HOOKS
    
=head2 output

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<DBIx::Class::Schema::Loader>

=cut
