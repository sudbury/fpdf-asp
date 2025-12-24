<!--#include file="fpdf.asp"-->
<script language="jscript" runat="server">
function FPDFTagged()
{
	FPDF.call(this);

	this.PageMarkedContentListList = [];
	this.StructureRoot = null;
	this.LanguageCode = "en-US";
	this.CreationDate = null;
	this.XMPMetadataObjectNumber = 0;

	if (FPDFTagged.prototype.StartMarkedContent === void(0))
	{
		for (var prototypePropertyName in FPDF.prototype)
		{
			FPDFTagged.prototype[prototypePropertyName] = FPDF.prototype[prototypePropertyName];
		}
		FPDFTagged.prototype.InitializeMarkedContent = FPDFTagged_InitializeMarkedContent;
		FPDFTagged.prototype.StartMarkedContent = FPDFTagged_StartMarkedContent;
		FPDFTagged.prototype.StartLineBreakMarkedContent = FPDFTagged_StartLineBreakMarkedContent;
		FPDFTagged.prototype.StartArtifactLayoutMarkedContent = FPDFTagged_StartArtifactLayoutMarkedContent;
		FPDFTagged.prototype.FinishMarkedContent = FPDFTagged_FinishMarkedContent;
		FPDFTagged.prototype.CreateStructureElement = FPDFTagged_CreateStructureElement;
		FPDFTagged.prototype.ApplyStructureElementAttributesForTableHeaderScopeColumn = FPDFTagged_ApplyStructureElementAttributesForTableHeaderScopeColumn;
		FPDFTagged.prototype.ApplyStructureElementAttributesForList = FPDFTagged_ApplyStructureElementAttributesForList;
		FPDFTagged.prototype.SetLanguageCode = FPDFTagged_SetLanguageCode;
		FPDFTagged.prototype.GetProducer = FPDFTagged_GetProducer;
		FPDFTagged.prototype.GetCreationDate = FPDFTagged_GetCreationDate;
		FPDFTagged.prototype.ConvertDateToPDFDate = FPDFTagged_ConvertDateToPDFDate;
		FPDFTagged.prototype.ImageTagged = FPDFTagged_ImageTagged;
	}
	this.ExtendsCode("AddPage", FPDFTagged_AddPageExtended);
	this._putpages = FPDFTagged_putpages;
	this.ExtendsCode("_putresources", FPDFTagged_PutResourcesExtended);
	this.ExtendsCode("_putcatalog", FPDFTagged_PutCatalogExtended);
	this._begindoc = FPDFTagged_begindoc;
	this._putinfo = FPDFTagged_putinfo;
	this.Write = FPDFTagged_Write;
/*
Reserved object IDs:
ID	gen.	description
1	0	/Pages
2	0	resource dictionary for all pages, such as fonts
// Each page's object ID is (3 + 2 * pageIndex).
3+2	0	page object
4+2	0	page contents stream
*/
}

