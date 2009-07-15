package App::Hachero::Plugin::Fetch::S3;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use Net::Amazon::S3;
use File::Basename;
use File::Spec::Functions;

sub fetch : Hook {
    my ($self, $context, $args) = @_;
    my $config = $self->config->{config};
    my $work_path = $context->conf->{global}->{work_path};

    my $s3 = Net::Amazon::S3->new(
        {
            aws_access_key_id => $config->{aws_access_key_id},
            aws_secret_access_key => $config->{aws_secret_access_key},
            timeout => 6000,
            retry => 1,
        }
    ) or die "couldn't create S3 instane!";
    my $bucket = $s3->bucket($config->{bucket}) 
        or die "couldn't find bucket!: $config->{bucket}";
    my $res = $bucket->list( { prefix => $config->{prefix} } ) or return;
    for my $key (@{$res->{keys}}) {
        $key->{key} =~ m/^$config->{prefix}/ or next;
        my $dest = catfile($work_path, $key->{key});
        {
            local $@;
            for (1 .. 5) {
                eval { $bucket->get_key_filename($key->{key}, 'GET', $dest) };
                $@ or last;
                sleep $_;
            }
            die if $@;
        }
    }
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Fetch::S3 - fetchs logs from S3

=head1 SYNOPSIS

  ---
  global:
    work_path: /path/to/your/work_path
  plugins:
    - module: Fetch::S3
      config:
        aws_access_key_id: my_aws_access_key_id
        aws_secret_access_key: my_aws_secret_access_key
        bucket: my_bucket
        prefix: access_log

=head1 DESCRIPTION

fetchs logs from S3.

=head2 implemented hooks

=over 4

=item * fetch

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

L<Net::Amazon::S3>

=cut
