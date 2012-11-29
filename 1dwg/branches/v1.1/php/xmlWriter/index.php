<?php

########### SVN repository information ###################
# $Date$
# $Author$
# $Revision$
# $URL$
# $Id$
########### SVN repository information ###################

##### GLOBALS #####################################################################

$tool['titleStr'] = "canSAS1d/1.0 XML formatter";
$tool['svnid'] = "\$Id$";
$tool['email'] = "jemian@anl.gov";
$tool['postMethod'] = 'POST';
$tool['postAction'] = 'index.php';
$tool['surveillance_file'] = './www/surveillance.xml';	// chmod 666
$tool['meta,desc'] = "Formats SAS data in the cansas1d/1.0 XML data format.";
$tool['meta,keys'] = "small-angle scattering, data format";
$tool['canSAS_URL'] = "http://www.smallangles.net/"
	. "wgwiki/index.php/cansas1d_documentation";

# here are the form variables and descriptions
$vars['title'] = 'Title';
$vars['run'] = 'Run';
$vars['sample_id'] = 'Sample ID';
$vars['sample_thickness'] = 'thickness (mm)';
$vars['sample_details'] = 'other sample details';
$vars['instrument_name'] = 'SAS instrument name';
$vars['instrument_radiation'] = '"neutron" or "xray" (no quotes)';
$vars['instrument_wavelength'] = 'Wavelength (A)';
$vars['detector_name'] = 'Detector name';
$vars['detector_SDD'] = 'sample-detector distance (m)';
$vars['SASnote'] = 'SASnote';
$vars['SASdata'] = 'SAS data (3 columns: Q I Idev)';

$process = 0;		// Should processing be run this time?
$post = array();    // processing parameters to be used

##### main body of code #####################################################################

# look for any input parameters
switch ($_SERVER["REQUEST_METHOD"]) {
	case "":  # command-line processing
		#$usage = 'usage: php ';
		#$usage .= $_SERVER['SCRIPT_FILENAME'];
		#$usage .= ' [undefined now]';
		exit("command line not supported now");
		break;
	case "GET":
		break;
	case "POST":
		$process = 1;
		foreach ($_REQUEST as $key => $value) {
			$post[$key] = $value;
		}
		break;
}

try {
   surveillance($post);	# make a log entry
} catch (Exception $e) {}

# process the request
if ($process == 1) {
	$result = prepare_cansasxml($post);
}

switch ($_SERVER["REQUEST_METHOD"]) {
	case "GET":
		$page = buildHtmlPage($post);
		print($page);
		break;
	case "POST":  # this is when the work gets done
		if ($post['result_style'] == 'Styled') {
			header("Content-Type: text/xml");
			print($result);
		}
		if ($post['result_style'] == 'Raw XML') {
			header("Content-Type: text/html");
			print("<pre>\n");
			print(htmlentities($result));			//  "<" to "&lt;" and similar
			print("</pre>\n");
		}
		break;
	case "":  # command-line interface works here
		print("No command-line interface at this time.");
		break;
}
#phpInfo();

####### function definitions ###################################################################