function FPDFTaggedStructureRoot()
{
	this.DocumentNode = null;

	/* Rendering bookkeeping. */
	this.ObjectID = 0;
	this.ObjectGeneration = 0;

	if (FPDFTaggedStructureRoot.prototype.Output === void(0))
	{
		FPDFTaggedStructureRoot.prototype.AllocateObjectNumbers = FPDFTaggedStructureRoot_AllocateObjectNumbers;
		FPDFTaggedStructureRoot.prototype.Output = FPDFTaggedStructureRoot_Output;
	}
}
function FPDFTaggedStructureRoot_AllocateObjectNumbers(nextObjectID)
{
	this.ObjectID = nextObjectID;
	nextObjectID++;
	var documentNode = this.DocumentNode;
	if(documentNode !== null)
	{
		nextObjectID = documentNode.AllocateObjectNumbers(nextObjectID);
	}
	return nextObjectID;
}
function FPDFTaggedStructureRoot_Output(FPDFTagged)
{
	var parentTreeOutput = [];
	var pageMarkedContentListList = FPDFTagged.PageMarkedContentListList;
	var pageCount = pageMarkedContentListList.length;
	parentTreeOutput.push("<</Nums [");
	for(var pageIndex = 0;  pageIndex < pageCount;  pageIndex++)
	{
		parentTreeOutput.push(pageIndex.toString());
		parentTreeOutput.push("[");
		var pageMarkedContentList = pageMarkedContentListList[pageIndex];
		var pageMarkedContentCount = pageMarkedContentList.length;
		var pageMarkedContentSeparator = "";
		for(var pageMarkedContentIndex = 0;  pageMarkedContentIndex < pageMarkedContentCount;  pageMarkedContentIndex++)
		{
			var pageMarkedContent = pageMarkedContentList[pageMarkedContentIndex];
			parentTreeOutput.push(pageMarkedContentSeparator);
			parentTreeOutput.push(pageMarkedContent.ObjectID.toString());
			parentTreeOutput.push(" ");
			parentTreeOutput.push(pageMarkedContent.ObjectGeneration.toString());
			parentTreeOutput.push(" R");
			pageMarkedContentSeparator = " ";
		}
		parentTreeOutput.push("]");
	}
	parentTreeOutput.push("]>>");

	var documentNode = this.DocumentNode;
	if(documentNode !== null)
	{
		FPDFTagged._newobj();
		FPDFTagged._out("<</Type /StructTreeRoot /K " + documentNode.ObjectID.toString() + " " + documentNode.ObjectGeneration.toString() + " R /ParentTree " + parentTreeOutput.join(String()) + " /ParentTreeNextKey " + pageCount.toString() + ">>");
		FPDFTagged._out("endobj");
		documentNode.Output(FPDFTagged);
	}
}

function FPDFTaggedStructureNode()
{
	this.Parent = null;
	this.Tag = ""; /* Leaf tag. */
	this.KidNodeList = [];
	this.AlternativeText = null;
	this.AttributeDirectory = null;

	this.PageIndex = 0;

	/* Rendering bookkeeping. */
	this.ObjectID = 0;
	this.ObjectGeneration = 0;

	if (FPDFTaggedStructureNode.prototype.Output === void(0))
	{
		FPDFTaggedStructureNode.prototype.AllocateObjectNumbers = FPDFTaggedStructureNode_AllocateObjectNumbers;
		FPDFTaggedStructureNode.prototype.WriteKidReference = FPDFTaggedStructureNode_WriteKidReference;
		FPDFTaggedStructureNode.prototype.Output = FPDFTaggedStructureNode_Output;
		FPDFTaggedStructureNode.prototype.AppendNode = FPDFTaggedStructureNode_AppendNode;
		FPDFTaggedStructureNode.prototype.SetAlternativeText = FPDFTaggedStructureNode_SetAlternativeText;
	}
}

function FPDFTaggedStructureNode_AllocateObjectNumbers(nextObjectID)
{
	this.ObjectID = nextObjectID;
	nextObjectID++;
	var kidNodeList = this.KidNodeList;
	var kidNodeCount = kidNodeList.length;
	for(var kidNodeIndex = 0;  kidNodeIndex < kidNodeCount;  kidNodeIndex++)
	{
		nextObjectID = kidNodeList[kidNodeIndex].AllocateObjectNumbers(nextObjectID);
	}
	return nextObjectID;
}

function FPDFTaggedStructureNode_WriteKidReference(kidOutput)
{
	kidOutput.push(this.ObjectID.toString());
	kidOutput.push(" ");
	kidOutput.push(this.ObjectGeneration.toString());
	kidOutput.push(" R");
}

