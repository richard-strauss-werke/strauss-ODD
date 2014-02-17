strauss-ODD
===========

ODD and ODD-related files for TEI / MEI encoding at the Kritische Ausgabe der Werke von Richard Strauss

The schemata generated with this ODD target a form-based editing of TEI code in oXygen's Author Mode. In order to make documents created on basis of these schemata fully TEI conformant, they must be transformed by XSLT scripts created by the `make-acdc.xslt` script in the XSLT folder. 
 
Files
-----

- `build` - the target folder for files created on basis of the ODD: expanded ODDs, schemata, etc.

- `src` - ODD source folder 

    - `rswa.MAIN.odd.xml` - the ODD file (see below for build instructions with ant)

    Low-level edits of various TEI components (included in the ODD via xi:include):

    - `rswa.edits.classes.att.xml`
    - `rswa.edits.datatypes.xml`
    - `rswa.edits.elements.xml`
    - `rswa.edits.macros.xml`

    TEI extensions:

    - `rswa.extension.tasks.xml`
    - `rswa.extension.MEI.xml`
    - `rswa.extension.xinclude.xml`

    A copy of [Raffaele Viglianti's modified version of the MEI ODD](https://github.com/TEI-Music-SIG/tei-mei/):

    - `mei-source.xml`

- `xslt` - the xslt directory contains scripts for the transformation of internal TEI files used for production to TEI conformant published versions
 
    - `make-acdc.xslt` - a transformation script to be applied to an extended ODD; the resulting document will be a new transformation script which can be used to transform TEI documents from the internal formats to published versions
    - `rswa.xsl` - contains named templates referenced by the `equiv` elements in the ODD and used in the transformation from the internal document formats to published versions


Build instructions
------------------

Required to follow these instructions: 
- 1. ANT, 
- 2. an installation of the oXygen XML editor, which contains the TEI build scripts and the necessary JAR files (if you don't use oXygen, you can get the JARs and the TEI stylesheets separately).

Note: To ensure that the TEI script `odd2odd.xsl` can find the file `mei-source.xml`, either replace the source attributes in the file `src/rswa.extension.MEI.xml` by absolute paths, or, alternatively, copy `mei-source.xml` to `odd2odd.xsl`'s folder (for example, `C:/Program Files/Oxygen XML Editor 15/frameworks/tei/xml/tei/stylesheet/odds`); keep the copy in your strauss-ODD folder.

```
ant -f %buildfile% 
-lib %lib%/resolver.jar 
-lib %lib%/saxon9ee.jar 
-Dverbose=true 
-DdefaultSource=%defaultSource% 
-DinputFile=%inputFile% 
-Dlang=%lang% 
-DoutputFile=%outputFile% 
-DselectedSchema=%selectedSchema%
```

Example values:
- %buildfile% - `"C:\Program Files\Oxygen XML Editor 15\frameworks\tei\xml\tei\stylesheet\relaxng\build-to.xml"`
- %lib% - `"C:\Program Files\Oxygen XML Editor 15\lib"`
- %defaultSource% - `"\Program Files\Oxygen XML Editor 15\frameworks\tei\xml\tei\odd\p5subset.xml"`
- %inputFile% - `"C:\test\rswa.MAIN.odd.xml"`
- %lang% - `de`
- %outputFile% - `"C:\test\persons.rng"`
- %selectedSchema% - `schema.persons` (for a list of possible schemata, see the file `rswa.MAIN.odd.xml`.

It should also be possible to build a schema by applying a transformation scenario to the ODD in oXygen. In this case, add the selectedSchema parameter to the transformation settings.


Credits
-------

Based on the TEI P5 specifications at http://www.tei-c.org/release/xml/tei/odd/p5subset.xml, this ODD integrates Raffaele Viglianti's prefixed version of the MEI's "mei-source.xml" [tei-mei](https://github.com/TEI-Music-SIG/tei-mei/), the TEI-C's [XInclude ODD](http://www.tei-c.org/release/xml/tei/custom/odd/tei_xinclude.odd), and draws on specifications in Peter Stadler's [Carl-Maria-von-Weber-Gesamtausgabe ODDs](https://github.com/Edirom/WeGA-ODD).
