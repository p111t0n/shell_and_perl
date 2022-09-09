#!/usr/bin/perl

# this script creates one file and deletes all files older than 1 min in the current directory

use File::Find;
use Cwd qw();
use Sys::Syslog qw(:DEFAULT :standard :macros);

# get current dir
my $deletedir = Cwd::cwd();

#create new file
open my $fh, '>', 'output.txt';
print {$fh} "some random text" . "\n" ;
close $fh;

# delete files older than 60s
my @file_list;
my @find_dir = ($deletedir); # directories to search
my $ctime = time();          # get current time
my $age = 60;                # age in seconds to go back
find ( sub {
  my $file = $File::Find::name;
  if ( -f $file ) {
    push (@file_list, $file);
  }
}, @find_dir);

for my $file (@file_list) {
  my @stats = stat($file);
  if ($ctime-$stats[9] > $age) {
    unlink $file;
  }
}

# write to syslog
openlog("", 'ndelay', 'local2');
syslog('info', "One file created in %s directory!", $deletedir);
syslog('info', "Files older than 60s deleted from the %s directory!", $deletedir);
closelog( );