function FPDFTaggedStructureNode_Output(FPDFTagged)
{
	var kidNodeList = this.KidNodeList;
	var kidNodeCount = kidNodeList.length;
	var kidOutput = [];
	var kidSeparator = "[";
	for(var kidNodeIndex = 0;  kidNodeIndex < kidNodeCount;  kidNodeIndex++)
	{
		var kid = kidNodeList[kidNodeIndex];
		kidOutput.push(kidSeparator);
		kid.WriteKidReference(kidOutput);
		kidSeparator = " ";
	}
	var attributeOutput;
	var attributeDirectory = this.AttributeDirectory;
	if(attributeDirectory !== null)
	{
		attributeOutput = [];
		var attributeSeparator = String();
		for(var attributeKey in attributeDirectory)
		{
			attributeOutput.push(attributeSeparator);
			attributeOutput.push(attributeKey);
			attributeOutput.push(" ");
			attributeOutput.push(attributeDirectory[attributeKey]);
			attributeSeparator = " ";
		}
	}
	else
	{
		attributeOutput = null;
	}

	var parentNode = this.Parent;

	FPDFTagged._newobj();
	FPDFTagged._out("<</Type /StructElem /S /" + this.Tag + " /Pg " + (3 + this.PageIndex * 2).toString() + " 0 R /P " + parentNode.ObjectID.toString() + " " + parentNode.ObjectGeneration.toString() + " R /K " + kidOutput.join(String()) + "]" + ((attributeOutput !== null) ? (" /A [<<" + attributeOutput.join(String()) + ">>]") : ("")) + ((this.AlternativeText !== null) ? (" /Alt " + FPDFTagged._textstring(this.AlternativeText)) : ("")) + ">>");
	FPDFTagged._out("endobj");
	for(var kidNodeIndex = 0;  kidNodeIndex < kidNodeCount;  kidNodeIndex++)
	{
		var kid = kidNodeList[kidNodeIndex];
		kid.Output(FPDFTagged);
	}
}

function FPDFTaggedStructureNode_AppendNode(node)
{
	node.Parent = this;
	this.KidNodeList.push(node);
}

function FPDFTaggedStructureNode_SetAlternativeText(alternativeText)
{
	this.AlternativeText = alternativeText;
}

function FPDFTaggedMarkedContentNode()
{
	FPDFTaggedStructureNode.call(this);

	this.MarkedContentID = 0;

	if (FPDFTaggedMarkedContentNode.prototype.Output === void(0))
	{
		for (var prototypePropertyName in FPDFTaggedStructureNode.prototype)
		{
			FPDFTaggedMarkedContentNode.prototype[prototypePropertyName] = FPDFTaggedStructureNode.prototype[prototypePropertyName];
		}
		FPDFTaggedMarkedContentNode.prototype.Output = FPDFTaggedMarkedContentNode_Output;
	}
}

function FPDFTaggedMarkedContentNode_Output(FPDFTagged)
{
	var attributeOutput;
	var attributeDirectory = this.AttributeDirectory;
	if(attributeDirectory !== null)
	{
		attributeOutput = [];
		var attributeSeparator = String();
		for(var attributeKey in attributeDirectory)
		{
			attributeOutput.push(attributeSeparator);
			attributeOutput.push(attributeKey);
			attributeOutput.push(" ");
			attributeOutput.push(attributeDirectory[attributeKey]);
			attributeSeparator = " ";
		}
	}
	else
	{
		attributeOutput = null;
	}

	var parentNode = this.Parent;

	FPDFTagged._newobj();
	FPDFTagged._out("<</Type /StructElem /S /" + this.Tag + " /Pg " + (3 + this.PageIndex * 2).toString() + " 0 R /P " + parentNode.ObjectID.toString() + " " + parentNode.ObjectGeneration.toString() + " R /K " + this.MarkedContentID.toString() + ((attributeOutput !== null) ? (" /A [<<" + attributeOutput.join(String()) + ">>]") : ("")) + ((this.AlternativeText !== null) ? (" /Alt " + FPDFTagged._textstring(this.AlternativeText)) : ("")) + ">>");
	FPDFTagged._out("endobj");
}

function FPDFTagged_InitializeMarkedContent()
{
	var structureRoot = new FPDFTaggedStructureRoot();
	this.StructureRoot = structureRoot;
	var documentNode = new FPDFTaggedStructureNode();
	structureRoot.DocumentNode = documentNode;
	documentNode.Parent = structureRoot;
	documentNode.Tag = "Document";
	return documentNode;
}

