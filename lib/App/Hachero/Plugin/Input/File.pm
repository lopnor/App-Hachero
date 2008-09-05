package App::Hachero::Plugin::Input::File;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use File::Find::Rule;

sub init {
    my ($self, $context) = @_;
}

sub _fetch {
    my ($self, $context) = @_;
    $self->{rule} ||= $self->_get_rule($context);
    my $file;
    while (1) {
        $file = $self->{rule}->match or return;
        $file !~ /^\.{1,2}/ and last;
    }
    open my $fh, '<', $file or die;
    $self->{fh} = $fh;
}

sub _get_rule {
    my ($self, $context) = @_;
    my $work_path = $context->work_path;
    $self->{rule} = File::Find::Rule->file()->start( $work_path );
    return $self->{rule};
}

sub input : Hook {
    my ($self, $context, $args) = @_;
    my $line = '';
    until ($line) {
        my $fh = $self->{fh} || $self->_fetch($context) or return;
        $line = <$fh>;
        unless ($line) {
            close $self->{fh};
            delete $self->{fh};
        }
    }
    $context->currentline( $line );
}

1;
