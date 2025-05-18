# website-source

Source for the website documentation

## How to build the website

### 1. Clone website-source repo

```
git clone git@github.com:avaje/website-source.git
```

### 2. Make a destination directory

```bash
mkdir website-dest
```

### 2. Download avaje-website-generator-2.2.2.jar

- download https://repo1.maven.org/maven2/org/avaje/avaje-website-generator/2.2.2/avaje-website-generator-2.2.2.jar

### 3. run the website generator

```bash
java -jar avaje-website-generator-2.2.2.jar -s website-source/ -d website-dest/
```

This website generator will:

- generate content into website-dest
- continue to run (until CTRL-C) watching the source directory
- When any source file changes it will re-generate the changed content

### 4. setup npm live-server to serve the website-dest directory

1. install node.
2. run `npm install live-server -g`
3. run `live-server` in the website-dest directory to serve the content on localhost 8080.
