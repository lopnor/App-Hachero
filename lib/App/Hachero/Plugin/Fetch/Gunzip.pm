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
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Fetch::Gunzip - gunzips '*.gz' files in work_path

=head1 SYNOPSIS

  ---
  global:
    work_path: /path/to/your/work_path
  plugins:
    - module: Fetch::Gunzip

=head1 DESCRIPTION

Gunzips '*.gz' files in work_path.

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