function FPDFTagged_StartMarkedContent(tag)
{
	var pageIndex = this.page - 1;
	var pageMarkedContentList = this.PageMarkedContentListList[pageIndex];
	var markedContentID = pageMarkedContentList.length;
	var markedContentNode = new FPDFTaggedMarkedContentNode();
	markedContentNode.PageIndex = pageIndex;
	markedContentNode.MarkedContentID = markedContentID;
	markedContentNode.Tag = tag;
	pageMarkedContentList.push(markedContentNode);
	this._out("/" + tag + " <</MCID " + markedContentID.toString() + ">> BDC");
	return markedContentNode;
}

function FPDFTagged_StartLineBreakMarkedContent()
{
	this._out("/Span <</ActualText <0D0A>>> BDC");
}

function FPDFTagged_StartArtifactLayoutMarkedContent()
{
	this._out("/Artifact <</Type /Layout>> BDC");
}

function FPDFTagged_FinishMarkedContent()
{
	this._out("EMC");
}

function FPDFTagged_CreateStructureElement(tagName)
{
	var elementNode = new FPDFTaggedStructureNode();
	elementNode.Tag = tagName;
	return elementNode;
}

function FPDFTagged_ApplyStructureElementAttributesForTableHeaderScopeColumn(markedContentNode)
{
	var attributeDirectory = markedContentNode.AttributeDirectory;
	if(attributeDirectory === null)
	{
		attributeDirectory = {};
		markedContentNode.AttributeDirectory = attributeDirectory;
	}
	attributeDirectory["/O"] = "/Table";
	attributeDirectory["/Scope"] = "/Column";
}

function FPDFTagged_ApplyStructureElementAttributesForList(markedContentNode, listNumbering)
{
	var attributeDirectory = markedContentNode.AttributeDirectory;
	if(attributeDirectory === null)
	{
		attributeDirectory = {};
		markedContentNode.AttributeDirectory = attributeDirectory;
	}
	attributeDirectory["/O"] = "/List";
	attributeDirectory["/ListNumbering"] = "/" + listNumbering;
}

function FPDFTagged_begindoc()
{
	this.state=1;
	this._out("%PDF-1.7");
}


function FPDFTagged_ImageTagged(xfile , xx , xy , xw , xh , xtype , xlink, imageMarkedContentNode)
{
		if (arguments.length<5){xh=0};
		if (arguments.length<6){xtype=""};
		if (arguments.length<7){xlink=""};

	var lib = new clib();
		if(!lib.isset(this.images[xfile]))
			{
			if(xtype=="")
				{
				xpos=lib.strrpos(xfile,".");
				if(!xpos)this.Error("Image file has no extension and no type was specified: " + xfile);
				xtype=lib.substr(xfile,xpos+1);
				}
			xtype=xtype.toLowerCase();
			if(xtype=="jpg" || xtype=="jpeg")xinfo=this._parsejpg(xfile);
			else this.Error("Unsupported image file type: " + xtype);
			xinfo["i"]=lib.count(this.images)+1;
			 this.images[xfile]=xinfo;
			}
		else
		xinfo=this.images[xfile];
		if(xw==0)xw=xh*xinfo["w"]/xinfo["h"];
		if(xh==0)xh=xw*xinfo["h"]/xinfo["w"];

	var imageWidth = xw*this.k;
	var imageHeight = xh*this.k;
	var imageLeft = xx*this.k;
	var imageBottom = (this.h-(xy+xh))*this.k;
	var imageRight = imageLeft + imageWidth;
	var imageTop = imageBottom + imageHeight;

	var attributeDirectory = imageMarkedContentNode.AttributeDirectory;
	if(attributeDirectory === null)
	{
		attributeDirectory = {};
		imageMarkedContentNode.AttributeDirectory = attributeDirectory;
	}
	attributeDirectory["/O"] = "/Layout";
	attributeDirectory["/Placement"] = "/Block";
	attributeDirectory["/BBox"] = "[" + imageLeft.toString() + " " + imageBottom.toString() + " " + imageRight.toString() + " " + imageTop.toString() + "]";

		 this._out(lib.sprintf("q %.2f 0 0 %.2f %.2f %.2f cm /I%d Do Q", imageWidth, imageHeight, imageLeft, imageBottom, xinfo["i"]));
		if(xlink)this.Link(xx,xy,xw,xh,xlink);
}

