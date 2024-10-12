#!/usr/bin/perl -W

use strict;
use warnings;

use CGI;
use File::Spec;
use URI::Escape;


my $q           = CGI->new();

my $file        = $q->param('file');
my @fileset     = $q->multi_param('fileset');

if( defined( $file ) ) {
  $file = File::Spec->rel2abs( 
    uri_unescape( $file ),
    '/'
  );
} else {
  for my $f ( keys( @fileset ) ) {
    $fileset[$f] = File::Spec->rel2abs( 
      uri_unescape( $fileset[$f] ),
      '/' 
    );
  }
}

if( defined( $file ) ) {
  @fileset = ( $file );
}

print( "Content-type:video/mp4\n\n" );
for my $file ( sort( @fileset ) ) {
  # https://github.com/fluent-ffmpeg/node-fluent-ffmpeg/issues/346
  system( "ffmpeg -loglevel fatal -i /storage/bittorrent/content/$file -f mp4 -c:v h264 -c:a aac -movflags frag_keyframe+empty_moov -" );
}
