# Skiqqy.xyz
This is my website, which is hosted [here](https://skiqqy.xyz).

## Building
There are two approaches
````
$ make # Build everything.
````
Or
````
$ make demo # Builds everything with injected warning text.
````

### Static site
````
$ make build
````

### Web Pages
In the current iteration, to add a new page to the website create a `raw/<file>.txt`, this will generate an html file placed in `site/<file>.html`. For examples look inside `raw/`.
This file uses a custom markup called skup (skiqqy markup) that has the following features.

#### Blocks
Wrap text/skup/html in a block, please note the `.` that terminates the title as well as the `EBLOCK` that terminates the block.
```
SBLOCK. <Title>
<text/skup/html>
EBLOCK.
```
This will generate html that looks something like the following.
```
+------------------------------------+
|                                    |
|              <Title>               |
|                                    |
|         <text/skup/html>           |
|                                    |
+------------------------------------+
```

#### Newlines
To force a newline simply use `\\` (just like LaTeX).

### Links
To add a link use
```
a/name.domain/<your link name>/
```
This will create a hyperlink with the text `<your link name` pointing to
`name.domain`

### Static Blog
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
