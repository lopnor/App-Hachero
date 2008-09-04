package App::Hachero::Plugin::Input::File;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use DirHandle;

sub init {
    my ($self, $context) = @_;
}

sub _fetch {
    my ($self, $context) = @_;
    $self->{dh} ||= $self->_get_dirhandle($context);
    my $file;
    while (1) {
        $file = $self->{dh}->read or return;
        $file !~ /^\.{1,2}/ and last;
    }
    open my $fh, '<', File::Spec->catfile($context->work_path,$file) or die;
    $self->{fh} = $fh;
}

sub _get_dirhandle {
    my ($self, $context) = @_;
    my $work_path = $context->work_path;
    $self->{dh} = DirHandle->new($work_path);
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
