#!/bin/sh

echo "Creating PDFs..."
soffice --headless --convert-to pdf ise_01_intro_to_xml_tei.odp
soffice --headless --convert-to pdf ise_intro_handout.odt
echo "Creating PPTs..."
soffice --headless --convert-to ppt ise_01_intro_to_xml_tei.odp
echo "Creating Word docs..."
soffice --headless --convert-to docx ise_intro_handout.odt

