package App::Hachero::Plugin::Output::DBIC;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $schema = App::Hachero::Plugin::Output::DBIC::Schema
        ->connect(@{$self->config->{config}->{connect_info}});
    for my $key (keys %{$context->result}) {
        (my $table = $key) =~ s/\:\://g;
        for (values %{$context->result->{$key}}) {
            my $rs = eval {$schema->resultset($table)};
            $context->log(error => $!) if $@;
            if ($rs) {
                eval {
                    $rs->update_or_create($_)
                };
                if ($@) {
                    $context->log(error => $!);
                }
            } else {
                $context->log(error => "$table not found");
            }
        }
    }
}

package App::Hachero::Plugin::Output::DBIC::Schema;
use base qw(DBIx::Class::Schema::Loader);

__PACKAGE__->load_classes;

1;
