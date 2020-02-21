# bitcoin-node

## How to Install a Bitcoin node

To setup a Bitcoin node on Ubuntu 18.04 follow these steps:
- Copy files to server (i.e. SFTP via Filezilla)
    - bitcoin.conf.tmpl
    - notify.sh.tmpl
    - setup.sh
- Run the below commands

```
chmod +x ./setup.sh && ./setup.sh <RPC-USERNAME> <RPC-PASSWORD>
```

### Cheat Sheet: Parity Ethereum and Bitcoin Core:
You can find some useful commands on the post below:

https://medium.com/@danielmontoyahd/cheat-sheet-parity-and-bitcoin-core-c370163fca44