function buildHtmlPage($post) {
	global $tool;
	global $vars;

	$doc = new DOMDocument('1.0', 'UTF-8');

	$root = addElement($doc, $doc, 'html');
	addComment($doc, $root, $tool['titleStr']);

	#--start-header------------------------------------
	$head = addElement($doc, $root, 'head');
	addTextElement($doc, $head, 'title', $tool['titleStr']);
	$node = addElement($doc, $head, 'meta');
	addAttribute($node, 'http-equiv', 'Content-Type');
	addAttribute($node, 'content', 'text/html;charset=iso-8859-1');

	$node = addElement($doc, $head, 'meta');
	addAttribute($node, 'name', 'description');
	addAttribute($node, 'content', $tool['meta,desc']);

	$node = addElement($doc, $head, 'meta');
	addAttribute($node, 'name', 'keywords');
	addAttribute($node, 'content', $tool['meta,keys']);
	#--end-header------------------------------------

	#--start-body------------------------------------
	$body = addElement($doc, $root, 'body');
	addTextElement($doc, $body, 'h1', $tool['titleStr']);

	#--start-form------------------------------------
	addComment($doc, $body, ' start form ');
	$form = addElement($doc, $body, 'form');
	addAttribute($form, 'method', $tool['postMethod']);
	addAttribute($form, 'action', $tool['postAction']);

	addComment($doc, $form, ' start form table ');
	$table = addElement($doc, $form, 'table');
	addAttribute($table, 'border', '2');
	foreach ($vars as $index => $value) {
		$tr = addElement($doc, $table, 'tr');
		addTextElement($doc, $tr, 'td', $value);
		$td = addElement($doc, $tr, 'td');
		$input = addElement($doc, $td, 'input');
		addAttribute($input, 'type', 'text');
		addAttribute($input, 'size', '50');
		addAttribute($input, 'name', $index);
		addAttribute($input, 'value', $post[$index]);
	}
	addComment($doc, $form, ' end form table ');

	addComment($doc, $form, ' start form buttons ');

	foreach (array("Styled", "Raw XML") as $item) {
		$input = addTextElement($doc, $form, 'input', $item);
		addAttribute($input, 'type', 'radio');
		addAttribute($input, 'name', 'result_style');
		addAttribute($input, 'value', $item);
		if ($item == 'Styled') {
			addAttribute($input, 'checked', 'true');
		}
	}
	foreach (array("Submit", "Reset") as $item) {
		$input = addElement($doc, $form, 'input');
		addAttribute($input, 'type', strtolower($item));
		addAttribute($input, 'value', $item);
	}
	addComment($doc, $form, ' end form buttons ');

	addComment($doc, $body, ' end form ');
	#--end-form------------------------------------

	#--start-content------------------------------------
	addElement($doc, $body, 'hr');
	addComment($doc, $body, ' start content ');

	addTextElement($doc, $body, 'h2', 'Overview');
	$p = addElement($doc, $body, 'p');
	addText($doc, $p, 
		'This WWW form provides a means to convert ' .
		'one dimensional small-angle scattering data into ' .
		'the XML format described by the '
	);
	$a = addElement($doc, $p, 'a');
	addAttribute($a, 'href', $tool['canSAS_URL']);
	addText($doc, $a, 'cansas1d/1.0 standard');
	addText($doc, $p, 
		'.  The WWW form returns the data in the XML format.'
	);
	addTextElement($doc, $body, 'h2', 'Hints');
	$p = addElement($doc, $body, 'p');
	addText($doc, $p, 
		'The SASdata, delimited by white-space and/or commas, ' .
		'will be parsed in triples of '
	);
	addTextElement($doc, $p, 'tt', 'Q I Idev');
	addText($doc, $p, 
		'.  It is ' .
		'possible to copy/paste from a 3-column text file directly ' .
		'into the SASdata entry box.'
	);
	addTextElement($doc, $body, 'h2', 'Results');
	$p = addElement($doc, $body, 'p');
	addText($doc, $p, 
		'Output from the form can be either be formatted for nice display using the ' .
		'standard canSAS style sheet ("Styled" radiobutton) or as "Raw XML."  ' .
		'However, to see the raw XML output from Styled output, ' .
		'use the "View Source" capability of your browser.  '
	);

	addComment($doc, $body, ' end content ');
	#--end-content------------------------------------

	#--start-footer------------------------------------
	addElement($doc, $body, 'hr');
	addComment($doc, $body, ' start footer ');

	$small = addElement($doc, $body, 'small');
	addText($doc, $small, 'For information about this page, contact ');

	$node = addElement($doc, $small, 'a');
	addAttribute($node, 'href', 'mailto:' . $tool['email']);
	addText($doc, $node, $tool['email']);

	addElement($doc, $body, 'br');

	$idstr = trim(trim($tool['svnid'], "\$"));
	$small = addTextElement($doc, $body, 'small', $idstr);

	addComment($doc, $body, ' end footer ');
	#--end-footer------------------------------

	#--end-body------------------------------------

	#print($doc->saveXML());
	return(prettyXML($doc->saveXML()));
}


