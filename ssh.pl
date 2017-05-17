#!/usr/bin/perl -w
# Scott's ssh key inserter script.
# This will insert public keys in the current user's authorized_keys file
#
# README:
# https://github.com/scott-r-lindsey/scotts-ssh

# ------------------------------------------------------------------------------
$home               = $ENV{HOME};
$authorized_keys    = "$home/.ssh/authorized_keys";
$key_identifier     = 'SL-AUTO-SSH';

# ------------------------------------------------------------------------------
if (!-e $home . '/.ssh'){
    mkdir $home . '/.ssh', 0700;
    print "Created $home/.ssh (0700)\n";
}
if (!-e $authorized_keys){
    `>$authorized_keys`;
    chmod 0600, $authorized_keys;
    print "Created $authorized_keys (0700)\n";
}
`chmod g-w $home`;
`chmod a-w $home`;

# ------------------------------------------------------------------------------

my @lines;
my $keys = &keys();

# ------------------------------------------------------------------------------
# Read in current file, drop lines containing "SL-AUTO-SSH"
# This will avoid adding a key twice and remove any old keys
if (-e $authorized_keys){
    open AUTHKEY, $authorized_keys;
    foreach (<AUTHKEY>){
        if (!/$key_identifier/){
            chop;
            if ($_){
                push @lines, $_;
            }
        }
    }
    close AUTHKEY;
}

# ------------------------------------------------------------------------------
# This writes back the pre-existing contents of authorized_keys and any keys 
# that are listed in the keys() subroutine
open AUTHKEY, ">$authorized_keys";
foreach (@lines){
    print AUTHKEY "$_\n";
}
foreach (@$keys){
    print AUTHKEY "$_ $key_identifier\n";
}
close AUTHKEY;

print "inserted public keys in $authorized_keys\n";
# ------------------------------------------------------------------------------

sub keys{
    return [
        'ssh-dss AAAAB3NzaC1kc3MAAAEBALRT0ogrhTa5pEmQR+lDPyHQy1cWTQhef68snQOkSApQWxDQ7CCopKftKgvE4rVAMmsQ5k+Fv1TWLKXziC//Kkgd7cjMyAJn0/JHWmM62/4+ReDqdApeSP2GvjjoDp1kUneu1M/z8aOa+Z3PpZkYwpAMb3FGKpAZ4epGVbjdm89EOY+NFqNkroPKI4h/n7WB9TchJgSD376d8dhh1aGHU13p2G3fO6FQERiTGBhTHcA4ReU1dvjEJXn6RgpS3KG3ZMYDdM7ZX+ctNn8hU0GONPFUTio25rqKgeHn9uIvOx/JwVQlpp2BKA7ZVIVZseSU1e7Q+H8yzHc7uVjits2OZcEAAAAVAPDRFhQaxg0484mrp39ua9tT+GHvAAABAB0H0gZoF7v6WW7JARoREI6y3YIhWMHm5q7py77NqGi+FaQRTMgVx1fnYxJzaC17HqINSuAfqqY2BESX5LG4PtN+R09XEam6efk8bt6i9j+CGKgu0zX4gp5rldOuG0AUKrLQOkT7gSI9kUVrokkuSuDril4B2ETSzf154edX8bH87El//kYf/NUaYCdVDsYk0kWPJbY9+VB916T4Qo5Ycim9/1nr4cMqtV1bV3dQnxWISLaoUB/8VY/mqRLlZZ/1RnKJsGR6So7TMkmLxl3T9eQoZlkuIeFzKnQ4tpXJe/+GoedN87jxl1VR2wt81WxvgsLMxoxiL+uXdoimASp6vXQAAAEARzxcKTtNZmkazTxjL56IA2umA5CF49725QDFejPbXXlaVtgCa6rNFsaFHI6n4UkVeYHmwd92vYJtiKPaFtYNgSRxfAQQnhorwgi6FQgc3e+DuuGRiqaNocD4frYDwz9uWsCWjMfwrylQrDVpIL1ZtP4d1c7Ow9J2C+VRy6Ndplbx82t4mR4ekZmbbM34WVYnrXatnclRr225yspVZmmj8NPzPVvFcwFC2ehsJLFMJnVqf4kOq9un0a0qSoIJjzg+qqNKX47ZWcup5RnutmfRTn8U3U8CfDnycYX5hoH+5/h0SXatsVS0wA2+zazOPWAhrfavwC2zJm2cshI20qLAlg== scottl@scott.to',
        'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVXG5NmmBvhKxA1t2H/qInOSWjYLNNaBRLQaI5rPbKX5U9pQfKJWHVnH779xbCFywkPed8wveIqfKfuOdNCHm59XrCeHVq1Y/2y6WsWQCyVR19xtRkLDhYuOuVC0bXsjloOYtlsXR4+r1x9lfHcV/6a74OzVuIgf79FDuXPNVi6Y9TOfpzhGRfNCzSE/4M0mMA364OuxSXGJTMLaQGlCioPzWSmqotITvwVjHzW3wEK4mmTpdIodjwVTsNjH86Gt7uE9x0tXgNSgVhmLmZ1v6DVRESm5EdLWce+hz766nSVYMteqpH5dS2eWN3tWOAIZu8AaTPlccfKQvNZIxZ2Siv slindsey@laptop'
    ];
}

