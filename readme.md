# Declarative nftables rules for NixOS

`nftables.nix` is a NixOS module providing declarative configuration of firewall rules using nftables.

This modules allows to define nftables rules spread across multiple declaration (and therefore multiple files).
The order of rules is defined by relative positioning to other rules.
To do this, each rule has an explicit name and other rules can be positioned in relation to other names (like "before", "after" or "between").

## Missing features
`nftables.nix` uses a simplified nftables model.
There is a 1-to-1 mapping from protocol families to table names and from hoos to chains - no custom chains.
This is good enough for most filtering cases but does not allow branching.

## How to install
`nftables.nix` can be used as a flake or by directly importing `default.nix` in your module system.

Example using flakes:
```
{
  inputs = {
    nftables.url = "github:fooker/nftables.nix";
  };

  outputs = { nftables, ... }: {
    nixosSystem = {
      modules = [ dns.nixosModules.default ];
    };
  };
}
```

Example using imports:
```
{
  imports = [ /path/to/nftables.nix/default.nix ];
}
```

## How to use
The module defines the `firewall.enable` option which must be set to `true` to enable usage of nftables.

Rules are configured by `firewall.rules` which accepts a function 
 with a single parameter `dag` allowing to define rules.
The return value of that function must be an attrset having 4 levels:
`${family}.${type}.${chain}.${name}` with a `dagEntry` as values.

|Element |Description                     |
|--------|--------------------------------|
|`family`| Address familiy and table name |
|`type`  | The kind of chain              |
|`chain` | Name of the chain              |
|`name`  | User-defined name of the rule  |

The following attributes are supported:
- `ip.filter.prerouting`
- `ip.filter.input`
- `ip.filter.forward`
- `ip.filter.output`
- `ip.filter.postrouting`
- `ip.nat.prerouting`
- `ip.nat.input`
- `ip.nat.output`
- `ip.nat.postrouting`
- `ip.route.output`
- `ip6.filter.prerouting`
- `ip6.filter.input`
- `ip6.filter.forward`
- `ip6.filter.output`
- `ip6.filter.postrouting`
- `ip6.nat.prerouting`
- `ip6.nat.input`
- `ip6.nat.output`
- `ip6.nat.postrouting`
- `ip6.route.output`
- `inet.filter.prerouting`
- `inet.filter.input`
- `inet.filter.forward`
- `inet.filter.output`
- `inet.filter.postrouting`
- `inet.nat.prerouting`
- `inet.nat.input`
- `inet.nat.output`
- `inet.nat.postrouting`
- `arp.filter.input`
- `arp.filter.output`
- `bridge.filter.prerouting`
- `bridge.filter.input`
- `bridge.filter.forward`
- `bridge.filter.output`
- `bridge.filter.postrouting`
- `netdev.filter.ingress`

To create a `dagEntry`, the `dag` parameter passed to the functions assigned to `firewall.rules` can be used.
`dag` provides the following functions:

`dag.anywhere <rule>` Places the `<rule>` anywhere in the list of rules.

`dag.after <after> <rule>` Places the `<rule>` after a rule named `<after>`.
`dag.before <before> <rule>` Places the `<rule>` before a rule named `<before>`.
`dag.between <after> <before> <rule>` Places the `<rule>` after a rule named `<after>` and before a rule named `<before>`.

The provided `<rule>` can be either a string containing a single nftables rule or a list of these rules.

## Contact, Questions and Bugs
Feel free to [mail me](mailto:fooker@lab.sh) or open an issue on this repository.
