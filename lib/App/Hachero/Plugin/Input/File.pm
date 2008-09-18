package App::Hachero::Plugin::Input::File;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use File::Find::Rule;
use File::stat;

sub init {
    my ($self, $context) = @_;
}

sub _fetch {
    my ($self, $context) = @_;
    $self->{rule} ||= $self->_get_rule($context);
    my $file = $self->{rule}->match or return;

    if ($context->conf->{global}->{log}->{level} eq 'debug') {
        $context->log(debug => "opening file: $file");
        $self->{readsize} = 0;
        $self->{filesize} = stat($file)->size;
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
        if ($context->conf->{global}->{log}->{level} eq 'debug') {
            $self->{readsize}+= do {use bytes; length $line} if $line;
            print STDERR "\rreading file: $self->{readsize}/$self->{filesize}";
        }
        if ($line) {
#            $context->log(debug => 'the line: '. $line);
        } else {
            if ($context->conf->{global}->{log}->{level} eq 'debug') {
                print STDERR "\n";
            }
            close $self->{fh};
            delete $self->{fh};
        }
    }
    $context->currentline( $line );
}

1;