function prepare_cansasxml($post) {
	global $tool;

	$doc = new DOMDocument('1.0', 'UTF-8');

	$xslt = $doc->createProcessingInstruction('xml-stylesheet', 
		'type="text/xsl" href="cansasxml-html.xsl"');
	$doc->appendChild($xslt);

	$root = $doc->createElementNS('cansas1d/1.0','SASroot');
	$doc->appendChild($root);
	addComment($doc, $root, 'canSAS XML created by ' . $tool['titleStr']);

	$xsi_url = 'http://www.w3.org/2001/XMLSchema-instance';
	$schemaLocation = 'cansas1d/1.0 '
	   . 'http://svn.smallangles.net/svn/canSAS/1dwg/trunk/cansas1d.xsd';
	addAttribute($root, 'version', '1.0');
	addAttribute($root, 'xmlns:xsi', $xsi_url);
	addAttribute($root, 'xsi:schemaLocation', $schemaLocation);

	$entry = addElement($doc, $root, 'SASentry');
	addAttribute($entry, 'name', 'entry1');

	addTextElement($doc, $entry, 'Title', $post['title']);
	addTextElement($doc, $entry, 'Run', $post['run']);


	$sasdata = addElement($doc, $entry, 'SASdata');
	$data = preg_split("/[\s,]+/", trim($post['SASdata']));
	$rows = count($data)/3;
	for ($i = 0; $i < $rows; $i++) {
	  $idata = addElement($doc, $sasdata, 'Idata');
	  $node = addTextElement($doc, $idata, 'Q', $data[$i*3+0]);
	  addAttribute($node, 'unit', '1/A');
	  $node = addTextElement($doc, $idata, 'I', $data[$i*3+1]);
	  addAttribute($node, 'unit', '1/cm');
	  $node = addTextElement($doc, $idata, 'Idev', $data[$i*3+2]);
	  addAttribute($node, 'unit', '1/cm');
	}


	$sassample = addElement($doc, $entry, 'SASsample');
	addTextElement($doc, $sassample, 'ID', $post['sample_id']);
	$node = addTextElement($doc, $sassample, 'thickness', 
		$post['sample_thickness']);
	addAttribute($node, 'unit', 'mm');
	# other nodes belong here
	addTextElement($doc, $sassample, 'details', $post['sample_details']);

	$sasinstrument = addElement($doc, $entry, 'SASinstrument');
	addTextElement($doc, $sasinstrument, 'name', $post['instrument_name']);

	$sassource = addElement($doc, $sasinstrument, 'SASsource');
	addTextElement($doc, $sassource, 'radiation', 
		$post['instrument_radiation']);
	$node = addTextElement($doc, $sassource, 'wavelength', 
		$post['instrument_wavelength']);
	addAttribute($node, 'unit', 'A');

	$sascollimation = addElement($doc, $sasinstrument, 
		'SAScollimation');

	$sasdetector = addElement($doc, $sasinstrument, 'SASdetector');
	addTextElement($doc, $sasdetector, 'name', $post['detector_name']);

	$node = addTextElement($doc, $sasdetector, 'SDD', $post['detector_SDD']);
	addAttribute($node, 'unit', 'm');

	$sasprocess = addElement($doc, $entry, 'SASprocess');
	addTextElement($doc, $sasprocess, 'name', $tool['titleStr']);
	addTextElement($doc, $sasprocess, 'date', PRJ_mysqlDate('now') );

	$idstr = trim(trim($tool['svnid'], "\$"));
	$node = addTextElement($doc, $sasprocess, 'SASprocessnote', $idstr);
	addAttribute($node, 'name', 'svnid');

	$str = 'formatting of text data into canSAS XML 1D standard';
	$node = addTextElement($doc, $sasprocess, 'SASprocessnote', $str);
	addAttribute($node, 'name', 'titleStr');

	$sasnote = addElement($doc, $entry, 'SASnote');

	return(prettyXML($doc->saveXML()));
}


