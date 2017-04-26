#!/usr/bin/perl
#

use strict;
use warnings;

use DBI;
use Data::Dumper;

# import configuration
# TODO: this should be non-perl
our $MYSQL_USER = undef;
our $MYSQL_PASS = undef;
our $CONTROL_DIR = undef;
our $ICES_PID = undef;
require "parameters.pl";

die "no CONTROL_DIR defined" if(!$CONTROL_DIR);

my $DBH = DBI->connect("DBI:Pg:dbname=sixsr",
                       $MYSQL_USER,$MYSQL_PASS) || 
                       die $DBI::errstr;

my $prev_content_id = -1;
my $n_idx = 0;

sub link_content($) {
    my $nc = shift;

    if ($nc->{content_id} == $prev_content_id) {
        print("content id $prev_content_id still playing, no change\n");
        return;
    }

    $prev_content_id = $nc->{content_id};

    if ($nc->{preempt} == 1) {
        # clear the control dir in preparation for interruption
        print("got preempt, clearing control dir\n");
        unlink glob $CONTROL_DIR."/*";
        $n_idx = 0;
    }

    printf("Got new content ->\n".Dumper($nc)."\n");

    print("symlink ".$nc->{uri}." -> $CONTROL_DIR/$n_idx.ogg\n");
    my $dlink = $CONTROL_DIR."/$n_idx.ogg";
    unlink($dlink);
    symlink($nc->{uri}, $CONTROL_DIR."/$n_idx.ogg");
    $n_idx++;

    if ($nc->{preempt} == 1) {
        if ($ICES_PID) {
            print("sending HUP to $ICES_PID\n");
            kill('HUP', $ICES_PID);
        }
    }
}

while(1) {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
    my $ncontent = $DBH->selectrow_hashref("call get_content_at (\"$hour:$min\");");

    printf("Checking at %02d:%02d:%02d\n", $hour, $min, $sec);

    link_content($ncontent);

    # run approximately once every $SLSEC seconds
    my $SLSEC = 60;
    my $slp = $SLSEC - ($sec % $SLSEC);
    print("sleeping $slp seconds\n");
    sleep($slp);
    print("----------------------------------------\n");
}
