# Skiqqy.xyz
This is my website, which is hosted [here](https://skiqqy.xyz).

## Building
````
$ make
````

## Static site
````
$ ./build.sh
````

## Static Blog
The goal of this website is to serve 'static' content that gets updated
through scripts, this is to reduce bloat, and to ensure a fast website.
To create the 'full' website, it is important to first run,
````
$ make blog
````
as this will create blog posts from the files found in `blogs/RawBlogs`, and
and setup all the links and stuff for them, these blog files are written
with a custom markup lanuage with very simple markups, Currently there are the
following:

---

(1)
````
[
Normal Text Goes Here.
]
````

---

(2)
````
(
Block Text Goes here.
)
````

---

(1) Will generate:
````
Normal Text Goes Here.
````

(2) Will generate:
````
+--------------------------+
|                          |
|   Block Text Goes Here   |
|                          |
+--------------------------+
````

## Reason for C
Its fast. Aint no body got time for bloated stuff.
