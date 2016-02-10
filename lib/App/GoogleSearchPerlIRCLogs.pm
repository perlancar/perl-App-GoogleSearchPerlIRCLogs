package App::GoogleSearchPerlIRCLogs;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::Any::IfLOG '$log';

our %SPEC;

my $cur_year = (localtime)[5] + 1900;

$SPEC{google_search_perl_irc_logs} = {
    v => 1.1,
    summary => 'Search Google for stuffs in Perl IRC logs',
    description => <<'_',

Currently searching with `site:irclog.perlgeek.org`.

_
    args => {
        query => {
            schema => ['array*', of => 'str*'],
            req => 1,
            pos => 0,
            greedy => 1,
        },
        year => {
            schema => ['int*', min=>1990, max=>$cur_year],
            cmdline_aliases => {y=>{}},
        },
        # XXX channel, limit site to irclog.perlgeek.de/CHANNEL/
    },
    examples => [
        {
            summary => 'Who mentions me?',
            src => 'google-search-perl-irc-logs perlancar',
            src_plang => 'bash',
            test => 0,
            'x.doc.show_result' => 0,
        },
        {
            summary => 'Who mentions me in 2016?',
            src => 'google-search-perl-irc-logs perlancar -y 2016',
            src_plang => 'bash',
            test => 0,
            'x.doc.show_result' => 0,
        },
    ],
};
sub google_search_perl_irc_logs {
    require Browser::Open;
    require URI::Escape;

    my %args = @_;

    my $query = join(
        " ",
        "site:irclog.perlgeek.de",
        @{$args{query}},
        ($args{year} ? ("inurl:/$args{year}") : ()),

        # skip text/raw version
        qq(-inurl:/text),
    );

    my $url = "https://www.google.com/search?num=100&q=".
        URI::Escape::uri_escape($query);

    my $res = Browser::Open::open_browser($url);

    $res ? [500, "Failed"] : [200, "OK"];
}

1;
#ABSTRACT:

=head1 SYNOPSIS

Use the included script L<google-search-perl-irc-logs>.
