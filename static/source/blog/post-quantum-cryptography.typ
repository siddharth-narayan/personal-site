= Post Quantum Cryptography

Welcome to my first ever blog post! I'm going to go over the process of everything post quantum that I've worked on for the past month or so.

== Intro
This adventure started a long time ago, when the YouTube channel Veritasium #link("https://www.youtube.com/watch?v=-UrdExQW0cs")[released a video] on post quantum cryptography. Ever since watching that video, it's been stuck in the back of my mind that every bit of information we send across the internet is potentially being collected and stored by very powerful organizations like governments, so that someday in the future they will be able to read it.

It took a long time before I actually started work on anything, but one day I decided that #link("https://www.softether.org/")[SoftEtherVPN], the VPN I have set up on my server, would be even better if I could add post quantum cryptography so that it could be safe from any attacks by post quantum computers. This is especially important because this VPN specifically lists getting around China's GFW (and other government censorship) as something it can be used for. The first thing I did was research. After learning the basics about how TLS works currently, I had to find out how to find out how to make it post quantum. TLS first does a key exchange before using #link("https://www.geeksforgeeks.org/what-is-a-symmetric-encryption/")[symmetric encryption]. Because symmetric encryption is still #link("https://crypto.stackexchange.com/questions/6712/is-aes-256-a-post-quantum-secure-cipher-or-not", [*mostly*]) quantum safe, the only part that needs to be fixed is the key exchange. I targeted TLS1.3, because it's the latest version.

Now that I had found out what to do, I needed to find out how to do it. After many google searches and looking through the SoftEtherVPN source code, I knew what to do. SoftEtherVPN, like many other things uses OpenSSL. OpenSSL allows setting TLS groups using `SSL_set1_groups_list`, so I knew that I had to set the proper groups. (a TLS group seems to be just a Key Exchange Method (KEM)). The only problem is that OpenSSL doesn't support post quantum groups.

== Actually Making it Work
We need a way to make OpenSSL recognize that post quantum groups exist. Right now, there is no built in support for that in OpenSSL. This is for a good reason, because support can be added in later. OpenSSL is made of many different versions. OpenSSL 1.1.1 seems to be the latest verion released for the old OpenSSL (now deprecated). However, there is the newest version, which is OpenSSL 3. Neither version has support for post quantum key exchange, but OpenSSL 3 has a "plugin" system in which plugins are called providers, because they provide new functionality (Ciphers, Signature Verification, Key Exchange, etc...). Providers seem to be the method for adding all extra functionality. We are interested in the key exchange part of what providers can do.

There is a project which implements all quantum resistant algorithms: #link("https://openquantumsafe.org/")[Open Quantum Safe (OQS)]. They have created a library called liboqs, which implements post quantum KEMs and Signature Verification. The have also created an OpenSSL provider which is called oqs-provider which uses liboqs. Neither of these are popular enough to be in any repositories except for in the Nix package manager. Luckily for me, I use NixOS (btw). *Unfortunately*, only liboqs is in the nixpkgs repository (a big thank you to whoever put it there). This meant that I had to compile oqs-provider from source. 

This one is pretty simple, even with Nix. Unfortunately, the way that Nix works meant that I also had to recompile OpenSSL, which was a very difficult thing for me to do, because I wasn't very familiar with Nix yet, and the state of the documentation still not great. Because I don't want to go on too big of a tangent, if you're interested, you can #link("https://github.com/siddharth-narayan/openssl-with-providers")[see for yourself] the solution I came up with. Once OpenSSL is installed and oqs-provider is installed and enabled, everything becomes very simple. Simply call `SSL_set1_groups_list` with the proper arguments sometime before SSL is enabled and make sure oqs-provider is loaded in the code, and OpenSSL will do the rest for the TLS connection. 

There are a lot of groups that oqs-provider has. The groups that will be used here are from the kyber family, but these specific groups are *Hybrid*, combining both post quantum and classical cryptography. This means that even if for some reason Kyber (The post quantum KEM) is broken in the future, whether by classical or quantum computers, the classical key exchange is still secure. This is the best method for implementing post quantum cryptography, which is still somewhat untested and new.

