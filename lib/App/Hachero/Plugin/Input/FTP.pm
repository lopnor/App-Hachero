package App::Hachero::Plugin::Input::FTP;
use strict;
use warnings;
use File::Temp;
use base qw(App::Hachero::Plugin::Base);
use File::Basename;
use Net::FTP;

sub initialize : Hook {
    my ($self, $context) = @_;

    my $config = $self->config->{config};
    my ($filename, $dir) = fileparse($config->{file});
    $self->{dir} = $dir;
    $self->_cwd;
    my @files = $self->{ftp}->ls;
    $self->{ftp}->quit;
    @{$self->{filelist}} = grep {$_ =~ /^$filename$/} @files;
}

sub _cwd {
    my $self = shift;
    my $config = $self->config->{config};
    $self->{ftp} = Net::FTP->new(
        Host => $config->{host},
        Port => $config->{port} || 21,
    );
    $self->{ftp}->login($config->{username}, $config->{password});
    $self->{ftp}->cwd($self->{dir});
}

sub _fetch {
    my $self = shift;
    my $filename = shift @{$self->{filelist}} or return;
    my $logfile = File::Temp->new;
    $self->_cwd;
    my $file = $self->{ftp}->get($filename, $logfile) or die;
    $self->{ftp}->quit;
    open my $fh, '<', $logfile;
    $self->{fh} = $fh;
}

sub input : Hook {
    my ($self, $context, $args) = @_;
    my $line = '';
    until ($line) {
        my $fh = $self->{fh} || $self->_fetch or return;
        $line = <$fh>;
        delete $self->{fh} unless $line;
    }
    $context->currentline( $line );
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Input::FTP - reads logs from FTP server (somehow directly)

=head1 SYNOPSYS

  ---
  plugins:
    - module: Input::FTP
      config:
        host: ftp.example.com
        port: 2121
        username: your_name
        password: your_password
        file: /path/to/your/logfile 

=head1 DESCRIPTION

reads logs from FTP server (somehow directly)

=head2 implemented hooks

=over 4

=item * input 

=back

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