function FPDFTagged_AddPageExtended(xorientation)
{
	this.PageMarkedContentListList.push([]);
}

function FPDFTagged_Write(xh , xtxt , xlink)
{
		var xi;
		if (arguments.length<3) {xlink=""};

	var lib = new clib();

		var xcw=this.CurrentFont["cw"];
		var xw=(this.w)-(this.rMargin)-(this.x);
		var xwmax=(xw-2*this.cMargin)*1000/this.FontSize;
		var xs=lib.str_replace("\r","",xtxt);
		var xnb=lib.strlen(xs);
		var xsep=-1;
		var xi=0;
		var xj=0;
		var xl=0;
		var xnl=1;
		while(xi<xnb)
			{
			xc=xs.charAt(xi)
			if(xc=="\n")
				{
				this.Cell(xw,xh,lib.substr(xs,xj,xi-xj),0,2,"",0,xlink);
				xi++;
				xsep=-1;
				xj=xi;
				xl=0;
				if(xnl==1)
					{
					 this.x=this.lMargin;
					xw=this.w-this.rMargin-this.x;
					xwmax=(xw-2*this.cMargin)*1000/this.FontSize;
					}
				xnl++;
				continue;
				}
			if(xc==" ")
				{
				xsep=xi;
				xls=xl;
				}

			xl+=(xcw[xs.charAt(xi)]);
			if(xl>xwmax)
				{
				if(xsep==-1)
					{
					if(this.x>this.lMargin)
						{
						 this.x=this.lMargin;
						 this.y+=xh;
						xw=this.w-this.rMargin-this.x;
						xwmax=(xw-2*this.cMargin)*1000/this.FontSize;
						xi++;
						xnl++;
						continue;
						}
					if(xi==xj)xi++;
					 this.Cell(xw,xh,lib.substr(xs,xj,xi-xj),0,2,"",0,xlink);
					}
				else

					{
					 this.Cell(xw,xh,lib.substr(xs,xj,xsep-xj),0,2,"",0,xlink);
						this._out("BT ( ) Tj ET");
					xi=xsep+1;
					}
				xsep=-1;
				xj=xi;
				xl=0;
				if(xnl==1)
					{
					 this.x=this.lMargin;
					xw=this.w-this.rMargin-this.x;
					xwmax=(xw-2*this.cMargin)*1000/this.FontSize;
					}
				xnl++;
				}
			else {xi++}
			}
		if(xi!=xj)this.Cell(xl/1000*this.FontSize,xh,lib.substr(xs,xj),0,0,"",0,xlink);
}

function FPDFTagged_SetLanguageCode(languageCode)
{
	this.LanguageCode = languageCode;
}

function FPDFTagged_GetProducer()
{
	return "FPDF for ASP v." + this.Version + " [more at https://github.com/matheuseduardo/fpdf-asp]";
}

function FPDFTagged_GetCreationDate()
{
	var creationDate = this.CreationDate;
	if(creationDate === null)
	{
		creationDate = new Date();
		this.CreationDate = creationDate;
	}
	return creationDate;
}
function FPDFTagged_ConvertDateToPDFDate(targetDate)
{
	var yearText = targetDate.getUTCFullYear().toString();
	var yearPaddingDigits = 4 - yearText.length;
	if (0 < yearPaddingDigits)
	{
		yearText = new Array(yearPaddingDigits + 1).join("0") + yearText;
	}
	var monthText = (targetDate.getUTCMonth() + 1).toString();
	if (monthText.length === 1)
	{
		monthText = "0" + monthText;
	}
	var dayText = targetDate.getUTCDate().toString();
	if (dayText.length === 1)
	{
		dayText = "0" + dayText;
	}
	var hourText = targetDate.getUTCHours().toString();
	if (hourText.length === 1)
	{
		hourText = "0" + hourText;
	}
	var minuteText = targetDate.getUTCMinutes().toString();
	if (minuteText.length === 1)
	{
		minuteText = "0" + minuteText;
	}
	var secondText = targetDate.getUTCSeconds().toString();
	if (secondText.length === 1)
	{
		secondText = "0" + secondText;
	}
	var targetDateTimeText = "D:" + yearText + monthText + dayText + hourText + minuteText + secondText + "Z";
	return targetDateTimeText;
}

