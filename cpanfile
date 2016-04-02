requires 'Time::Piece';
requires 'Carp';
requires 'JSON';
requires 'YAML';
requires 'YAML::XS';
requires 'File::Slurp';
requires 'File::Path';
requires 'Encode';
requires 'perl', '5.008001';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Path::Tiny';
};