== SoftEtherVPN
It only took 13 lines of code to actually make the changes necessary in the SoftEtherVPN source code. Most of the difficulty came in research and reading the source to familiarize myself with how everything functioned. The only thing that was changed is loading and unloading the provider, and calling ```SSL_set1_groups_list```. It really is that simple; checking the ClientHello packet in Wireshark, we can see that the client really does try to negotiate a post quantum key exchange. 

#image("../../assets/wireshark.png", alt: "Wireshark Screenshot")

But it might not be that simple, actually. For these changes to actually make a connection with post quantum cryptography, a user will need to follow these steps
1. Install SoftEtherVPN - with my changes
2. Have OpenSSL installed dynamically
5. Build liboqs from source and install it onto their system
6. Build oqs-provider and install it into OpenSSL (this is why OpenSSL has to be dynamic)

Steps 2, 3, and 4 are *necessary* for any post quantum functionality, and if any of them go wrong, the user will probably be pretty frustrated, and we all know how difficult building something from source can be. Step 2 on Windows is absolutely possible, but who has OpenSSL dynamically on Windows other than developers? A normal user will have to install OpenSSL dynamically just for this. 

When I realized how difficult it would be for users, I started work on building post quantum functionality into SoftEtherVPN itself. Following oqs-provider's very simple #link("https://github.com/open-quantum-safe/oqs-provider/blob/main/examples/static_oqsprovider.c")[example code], the actual change was only really the addition of these two pieces: `OSSL_PROVIDER_add_builtin` and `extern OSSL_provider_init_fn oqs_provider_init`, which together registers a statically built in oqs-provider as a provider to OpenSSL, even if the library is not present in OpenSSL's module folder. The rest was wrestling with CMake (for a *very* long time) to get it to build oqs-provider and liboqs as git submodules without changing anything *inside* the submodules. With these changes, a user can now build from source on Windows and have post quantum functionality right away, by default.

#link("https://github.com/SoftEtherVPN/SoftEtherVPN/pull/2002")[Pull Request 1]

#link("https://github.com/SoftEtherVPN/SoftEtherVPN/pull/2022")[Pull Request 2]

== Nginx
This website is built with SvelteKit, but requests go through an Nginx reverse proxy. Now that we have OpenSSL 3 with oqs-provider installed, it's possible to just set the directive `ssl_ecdh_curve` in any server block (Although I had to set in the http block, otherwise it wouldn't work for some reason):
```nginx
http {
        ssl_ecdh_curve x25519_kyber768:p384_kyber768:p521_kyber1024:x25519:secp384r1:x448:secp256r1:secp521r1;

        # Other stuff here...
}
```

The extra nginx config for this website to tell what your key exchange support is looks like this:
```nginx
server {
        # Normal stuff here

        location / {
                proxy_set_header X-SSL-Curves $ssl_curves; # On the request
                proxy_set_header X-SSL-Curve $ssl_curve;
                add_header X-SSL-Curves $ssl_curves; # On the response
                add_header X-SSL-Curve $ssl_curve;

                # Normal stuff here
        }
}
```
The client then reads the header and displays some text

== Enabling Post Quantum Cryptography
If you've read this far, and have decided you want to enable post quantum cryptography, you can definitely do so. Check at the bottom of this page to see your connection details! Right now Chrome and Firefox both support the TLS group x25519_kyber768. I'm not sure about support on Edge, but it's Chromium based so I'm assuming it has some support. Cloudflare already supports TLS 1.3 with post quantum cryptography enabled, and Wireguard has gotten support as well. According to Cloudflare, 2% of all TLS 1.3 connections are already secured with post quantum cryptography. Adoption is rising very quickly, which is great news! 

#html.elem("blockquote")[*Note:* Enabling support in Chrome can be done by going to chrome:\/\/flags and setting *TLS 1.3 hybridized Kyber support* to true]

Enabling support in Firefox can be done by going to about:config and setting *security.tls.enable_kyber* to true

== Sources
- https://pq.cloudflareresearch.com/
- https://blog.cloudflare.com/pq-2024
- https://www.openssl.org/docs/man3.0/man3/SSL_set1_groups_list.html
- https://www.openssl.org/blog/blog/2022/10/21/tls-groups-configuration/
- https://blog.aegrel.ee/kyber-nginx.html
- https://github.com/open-quantum-safe/oqs-provider
- https://github.com/SoftEtherVPN/SoftEtherVPN
