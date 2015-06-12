#!/bin/bash

echo "Generating ISGML from TEI sample document."
saxon -s:samples/sample.xml -xsl:xsl/tei_to_ise.xsl -o:temp/sample.txt

