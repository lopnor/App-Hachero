package App::Hachero::Plugin::Fetch::FTP;
use strict;
use warnings;
use File::Temp;
use base qw(App::Hachero::Plugin::Base);
use File::Basename;
use Net::FTP;
use Regexp::Wildcards;
use File::Spec;

sub fetch : Hook {
    my ($self, $context, $args) = @_;
    my $config = $self->config->{config};
    my ($filename, $dir) = fileparse($config->{file});
    my $ftp = Net::FTP->new(
        Host => $config->{host},
        Port => $config->{port} || 21,
    );
    $ftp->login($config->{username}, $config->{password});
    $ftp->cwd($dir);
    my @files = $ftp->ls;
   
    my $rw = Regexp::Wildcards->new(type => 'unix');
    my $re = $rw->convert($filename);

    @files = grep {$_ =~ /^$re$/} @files;

    my $work_path = File::Spec->catfile( $context->conf->{global}->{work_path} );
    for my $file ( @files ){
        $ftp->get($file, "$work_path/$file" ) or die;
    }
    $ftp->quit;
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Fetch::FTP - fetchs logs from FTP server

=head1 SYNOPSIS

  ---
  global:
    work_path: /path/to/your/work_path
  plugins:
    - module: Fetch::FTP
      config:
        host: ftp.example.com
        port: 2121
        username: your_name
        password: your_password
        file: /path/to/your/log*

=head1 DESCRIPTION

fetchs logs from FTP server.

=head2 implemented hooks

=over 4

=item * fetch

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
