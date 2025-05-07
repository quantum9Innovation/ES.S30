#import "@preview/touying:0.5.3": *
#import "@preview/cetz:0.3.1"
#import "@preview/cetz-plot:0.1.0"
#import themes.stargazer: *

#let date = datetime(
  year: 2025,
  month: 5,
  day: 7,
).display("[month repr:long] [day padding:none], [year]")
#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  header-right: rect(
    none, fill: gradient.linear(color.rgb(0, 91, 172), black),
    width: (100% + 50pt), height: 100pt
  ),
  config-info(
    title: [A (Slightly Deranged) Survey of (Simple) Cryptography],
    subtitle: [
      "We kill people based on metadata."
      --Michael Hayden
      #footnote[Attribution: @ferran_2014 (famously also believes the Fourth Amendment is not a real thing)
      ]
    ],
    author: [Ananth Venkatesh],
    date: date,
    institution: [Massachusetts Institute of Technology (#smallcaps("mit"))]
  )
)

#set heading(numbering: "1.1")
#show heading.where(level: 1): set heading(numbering: "1.")
#show figure.caption: emph

#let vec = sym => math.bold(math.upright(sym))
#let unit = sym => math.hat(vec(sym))

#title-slide()

= Classical Cryptography

#focus-slide[
  Security by obfuscation is security by delusion.
  #block[
    #set text(size: 0.75em)
    (cryptography is the study of the mathematical theory of _provably secure systems_)
  ]
]

#pagebreak()

#figure(
  caption: [The NSA is, and has remained, enemy number one; \ but American corporations are not far behind]
)[
  #image("assets/img/apple.jpg", height: 85%)
]

== Hashing

The foundations of cryptography are built on one-way functions, called *hashes*.

#pause

#tblock(title: "Definition")[
  Hashes are formally defined as injective functions $f: X -> Y$, where $X$ is some data we want to hash and $Y$ is a fixed-length bitstring.
  In reality, $X$ can be a set with infinite cardinality, so the fixed length of $Y$ means it is theoretically impossible to construct such an injective function.
]

#pagebreak()

Ideal hashes satisfy the following properties:

#pause

1. Few collisions $(x,y) | f(x)=f(y)$ and collision resistance (hard to find $(x,y)$)

#pause

2. $f$ is easy to compute and well-defined, but $f^(-1)$ is exceedingly difficult to compute

#pause

3. Uniform distribution of output and maximum entropy (the smallest discrete change in input should yield the maximum possible expected change in output)

#pagebreak()

=== Entropy

In the case of an input bitstring, changing one bit in $x in X$ should flip, on average, half the bits in $y in Y$.

#pagebreak()

#figure(
  caption: [By User:Jorge Stolfi based on Image:Hash_function.svg by Helix84 \ - Original work for Wikipedia, Public Domain, #link("https://commons.wikimedia.org/w/index.php?curid=5290240")[commons.wikimedia.org] @helix84_2008]
)[
  #image("assets/img/hash.svg", height: 85%)
]

#pagebreak()

#figure(
  caption: [Process message of arbitrary size in chunks using a compression algorithm in series \ By Davidgothberg - Own work, Public Domain, #link("https://commons.wikimedia.org/w/index.php?curid=1906913")[commons.wikimedia.org] @gothberg_2007]
)[
  #image("assets/img/digest.svg", height: 85%)
]

#pagebreak()

- Creating such a function (that is cryptographically secure) is notoriously difficult

#pause

- Most involve obscure bit transformations that read like dark magic

#pause

- DIY hash functions (and DIY anything in cryptography) is frowned upon by experts due to the necessity for rigorous testing before something is deemed "secure"

#pagebreak()

#figure(
  caption: [Typical cryptography learning curve]
)[
  #image("assets/img/diy.jpg", height: 85%)
]

#pagebreak()

=== Applications

- Hash passwords in a database (need for *cryptographic salt*)

#pause

- Pseudorandom number generation (hash predictable input, get unpredictable output)

#pause

- Verifying message integrity

== Symmetric Encryption

#focus-slide[
  "¡WhatsApp imperialismo tecnológico está atacando a Venezuela! ... Soy libre de WhatsApp. Estoy en paz."
  ---Nicolás Maduro
]

#pagebreak()

- Want a way to encrypt data, readable by only one person

#pause

- Use an algorithm that takes a secret and data, and then manipulates the data so it can only be retrieved if the secret is known

#pause

- Many algorithms to do this (trivial example is the one-time pad, but better, more efficient implementations exist)

#pagebreak()

#figure(
  caption: [The horrors of modern cryptography]
)[
  #image("assets/img/stop.png", height: 90%)
]

== Signatures

We want a way to verify the authenticity of a message.

#pause

How can I be sure that Hegseth really sent that message about the change in war plans?

#pause

To do this, we need to introduce the idea of a *key*.

#pagebreak()

#tblock(title: "Definition")[
  Keys are fixed-length random bitstrings that are either kept secret (private) or exposed (public).
  They act as encryption and decryption mechanisms.
]

#pause

- Generate a *private* key $S$ for signing $f : M -> S -> "Signature"$

#pause

- Generate a corresponding *public* key $V$ for verifying a signature $g : M -> V -> "Signature" -> "Bool"$

#pause

- $g$ verifies that a message $M$ was signed with $S$

#pause

- Since $S$ is private (known only to the sender), we can be sure the message is authentic if $g$ returns true

#pagebreak()

#figure(
  caption: [Hegseth is maxxing out his team's OPSEC by signing his messages \ so random journalists can be sure of their authenticity]
)[
  #image("assets/img/signal.png", height: 85%)
]

