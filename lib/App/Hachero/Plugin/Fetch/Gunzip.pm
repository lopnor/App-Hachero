package App::Hachero::Plugin::Fetch::Gunzip;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use IO::Uncompress::Gunzip qw(gunzip $GunzipError);
use File::Basename;
use File::Spec::Functions;
use File::Find::Rule;

sub fetch : Hook {
    my ($self, $context, $args) = @_;
    my $config = $self->config->{config};
    my $work_path = $context->conf->{global}->{work_path};

    my @files = File::Find::Rule->file()
                               ->name('*.gz')
                               ->in($work_path);
    
    for my $file (@files) {
        my $dest = catfile($work_path, basename($file, '.gz'));
        if (gunzip $file => $dest) {
            unlink $file;
        } else {
            $context->log(error => "extraction of $file failed: $GunzipError");
            next;
        }
    }
}

1;
