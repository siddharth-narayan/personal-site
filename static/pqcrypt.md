# Post Quantum key agreement for TLS 1.3
Adds the ability to load the [oqsprovider](https://github.com/open-quantum-safe/oqs-provider) OpenSSL Provider if present. 
Adds a call to SSL_set1_groups_list  to set the correct groups in StartSSLEx3. If this fails, the default groups will be used. The extra groups are provided by oqsprovider, if installed.

**Will only work for OpenSSL 3.0 or greater, where oqsprovider is installed and on TLS1.3**

In order of highest priority, here is the list of groups:
- p521_kyber (Quantum safe, hybrid)
- x25519_kyber (Quantum safe, hybrid)
- P-521 (Not quantum safe)
- X25519 (Not quantum safe)
- P-256 (Not quantum safe)

I created this order following the guidance from the [openssl blog](https://www.openssl.org/blog/blog/2022/10/21/tls-groups-configuration/). It is in order of most secure but also most resource heavy, which I'm not sure is ideal. However, because this is just a key exchange, it only happens once, at the beginning of communication.


![Screenshot_20240520_230208](https://github.com/SoftEtherVPN/SoftEtherVPN/assets/26383051/1e4f0564-3f07-4be4-9960-20d70c2351f0)