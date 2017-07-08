requires 'perl', '5.008001';
requires 'Carp';
requires 'File::Slurp';
requires 'FindBin';
requires 'List::MoreUtils';
requires 'List::Util';
requires 'Time::Piece';
requires 'YAML';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