function surveillance($post) {
	global $tool;
	$tags = array(
		'REMOTE_HOST', 'REMOTE_ADDR', 'REQUEST_URI',
		'SCRIPT_FILENAME', 'REQUEST_METHOD',
		'HTTP_USER_AGENT', 'REQUEST_TIME'
	);
	$date = date('Y-m-d');
	$time = date('H:i:s');

	$doc = new DomDocument();
	$doc->Load($tool['surveillance_file']);
	$root = $doc->getElementsByTagName('cansasxml')->item(0);

	$entry = addElement($doc, $root, 'entry');
	addAttribute($entry, 'date', $date);
	addAttribute($entry, 'time', $time);

	$list = addElement($doc, $entry, 'sas_variables');
	foreach ($post as $key => $value) {
		if ($key != "result_style")  {
			$node = addTextElement($doc, $list, 'var', $value);
			addAttribute($node, 'name', $key);
		}
	}

	$list = addElement($doc, $entry, 'server_variables');
	foreach ($tags as $key) {
		$node = addElement($doc, $list, 'var');
		addAttribute($node, 'name', $key);
		if (strlen($_SERVER[$key])>0) {
			addText($doc, $node, $_SERVER[$key]);
		}
	}
	
	$fp = fopen($tool['surveillance_file'], 'w');
	fwrite($fp, prettyXML($doc->saveXML()));
	fclose($fp);
}


function addElement($doc, $parent, $tag, $prefix = '') {
	$node = $doc->createElement($tag, $prefix);
	$parent->appendChild($node);
	return($node);
}


function addAttribute($parent, $name, $value = '') {
	$attr = $parent->setAttribute($name, $value);
	$parent->appendChild($attr);
	return($attr);
}


function addText($doc, $parent, $text = '') {
	$node = $doc->createTextNode($text);
	$parent->appendChild($node);
	return($node);
}


function addComment($doc, $parent, $text = '') {
	$node = $doc->createComment($text);
	$parent->appendChild($node);
	return($node);
}


function addTextElement($doc, $parent, $tag, $text) {
	$node = addElement($doc, $parent, $tag);
	addText($doc, $node, $text);
	return($node);
}


function prettyXML($sXML) {
	# Thanks to Joachem Blok on http://us3.php.net/domdocument
	$doc = new DOMDocument();
	$doc->preserveWhiteSpace = false;
	$doc->formatOutput   = true;
	$doc->loadXML($sXML);
	return($doc->saveXML());
}


// PRJ_mysqlDate
// ===============
// standardized date as string in MySQL date format
//  returns a formatted string
// (relative to the given timebase)
// which can be rescanned by this routine
function PRJ_mysqlDate( $dateStr, $relative = "now" ) {
  $now = strtotime( $relative );
  $exact = strtotime ( $dateStr, $now );

  $dateArr = getdate( $exact );
  $ts = mktime($dateArr['hours'], $dateArr['minutes'], $dateArr['seconds'],
    $dateArr['mon'], $dateArr['mday'], $dateArr['year']);
  $dateArr = getdate( $ts );
  $str = sprintf ( "%04d-%02d-%02d %02d:%02d:%02d",
    $dateArr['year'], $dateArr['mon'], $dateArr['mday'],
    $dateArr['hours'], $dateArr['minutes'], $dateArr['seconds'] );
  return ( $str );
}

?>
