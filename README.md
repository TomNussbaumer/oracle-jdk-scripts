# oracle-jdk-scripts

Helper scripts to automatically fetch and extract Oracle JDK versions

### Usage

Getting Oracle JDKs is normally a cumbersome job.

  1. visit their website
  2. proceed through a number of pages
  3. accept the license
  4. download the JDK distribution
  5. step through some more pages to locate the API docs distribution
  6. accept the license
  7. download the API docs

Extracting the JDK is also cumbersome.

  1. extract the JDK distribution to the destination directory
  2. extract the sources embedded in the JDK distribution
  3. extract the API docs to the some destination directory

That get's **REALLY** boring, when you have to do it on a regular bases (updates).

Suppose you have a directory structure like this:

```
/some/where/
         downloads/
         jdks/
```

The following to commands perform the whole fetch and extract steps automatically.

```shell
./fetch-oracle-jdk-and-docs.sh /some/where/downloads/
./extract-jdks.sh /some/where/downloads/ /some/where/jdks/
```

### Important Notes

Actually script `fetch-oracle-jdk-and-docs.sh` needs to be modified whenever a new version arrives. Its very simple to do that modification, but it's still far from perfect.

The fetching script also fetches the windows distribution. If you don't need the windows binary remove it from the script.

### Possible Improvements

  * auto-detect the latest version in `fetch-oracle-jdk-and-docs.sh` and download it
  * download the last N versions?
