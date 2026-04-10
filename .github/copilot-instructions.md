# GitHub Copilot Instructions for avaje website-source

This file provides context and instructions for GitHub Copilot (and other AI coding agents)
working in the `website-source` repository.

---

## Overview

The avaje website is built with the **Avaje Website Generator** (a custom static site generator),
not Jekyll, Hugo, or any standard tool. Source files live in `website-source/` and the generator
outputs plain HTML to a separate `website-dest/` directory.

**Build and preview:**
```
java -jar avaje-website-generator-2.2.2.jar -s website-source/ -d website-dest/
```
The generator runs in watch mode — it re-generates changed files until stopped with `Ctrl-C`.
Serve `website-dest/` with `live-server` (npm) on `http://localhost:8080`.

**Templating:** [FreeMarker](https://freemarker.apache.org/) (`.ftl`) is used for includes and
macros. The `<head>` section of each page contains FreeMarker directives; the `<body>` is plain
HTML.

---

## Directory structure

| Path | Purpose |
|------|---------|
| `_layout/b2.html` | Root HTML shell — scripts, stylesheets, `<body>` wrapper |
| `_layout/base-<lib>.html` | Per-library base layout — sets breadcrumb root, sidebar nav include, GitHub source link |
| `_layout/macros.ftl` | (imports `_common/macros.ftl`) |
| `_common/macros.ftl` | Shared FreeMarker macros: `<@nav>`, `<@next>`, etc. |
| `_nav/_<lib>.ftl` | Sidebar navigation for a library; included by `base-<lib>.html` |
| `_<lib>/` | Reusable FreeMarker partial snippets for a library (included via `<#include>`) |
| `<lib>/` | Content pages for a library — `index.html`, plus any additional pages |
| `llms.txt` | AI-readable index of avaje library documentation (update when adding new pages) |
| `README.md` | Human-readable build instructions |

---

## Page file structure

Each page is a `.html` file. The `<head>` contains FreeMarker front matter; the `<body>` is the
rendered content. Example (`nima/archetypes.html`):

```html
<html>

<head>
  <meta name="layout" content="_layout/base-nima.html" />   <!-- required: picks the base layout -->
  <meta name="bread1" content="nima" href="/nima/" />        <!-- breadcrumb segment 1 -->
  <meta name="bread2" content="archetypes" href="/nima/archetypes" /> <!-- breadcrumb segment 2 -->
  <#assign archetypes="active">                              <!-- optional: marks nav item active -->
</head>

<body>
  <h1 id="overview">...</h1>
  ...
</body>
</html>
```

### Breadcrumbs
The base layout (`base-<lib>.html`) already sets `bread0` ("avaje") and `bread1` (the library).
Add `<meta name="bread2">` (and `bread3` if needed) in the page for deeper paths.

### Overriding the sidebar nav
By default the base layout includes `_nav/_<lib>.ftl`. A page can override this with:

```html
<template id="menuNav"><#include "/_nav/_other.ftl"></template>
```

### Section headings
Use `id=` attributes on headings so they can be linked to from the sidebar nav:
```html
<h2 id="minimal-rest">minimal-rest</h2>
<h3 id="generate">Generate a new project</h3>
```

---

## Sidebar navigation (`_nav/_<lib>.ftl`)

Navigation files use the `<@nav>` macro defined in `_common/macros.ftl`:

```ftl
<ul>
  <@nav url="#overview" title="Overview"/>
  <@nav url="/nima/archetypes" title="Archetypes">
  <ul>
    <li><a href="/nima/archetypes#minimal-rest">minimal-rest</a></li>
  </ul>
  </@nav>
  <@nav url="#start" title="Getting started">
  <ul>
    <li><a href="#dependencies">Dependencies</a></li>
  </ul>
  </@nav>
</ul>
<p>&nbsp;</p>
```

**Link rules:**
- Same-page sections: `url="#section-id"`
- Cross-page links: `url="/nima/archetypes"` — use the absolute path **without** `.html`
- Sub-items inside `<@nav>` use plain `<ul>/<li>/<a>` elements

---

## Code blocks

Use `<pre content="LANG">` where `LANG` is one of: `java`, `xml`, `groovy`, `sh`, `kotlin`, `text`.

```html
<pre content="java">
public class Main {
  public static void main(String[] args) {
    Nima.builder().port(8080).build().start();
  }
}
</pre>
```

### Escaping angle brackets inside `<pre>` blocks

| Context | How to write `<` | Example |
|---------|-----------------|---------|
| `<pre content="xml">` | Raw `<tag>` — the generator escapes XML tags automatically | `<dependency>` |
| `<pre content="java">` | Use `<|` in place of `<` for generics | `HttpResponse<|String>` |
| Normal HTML (outside `<pre>`) | Standard `&lt;` | `<code>HttpResponse&lt;T&gt;</code>` |

**Example — Java generics in a `<pre content="java">` block:**
```html
<pre content="java">
HttpResponse<|String> res = client.request().GET().asString();
</pre>
```

### FreeMarker template variables in code blocks
Use `${avaje.nima.version}` (and equivalent for other libs) inside `<pre>` blocks for Maven
dependency version snippets — the generator substitutes the current release at build time:

```html
<pre content="xml">
  <dependency>
    <groupId>io.avaje</groupId>
    <artifactId>avaje-nima</artifactId>
    <version>${avaje.nima.version}</version>
  </dependency>
</pre>
```

Pair with a shields.io badge to give a visual indication of the current version:
```html
<a href="https://github.com/avaje/avaje-nima/releases">
  <img src="https://img.shields.io/maven-central/v/io.avaje/avaje-nima.svg?label=avaje.nima.version">
</a>
```

---

## Collapsible content — `<details>`/`<summary>`

Use `<details>`/`<summary>` to hide verbose content (generated code, long examples, source file
listings) behind a click-to-expand toggle. Place the `<pre>` block inside `<details>`:

```html
<details>
  <summary><code>HelloController.java</code></summary>
  <pre content="java">
package com.example.web;
...
  </pre>
</details>
```

### Summary text variants

| Use case | Summary markup |
|----------|---------------|
| Source file listing | `<summary><code>FileName.java</code></summary>` |
| Generated/verbose code | `<summary>Generated Code: (click to expand)</summary>` |
| Named example | `<summary>example: short description of the example</summary>` |
| Configuration snippet | `<summary>example: combined native maven profile</summary>` |

The heading (`<h3>`) that introduces the section should remain **outside** `<details>` so the
anchor target and visible label are always present:

```html
<h3 id="controller">HelloController.java</h3>  <!-- always visible; anchor for nav -->

<details>
  <summary><code>HelloController.java</code></summary>
  <pre content="java">...</pre>
</details>
```

---

## Step-by-step: add a new page to an existing library

1. **Create the page file** — e.g. `nima/archetypes.html`:
   ```html
   <html>
   <head>
     <meta name="layout" content="_layout/base-nima.html" />
     <meta name="bread1" content="nima" href="/nima/" />
     <meta name="bread2" content="archetypes" href="/nima/archetypes" />
   </head>
   <body>
     <h1 id="overview">...</h1>
     ...
   </body>
   </html>
   ```

2. **Add a nav entry** in `_nav/_nima.ftl` linking to the new page:
   ```ftl
   <@nav url="/nima/archetypes" title="Archetypes">
   <ul>
     <li><a href="/nima/archetypes#section-id">Section name</a></li>
   </ul>
   </@nav>
   ```

3. **Update `llms.txt`** if the page covers content that AI agents should know about.

---

## Step-by-step: add a new library section

1. **Create the content directory and index page** — e.g. `mylib/index.html` (same structure as
   any other page, using the new base layout).

2. **Create the base layout** — `_layout/base-mylib.html` (copy an existing one and update):
   - `<var id="gitsource">` — GitHub repo URL
   - `bread1` — the library name and path
   - `<#include "/_nav/_mylib.ftl">` — the nav file to include

3. **Create the sidebar nav** — `_nav/_mylib.ftl` using `<@nav>` macros.

4. **Add an entry in `llms.txt`** under the appropriate heading so AI agents can discover the
   new documentation.

---

## Worked example

`nima/archetypes.html` is a complete example that demonstrates all the patterns above:
- `base-nima.html` layout with two breadcrumb levels
- Cross-page nav entry in `_nav/_nima.ftl`
- `<pre content="sh">` and `<pre content="java">` code blocks
- `<details>`/`<summary>` wrapping all Java source listings and the project structure tree
- A shields.io version badge
- FreeMarker `${avaje.nima.version}` version variable in a shell command