function FPDFTagged_putinfo()
{
	var lib = new clib();
	var creationDate = this.GetCreationDate();
	var producer = this.GetProducer();
	this._out("/Producer " + this._textstring(producer));
	if(!lib.empty(this.title))this._out("/Title " + this._textstring(this.title));
	if(!lib.empty(this.subject))this._out("/Subject " + this._textstring(this.subject));
	if(!lib.empty(this.author))this._out("/Author " + this._textstring(this.author));
	if(!lib.empty(this.keywords))this._out("/Keywords " + this._textstring(this.keywords));
	if(!lib.empty(this.creator))this._out("/Creator " + this._textstring(this.creator));
	this._out("/CreationDate " + this._textstring(this.ConvertDateToPDFDate(creationDate)));
}

function FPDFTagged_putpages()
{
	var lib = new clib();
	/* Add the Tabs entry and append the structure tree. */
		xnb=this.page;
		if(!lib.empty(this.AliasNbPages))
			{
			for(xn=1;xn<=xnb;xn++)this.pages[xn]=lib.str_replace(this.AliasNbPages,xnb,this.pages[xn]);
			}
		if(this.DefOrientation=="P")
			{
			xwPt=this.fwPt;
			xhPt=this.fhPt;
			}
		else

			{
			xwPt=this.fhPt;
			xhPt=this.fwPt;
			}
		xfilter=(this.compress)?"/Filter /FlateDecode ":
		"";
		for(xn=1;xn<=xnb;xn++)
			{
			 this._newobj();
			 this._out("<</Type /Page");
			 this._out("/Parent 1 0 R");
			if(lib.isset(this.OrientationChanges[xn]))this._out(lib.sprintf("/MediaBox [0 0 %.2f %.2f]",xhPt,xwPt));
			 this._out("/Resources 2 0 R");
			if(this.PageLinks[xn])
				{
				xannots="/Annots [";
				for(xpl in this.PageLinks[xn])
					{
					xpl = this.PageLinks[xn][xpl]
					xrect=lib.sprintf("%.2f %.2f %.2f %.2f",xpl[0],xpl[1],xpl[0]+xpl[2],xpl[1]-xpl[3]);
					xannots+="<</Type /Annot /Subtype /Link /Rect [" + xrect + "] /Border [0 0 0] ";
					if(lib.is_string(xpl[4]))xannots+="/A <</S /URI /URI " + this._textstring(xpl[4]) + ">>>>";
					else
						{
						xl=this.links[xpl[4]];
						xh=(this.OrientationChanges[xl.charAt(0)]?xwPt:xhPt);
						xannots+=lib.sprintf("/Dest [%d 0 R /XYZ 0 %.2f null]>>",1+2*xl[0],xh-xl[1]*this.k);
						}
					}
				 this._out(xannots + "]");
				}
			this._out("/Tabs /S");
			var pageIndex = xn - 1;
			this._out("/StructParents " + pageIndex.toString());
			 this._out("/Contents " + (this.n+1) + " 0 R>>");
			 this._out("endobj");
			 xp=(this.compress)?this.gzcompress(this.pages[xn]):
			 this.pages[xn];
			 this._newobj();
			 this._out("<<" + xfilter + "/Length " + lib.strlen(xp) + ">>");
			 this._putstream(xp);
			 this._out("endobj");
			}
		 this.offsets[1]=lib.strlen(this.buffer);
		 this._out("1 0 obj");
		 this._out("<</Type /Pages");
		xkids="/Kids [";
		for(xi=0;xi<xnb;xi++)xkids+=(3+2*xi) + " 0 R ";
		 this._out(xkids + "]");
		 this._out("/Count " + xnb);
		 this._out(lib.sprintf("/MediaBox [0 0 %.2f %.2f]",xwPt,xhPt));
		 this._out(">>");
		 this._out("endobj");
	var structureRoot = this.StructureRoot;
	if(structureRoot !== null)
	{
		structureRoot.AllocateObjectNumbers(this.n + 1);
		structureRoot.Output(this);
	}
}

