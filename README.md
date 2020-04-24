# .dotfiles

My personal dotfiles I use on every system I use.

---

## Story of this repo

### Where is my _Start Menu_?

Around 2015, my professional life took me into non-Windows development starting with Linux using CentOS 6.7.  I ramped up as fast as I could with GCC, VIM, yum, and of course the BASH shell.

#### Thank you StackOverflow

I then spent the next 3 years using StackOverflow answers (and what-not) to slowly augment my growing list of _dotfile_ enhancements in my **virtual** development machine  (_which was of course hosted on my comfortable & familiar Windows OS_).

This was a great way to learn a new OS while keeping my security blanket, but my initial 20GB virtual machine over the years became 300GB - and I did not handle my _.vmdk_ files correctly.

#### Now I want to save my accumulated **setup**

My strong desire to rebuild my development Linux VM urged me to investigate _dotfile management_ on the web.  I found [Github Tutorials](http://dotfiles.github.io/tutorials/) which looked *_really_* promising, but before making my first repo - I got pulled into a minor version of [tutorial hell](https://www.google.com/search?client=firefox-b-1-d&q=tutorial+hell) before work pulled me completely away and I did not get back to it.

#### Then, I transitioned to Mac development at work

I definitely want to host my dotfiles and protect my personal stuff, so went back to it and created what we have here.

---

## I drew inspiration from:

* [Getting Started with Dotfiles](https://driesvints.com/blog/getting-started-with-dotfiles/)

  Dries Vints dotfiles proejct includes a [Brewfile](https://github.com/driesvints/dotfiles/blob/f6321eed4852578c5c23894dcb22814851efd8d1/Brewfile) was a great list of web-searches for someone new to MacOS - I now have about half of that list installed on my dev machine ;)

* [Managing Your Dotfiles](https://www.anishathalye.com/2014/08/03/managing-your-dotfiles/)

  * A **big** thank you for introducing me to the word [idempotent](http://en.wikipedia.org/wiki/Idempotence)
    * It is a great way to describe a script that does no harm when run multiple times
    * **All** install scripts should be certified to be _**idempotent**_
  * Here I really dug into the *_management_* of the dotfiles themselves - how to retrieve, how to install...
  * After looking deep at the tools mentioned - I decided to stick with _built in_ if possible and go with [stow](https://www.gnu.org/software/stow/)

* [Managing dotfiles with GNU stow](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/)

  This was a good description of stow that helped me plan out my own use. 

* [Awesome dotfiles](https://project-awesome.org/webpro/awesome-dotfiles)

  A great collection - had many of the pages I had already found through other means

* [Encrypted dotfiles with GnuPG](https://abdullah.today/encrypted-dotfiles/)

  This led me on a _looong_ journey (see below) to creating my first personal key pair - and I even borrowed Abdullah's idea to have scripts named [endot](private/endot.sh) and [dedot](private/dedot.sh)

---

## GPG Journey

Really I just want to include the links I used to educate me on the process of making a **solid** first personal keypair.

* [Creating the Perfect GPG Keypair](https://alexcabal.com/creating-the-perfect-gpg-keypair)

  This was my first stop (proabably the title caught me a bit) and the information is **solid**.\
  I read many other pages who along with this page, pointed to this [Debian Wiki](https://wiki.debian.org/Subkeys?action=show&redirect=subkeys) page as containing the _secret sauce_ for properly protecting your master key.

  Anyhow, I followed this advice, and have a solid first key, whose master key is well protected.

* [Creating a new GPG key](https://ekaia.org/blog/2009/05/10/creating-new-gpgkey/)

  Well laid out steps for adding a second UID

* [Anatomy of a GPG Key](https://davesteele.github.io/gpg/2014/09/20/anatomy-of-a-gpg-key/)

  I spent much time pouring over the output of `gpg -a --export | gpg --list-packets --verbose` and using the information on this page to analyze what I was seeing on my own system as I went through the process.\
  (also starting with `gpg -a --export-secret-keys | ...`)

### NOTE:  this was important though

* [How to change the expiration date of a GPG key](http://www.g-loaded.eu/2010/11/01/change-expiration-date-gpg-key/)

  **I wish I read this before my first attempt at key creation started with a really long expiration because I didn't realize how _**easy**_ it is to extend the expiration :)**

---

Here's a super giant cmd-line I was using to run a simple analysis of my GPG files at each step of the process:

```bash
idx=just-created; for f in .gnupg/**/*.{kbx,key}; do xxd -c 256 -g 0 $f $f.dump; done; for a in --export-secret-keys --export; do gpg -a $a; done | gpg --list-packets --verbose >g-pkts-step-$idx.txt; perl -ne 'print qq*$1\n* if /^(?::|[ \t]+(?:data|keyid|pkey.0.): )(.{16,64})/' g-pkts-step-$idx.txt | while read e; do echo $e; find .gnupg -name '*.dump' -exec ggrep -PIli "\Q$e\E" {} \; | sed 's/^/    /'; echo; done >g-res-step-$idx.txt
```

* `idx` is at the front so I could just arrow-up and change this value and re-run
* one `for` loop dumps the binary files under `~/.gnupg`
* next `for` loop dumps both seret & public GPG packet data _verbose_ style
* final `while` loop processes the output of perl and does `find ~/.gnupg ... -exec grep ...` with each expression.

Depending on how you set 'idx' right at the beginning, the output files will be:

* `g-pkts-step-$idx.txt` which is the raw output of the GPG packet dump
* `g-res-step-$idx.txt` which is the output of searching the `~/.gnupg` files for important stuff

At this point, I learned quite a bit about signatureshow each bit of data added to a Key has an accompaning signature to validate the bit of data -- be it a _photo_ or _uid_.

So now I have a personal GPG key

* uploaded to this account
* uploaded to a public keyserver
* with the same icon I want
* with the e-mail addresses I want it to contain
* with a reasonable 1 year expiration (for now, maybe i'll try 2 years next time ;)

#### ... and most imortantly:

* which I then used to ensure my private & work dotfiles are protected so I can join the Github community with this _dotfiles_ project

:smiley:
