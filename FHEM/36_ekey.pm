###############################################################################
#
# A module to receive and parse ekey udp requests
#
# written 2019 by Matthias Kleine <info at haus-automatisierung.com>
#
###############################################################################

package main;

use strict;
use warnings; 
use IO::Socket;

sub ekey_Initialize($)
{
    my ($hash) = @_;

    $hash->{DefFn} = "ekey_Define";
    $hash->{UndefFn} = "ekey_Undefine";
    $hash->{ReadFn}  = "ekey_Read";
    $hash->{AttrList} = "ekeyType:home,multi " . $readingFnAttributes;
}

sub ekey_Define($$)
{
    my ($hash, $def) = @_;

    my @args = split("[ \t]+", $def);

    return "Invalid number of arguments: define <name> ekey <port> [<delimiter>]" if (int(@args) < 1);

    my ($name, $type, $port, $delimiter) = @args;

    if (defined($port)) {
        return "$port is invalid (1024 - 65535)" if (($port !~ /^([0-9]{2,5})$/) || $port < 1024 || $port > 65535);

        if (defined($delimiter) && $delimiter ne "") {
            $hash->{DELIMITER} = $delimiter;
        } else {
            $hash->{DELIMITER} = '_';
        }

        my $conn = IO::Socket::INET->new(Proto => 'udp', LocalPort => $port) or return 'Unable to open connection';

        $hash->{PORT} = $port;
        $hash->{FD} = $conn->fileno();
        $hash->{CONN} = $conn;

        Log3($name, 2, 'ekey_Define: Opened udp connection on port ' . $port);

        $selectlist{$name} = $hash;

        return undef;
    } else {
        return "Port is missing";
    }
}

sub ekey_Undefine($$)
{
    my ($hash, $name) = @_;

    $hash->{CONN}->close();

    return undef;
}

sub ekey_Read($)
{
    my ($hash) = @_;
    my $name = $hash->{NAME};
    my $delimiter = $hash->{DELIMITER};

    my $buf;

    $hash->{CONN}->recv($buf, 255);

    Log3($name, 5, 'ekey_Read: ' . $buf);

    readingsBeginUpdate($hash);

    readingsBulkUpdate($hash, "raw", $buf);

    

    my @values = split(/$delimiter/, $buf);
    Log3($name, 5, 'ekey_Read: ' . (scalar @values) . ' parts');

    if (AttrVal($name, "ekeyType", 0) eq "multi") {

        # e.g. 1_0003_-----JOSEF_1_7_2_80156809150025_–GAR_3_-

        readingsBulkUpdate($hash, "type", $values[0]);
        readingsBulkUpdate($hash, "user", $values[1]);
        readingsBulkUpdate($hash, "user-name", $values[2] =~ s/^-+//r);
        readingsBulkUpdate($hash, "user-status", $values[3]);
        readingsBulkUpdate($hash, "finger", $values[4]);
        readingsBulkUpdate($hash, "key", $values[5]);
        readingsBulkUpdate($hash, "scanner", $values[6]);
        readingsBulkUpdate($hash, "scanner-name", $values[7] =~ s/^-+//r);
        readingsBulkUpdate($hash, "action", $values[8]);
        readingsBulkUpdate($hash, "relay", $values[9]);

    } else {
        # Default: home

        # e.g. 1_0046_4_80156809150025_1_2

        readingsBulkUpdate($hash, "type", $values[0]);
        readingsBulkUpdate($hash, "user", $values[1]);
        readingsBulkUpdate($hash, "finger", $values[2]);
        readingsBulkUpdate($hash, "scanner", $values[3]);
        readingsBulkUpdate($hash, "action", $values[4]);
        readingsBulkUpdate($hash, "relay", $values[5]);
    }

    readingsEndUpdate($hash, 1);
}

1;

=pod
=item device
=item summary ekey UDP receiver and parser for LAN events

=begin html
<a name="ekey"></a>
<h3>ekey</h3>
<ul>
  This module allows to receive and parse ekey UDP events sent by the CV LAN (for home and multi control units)<br>
  For further information about the products visit <a href="https://www.ekey.net/">ekey.net</a>.<br>
  <br>
  <br>
  <a name="ekeyDefine"></a>
  <b>Define</b>
  <ul>
    <code>define &lt;name&gt; ekey &lt;port&gt; [&lt;delimiter&gt;]</code><br>
    <br>
    port is required. Possible value range: 1024 to 65535<br>
    <br>
    delimiter is optional (Default: _)<br>
    <br>
    Examples:
    <ul>
      <code>define myekey ekey 5555</code>
    </ul>
    <ul>
      <code>define myekey ekey 5555 _</code>
    </ul>
  </ul>
  <br>
  <a name="ekeySet"></a>
  <b>Set</b>
  <ul>
    <li>N/A</li>
  </ul>
  <br>
  <a name="ekeyGet"></a>
  <b>Get</b>
  <ul>
    <li>N/A</li>
  </ul>
  <br>
  <a name="ekeyAttr"></a>
  <b>Attributes</b>
  <ul>
    <li>
        <a name="ekeyType"></a><code>ekeyType</code><br>
        Set the type of the used control unit - home or multi
    </li>
  </ul>
  <br>
  <a name="ekeyEvents"></a>
  <b>Generated events:</b>
  <ul>
     <li>N/A</li>
  </ul>
</ul>
=end html

=cut