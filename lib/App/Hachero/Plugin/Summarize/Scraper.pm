package App::Hachero::Plugin::Summarize::Scraper;
use strict;
use warnings;
use base qw(App::Hachero::Plugin::Base);
use URI;
use Web::Scraper;

sub summarize :Hook {
    my ($self, $context) = @_;

    my $config = $self->config->{config};
    my $scraper = scraper {
        process @{$config->{scraper}->{process}};
        result $config->{scraper}->{result};
    };

    for my $r ($context->result->{$config->{result_key}}->values) {
        my $uri = $r->{$config->{result}->{uri_from}};
        $uri = URI->new($uri) unless ref $uri;
        for my $meth (keys %{$config->{uri}}) {
            $uri->$meth($config->{uri}->{$meth});
        }
        my $result = $scraper->scrape($uri) or next;
        $r->{$config->{result}->{result_to}} = $result;
    }
}

1;
__END__

=pod

=head1 NAME

App::Hachero::Plugin::Summarize::Scraper - gets title or something via Web::Scraper

=head1 SYNOPSIS

  ---
  plugins:
    - module: Summarize::Scraper
      config:
        result_key: URI
        result:
            uri_from: path
            result_to: title
        uri:
            host: 'www.example.com'
        scraper:
            process: 
                - '//title'
                - 'title'
                - 'TEXT'
            result: 'title'

=head1 DESCRIPTION

gets title or something via Web::Scraper

=head2 implemented hooks

=over 4

=item * initialize

=item * summarize

=back

=head1 AUTHOR

Nobuo Danjou <nobuo.danjou@gmail.com>

=head1 SEE ALSO

L<Web::Scraper>

L<App::Hachero>

L<App::Hachero::Result>

=cut
