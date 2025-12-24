# fpdf-asp

ASP (classic) version of fpdf for PHP with accessibility tags.

Here's how to add certain accessibility tags to your PDF when pursuing WCAG compliance (an understanding of relevant portions of the PDF specification is recommended):

1. Change the created object from ``FPDF`` to ``FPDFTagged``
   ```vbscript
   Dim PDFWriter
   Set PDFWriter = CreateJsObject("FPDFTagged")
   ```
2. Before your first usage of marked content, initialize the ``Document`` top-level tag:
   ```vbscript
   Dim StructureDocument
   Set StructureDocument = PDFWriter.InitializeMarkedContent()
   ```
3. Add tags according to the following:
   - Surround your flat ``Cell`` or ``Write`` calls with the corresponding tag:
     ```vbscript
     Const CellHeight = 5
     Dim StructureHeadingOne
     Set StructureHeadingOne = PDFWriter.StartMarkedContent("H1")
     Call PDFWriter.Cell(0, CellHeight, "Document Title", 0, 0, "R", False, "")
     Call PDFWriter.FinishMarkedContent()
     Call StructureDocument.AppendNode(StructureHeadingOne)
     ```
   - Wrap line breaks with nested marked content:
     ```vbscript
     Dim StructureParagraph
     Set StructureParagraph = PDFWriter.StartMarkedContent("P")
     Call PDFWriter.Write(TextHeight, "Sam Pull", "")
     Call PDFWriter.StartLineBreakMarkedContent()
     Call PDFWriter.Ln("")
     Call PDFWriter.FinishMarkedContent()
     Call PDFWriter.Write(TextHeight, "123 Any St", "")
     Call PDFWriter.StartLineBreakMarkedContent()
     Call PDFWriter.Ln("")
     Call PDFWriter.FinishMarkedContent()
     Call PDFWriter.Write(TextHeight, "Anywhere, MA  01234", "")
     Call PDFWriter.FinishMarkedContent()
     Call StructureDocument.AppendNode(StructureParagraph)
     ```
   - Mark decorative lines as an artifact:
     ```vbscript
     Dim LeftMarginX
     LeftMarginX = PDFWriter.GetX()
     Call PDFWriter.SetX(-1)
     Dim PageBodyWidth
     PageBodyWidth = PDFWriter.GetX() + 1 - LeftMarginX - LeftMarginX
     Dim RightMarginX
     RightMarginX = PageBodyWidth + LeftMarginX ' Approximation for right margin.
     Call PDFWriter.StartArtifactLayoutMarkedContent()
     Call PDFWriter.Line(LeftMarginX, PDFWriter.GetY(), RightMarginX, PDFWriter.GetY())
     Call PDFWriter.FinishMarkedContent()
     ```
   - Tag images as figures by changing ``Image`` calls to ``ImageTagged`` and providing the marked content object:
     ```vbscript
     Dim StructureLogo
     Set StructureLogo = PDFWriter.StartMarkedContent("Figure")
     Call PDFWriter.ImageTagged("/logo.jpg", PDFWriter.GetX(), PDFWriter.GetY(), 30, 30, "JPEG", "", StructureLogo)
     Call PDFWriter.FinishMarkedContent()
     Call StructureLogo.SetAlternativeText("Organization logo.")
     Call StructureDocument.AppendNode(StructureLogo)
     ```
   - Create tables using structure elements:
     ```vbscript
     Const CellHeight = 30
     Const CellHeight = 5

     Dim StructureTable
     Set StructureTable = PDFWriter.CreateStructureElement("Table")
     Call StructureDocument.AppendNode(StructureTable)
     Dim StructureRow
     Set StructureRow = PDFWriter.CreateStructureElement("TR")
     Call StructureTable.AppendNode(StructureRow)
     Dim StructureCell

     Set StructureCell = PDFWriter.StartMarkedContent("TH")
     Call PDFWriter.ApplyStructureElementAttributesForTableHeaderScopeColumn(StructureCell)
     Call PDFWriter.Cell(CellWidth, CellHeight, "Cell Header", "B", 0, "L", True, "")
     Call PDFWriter.FinishMarkedContent()
     Call StructureRow.AppendNode(StructureCell)

     Set StructureRow = PDFWriter.CreateStructureElement("TR")
     Call StructureTable.AppendNode(StructureRow)

     Set StructureCell = PDFWriter.StartMarkedContent("TD")
     Call PDFWriter.Cell(CellWidth, CellHeight, "Cell Value", 0, 0, "L", True, "")
     Call PDFWriter.FinishMarkedContent()
     Call StructureRow.AppendNode(StructureCell)
     ```
   - Create lists using structure elements:
     ```vbscript
     Dim LeftMarginX
     LeftMarginX = PDFWriter.GetX()
     Call PDFWriter.SetX(-1)
     Dim PageBodyWidth
     PageBodyWidth = PDFWriter.GetX() + 1 - LeftMarginX - LeftMarginX
     Dim ListItemX
     ListItemX = PageBodyWidth * 0.1

     Const TextHeight = 5

     Dim StructureList
     Set StructureList = PDFWriter.CreateStructureElement("L")
     Call PDFWriter.ApplyStructureElementAttributesForList(StructureList, "Decimal")

     Dim StructureListItem
     Set StructureListItem = PDFWriter.CreateStructureElement("LI")
     Dim StructureListItemLabel
     Set StructureListItemLabel = PDFWriter.StartMarkedContent("Lbl")
     Call PDFWriter.Write(TextHeight, "1.", "")
     Call PDFWriter.FinishMarkedContent()
     Call StructureListItem.AppendNode(StructureListItemLabel)
     Call PDFWriter.SetX(ListItemX)
     Call PDFWriter.SetLeftMargin(ListItemX)
     Dim StructureListItemBody
     Set StructureListItemBody = PDFWriter.StartMarkedContent("LBody")
     Call PDFWriter.Write(TextHeight, "This is the first list item.", "")
     Call PDFWriter.FinishMarkedContent()
     Call StructureListItem.AppendNode(StructureListItemBody)
     Call StructureList.AppendNode(StructureListItem)
     Call PDFWriter.SetLeftMargin(LeftMarginX)
     Call PDFWriter.Ln("")

     Call StructureDocument.AppendNode(StructureList)
     ```

Hyperlinks aren't covered because the core engine renders the ``Annot`` dictionaries inline, so they aren't allocated an object ID for referencing from structure elements.

## Acknowledgements
* [A11y for FPDF – Do It Yourself](https://github.com/fawno/FPDF/discussions/31)