== Diffie--Hellman

- We have a lot of very good, very strong symmetric encryption algorithms

#pause

- These are good if we want to send a message to ourselves, or if we are communicating with someone else but have a shared secret before we start

#pause

- If we are communicatinig over an insecure channel with no pre-arranged secret (connecting to servers over the internet, e.g.), everything we've built so far seems to break down

#pagebreak()

#block[
  #set text(size: 42pt, fill: blue)
  What if we could turn any symmetric encryption algorithm into an _asymmetric_ one?
]

#pagebreak()

- The central idea of Diffie-Hellman is that we can arrive on a shared secret even if we are communicating over an insecure channel

#pause

- We can do this because _it doesn't matter what the secret we arrive on is_, so long as it's (a) random and (b) secret (known only to both of us)

#pause

- We circumvent the difficulty of communicating information over an insecure channel, because we are not communicating a coherent, known message but rather following an algorithm to create a shared random secret

#pagebreak()

#figure(
  caption: [By Original schema: A.J. Vinck, University of Duisburg-EssenSVG version: Flugaal - \ A.J. Han Vinck, Introduction to public key cryptography, p. 16, Public Domain, #link("https://commons.wikimedia.org/w/index.php?curid=17063048")[commons.wikimedia.org] @helix84_2008]
)[
  #image("assets/img/diffie.png", height: 85%)
]

#pagebreak()

- Replace paint with *keys* (red and green paint are _secret_ keys, yellow is _public_)

- Replace addition with a one-way (hash-like) commutative binary operation

#pagebreak()

#tblock(title: "Implementation")[
  1. Choose a cyclic group $G$ of order $n$ (where $n$ is very, very large)
  2. Choose a generating element $g in G$ where $g$ is the *public key*
  3. Alice chooses a *secret key* $a$ and Bob chooses a *secret key* $b$
  4. Alice sends $g^a$ and Bob sends $g^b$ publicly
  5. Alice computes $(g^b)^a$ and Bob computes $(g^a)^b$, the *shared secret*
]

#pagebreak()

We can verify that some basic properties hold:

#pause

- Multiplication of elements in a cyclic group is commutative ($(g^a)^b = g^(a b) = (g^b)^a$), so the computed sharerd secret is the same for Alice and Bob

#pause

- We can choose a group that gives rise to the "one-way" criterion: consider modular exponentiation of $g$ ($G = {g^k mod p | k in ZZ}$ for some large prime $p$)

#pagebreak()

- Commutativity of this group comes from the fact that $(a b mod p) = (a mod p)(b mod p) mod p$

#pause

- Finding $g | g^k = h mod p$ given $h, k$ is very hard for well-chosen $p$ (this is known as the "discrete logarithm problem")

#pagebreak()

#figure(
  caption: [Friendly rivalry among prominent cryptographers are occasionally settled through unencrypted communication]
)[
  #image("assets/img/cryptographers.jpg", width: 90%)
]

== Elliptic Curves

- Cool mathematical objects; they look like $y^2 = x^3 + a x + b$

#pause

- "Addition" of points on an elliptic curve provide a much harder analogue of the discrete logarithm problem (which means smaller key sizes)

#pause

- Will soon be (somewhat) obsolete due to quantum computing, but some applications may remain in isogeny based cryptography

#pagebreak()

#image("assets/img/elliptic.png", height: 90%)

= Fully Homomorphic Encryption

== Zero-Knowledge Proofs

- Beginnings of FHE

#pause

- Want to construct proof of knowledge of $x | f(x)=y$ without revealing $x$

== Polynomial Commitments

- Want proof that a given (complicated) computation was faithfully carried out by an untrusted agent, without performing the computation itself

#pause

- Specifically in the context of evaluating a (very large) polynomial for an arbitrary input

== Garbled Circuits

- Want to perform multi-party computation on private data

#pause

#tblock(title: "Example")[
  Say Alice and Bob want to compare salaries without revealing any information.
  Need to compute $f(a,b)$ which indicates whether $a > b$, $a < b$, or $a = b$ where $a$ is Alice's salary and $b$ is Bob's.
]

#pagebreak()

- Curry $f(a,b)$ to $f(a)(b)$. Alice computes $f(a)$ and "garbles" the circuit before sending it to Bob, who evaluates $"Enc"(f(a)(b))$.

#pause

- Only Alice can decrypt the result, so Bob cannot peer into the internals of $f(a)$ and therefore never learns $a$

#pause

- Alice can send a proof that the garbled circuit $"Enc"(f(a))$ is an encrypted version $f$, so Bob can verify that Alice will not gain any information other than the output of $f$

= Practical OpSec Advice

== Local Computation

- Full Disk Encryption (#link("https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup")[LUKS])

#pause

- Email Encryption (#link("https://www.gnupg.org/gph/en/manual/x135.html")[GPG key signing])

#pause

- Communication Protocols (should be #link("https://simplex.chat/")[E2EE])


== Vulnerabilities and Paradoxes

- The Ken Thompson Hack (#link("https://wiki.c2.com/?TheKenThompsonHack")[KTH])

#pause

- Hardware attacks (#link("https://thunderspy.io/")[Thunderspy], #link("https://en.wikipedia.org/wiki/Evil_maid_attack")[evil maid], etc.)

#pause

- Common software vulnerabilities (#link("https://textbook.cs161.org/memory-safety/vulnerabilities.html")[memory attacks], #link("https://en.wikipedia.org/wiki/Timing_attack")[timing attacks])

== References

#v(2em)

#bibliography("refs.bib", title: "References", full: true, style: "chicago-author-date")
