package App::Hachero::Plugin::Output::DBIC;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);

sub output : Hook {
    my ($self, $context, $args) = @_;
    my $schema = App::Hachero::Plugin::Output::DBIC::Schema
        ->connect(@{$self->config->{config}->{connect_info}});
    my $update_mode = $self->config->{config}->{update_mode} || 'update';
    unless ($schema) {
        $context->log(error => "connection error");
        return;
    }
    for my $key (keys %{$context->result}) {
        (my $table = $key) =~ s/\:\://g;
        my $rs = eval {$schema->resultset(ucfirst $table)};
        if ($@) {
            $context->log(error => $!);
            next;
        }
        if ($rs) {
            my $result = $context->result->{$key};
            for my $data ($result->values) {
                eval {
                    my $hashref = $data->hashref;
                    if ( $update_mode eq 'count_up' ) {
                        my $count = delete $hashref->{count};
                        my $rec = $rs->find_or_create($hashref);
                        $rec->update({count => ($rec->count || 0) + $count});
                    } else {
                        $rs->update_or_create($hashref)
                    }
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

=head1 NAME

App::Hachero::Plugin::Output::DBIC - writes results to databases via DBIx::Class

=head1 SYNOPSYS

  ---
  plugins:
    - module: Output::DBIC
      config:
        update_mode: [count_up|overwrite]
        connect_info:
            - dbi:mysql:dbhost=db.local;dbname=logdb
            - your_name
            - your_password
        

=head1 DESCRIPTION

writes results to databases via DBIx::Class

=head2 implemented hooks

=over 4
    
=item * output

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<DBIx::Class::Schema::Loader>

=cut
