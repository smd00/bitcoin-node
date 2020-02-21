# bitcoin-node

## How to Install a Bitcoin Daemon

Bitcoin Daemon uses the RedisDB to push the wallet notification for the wallets that it is managing. 
To setup the BitcoinD on a Ubuntu 18.04 server run the below command after copying this folder to the ubuntu server somewhere.

Redis host will use default port.

```
chmod +x ./setup.sh

./setup.sh <RPC-USERNAME> <RPC-PASSWORD> <REDIS-HOST>
```