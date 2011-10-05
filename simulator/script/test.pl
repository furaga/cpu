#!/usr/bin/perl

while(<STDIN>) {
	chomp $_;
	print 'InstTyMap[';
	print $_;
	print '] = 0';
	print ';', "\n";
}
