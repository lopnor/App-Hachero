package App::Hachero::Plugin::Input::FTP;
use strict;
use warnings;
use File::Temp;
use base qw(App::Hachero::Plugin::Base);
use File::Basename;
use Net::FTP;

sub init {
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

=encoding utf8

=head1 NAME

App::Hachero::Plugin::Input::FTP - reads logs from FTP server (somehow directly)

=head1 SYNOPSYS

=head1 DESCRIPTION

=head1 IMPLEMENTED HOOKS

=head2 input 

=head1 AUTHOR

Takaaki Mizuno <cpan@takaaki.info>

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<App::Hachero>

=cut