function FPDFTagged_PutResourcesExtended()
{
	function XMLEncode(text)
	{
		return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
	}

	function XMLAttributeEncode(text)
	{
		return text.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
	}

	var targetDate = this.GetCreationDate();
	var yearText = targetDate.getUTCFullYear().toString();
	var yearPaddingDigits = 4 - yearText.length;
	if (0 < yearPaddingDigits)
	{
		yearText = new Array(yearPaddingDigits + 1).join("0") + yearText;
	}
	var monthText = (targetDate.getUTCMonth() + 1).toString();
	if (monthText.length === 1)
	{
		monthText = "0" + monthText;
	}
	var dayText = targetDate.getUTCDate().toString();
	if (dayText.length === 1)
	{
		dayText = "0" + dayText;
	}
	var hourText = targetDate.getUTCHours().toString();
	if (hourText.length === 1)
	{
		hourText = "0" + hourText;
	}
	var minuteText = targetDate.getUTCMinutes().toString();
	if (minuteText.length === 1)
	{
		minuteText = "0" + minuteText;
	}
	var secondText = targetDate.getUTCSeconds().toString();
	if (secondText.length === 1)
	{
		secondText = "0" + secondText;
	}
	var targetDateTimeText = yearText + "-" + monthText + "-" + dayText + "T" + hourText + ":" + minuteText + ":" + secondText + "Z";

	var lib = new clib();

	var metadataOutput = [];
	metadataOutput.push("<?xpacket begin=\"﻿\" id=\"W5M0MpCehiHzreSzNTczkc9d\"?>\
<x:xmpmeta xmlns:x=\"adobe:ns:meta/\">\
<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">\
<rdf:Description rdf:about=\"\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:xmp=\"http://ns.adobe.com/xap/1.0/\">\
<dc:language><rdf:Bag><rdf:li>");
	metadataOutput.push(XMLEncode(this.LanguageCode));
	metadataOutput.push("</rdf:li></rdf:Bag></dc:language>\
<dc:title>\
<rdf:Alt>\
<rdf:li xml:lang=\"");
	metadataOutput.push(XMLAttributeEncode(this.LanguageCode));
	metadataOutput.push("\">");
	metadataOutput.push(XMLEncode(this.title));
	metadataOutput.push("</rdf:li>\
</rdf:Alt>\
</dc:title>\
</rdf:Description>\
<rdf:Description rdf:about=\"\" xmlns:pdf=\"http://ns.adobe.com/pdf/1.3/\" xmlns:xmp=\"http://ns.adobe.com/xap/1.0/\">\
<pdf:Producer>");
	metadataOutput.push(XMLEncode(this.GetProducer()));
	metadataOutput.push("</pdf:Producer>\
<xmp:CreateDate>");
	metadataOutput.push(XMLEncode(targetDateTimeText));
	metadataOutput.push("</xmp:CreateDate>\
</rdf:Description>\
</rdf:RDF>\
</x:xmpmeta>\
<?xpacket end=\"w\"?>");
	var metadata = metadataOutput.join(String());

	this._newobj();
	this._out("<</Length " + lib.strlen(metadata) + ">>");
	this._putstream(metadata);
	this._out("endobj");

	this.XMPMetadataObjectNumber = this.n;
}

function FPDFTagged_PutCatalogExtended()
{
	var structureRoot = this.StructureRoot;
	if(structureRoot !== null)
	{
		this._out("/StructTreeRoot " + structureRoot.ObjectID.toString() + " " + structureRoot.ObjectGeneration.toString() + " R");
	}
	this._out("/Lang " + this._textstring(this.LanguageCode));
	this._out("/MarkInfo <</Marked true>>");
	this._out("/Metadata " + this.XMPMetadataObjectNumber.toString() + " 0 R");
	this._out("/ViewerPreferences <</DisplayDocTitle true>>");
}
</script>