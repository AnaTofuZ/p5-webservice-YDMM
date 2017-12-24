requires 'Encode';
requires 'HTTP::Tiny';
requires 'IO::Socket::SSL';
requires 'JSON';
requires 'URI';
requires 'perl', '5.008001';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
};
