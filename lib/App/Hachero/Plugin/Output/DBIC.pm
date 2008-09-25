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

package App::Hachero::Plugin::Output::DBIC::Schema;
use base qw(DBIx::Class::Schema::Loader);

__PACKAGE__->load_classes;

1;
