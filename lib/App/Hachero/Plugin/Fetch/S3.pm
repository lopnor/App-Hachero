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
