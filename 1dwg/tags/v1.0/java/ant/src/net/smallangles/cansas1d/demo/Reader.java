
//########### SVN repository information ###################
//# $Date$
//# $Author$
//# $Revision$
//# $URL$
//# $Id$
//########### SVN repository information ###################

package net.smallangles.cansas1d.demo;

import java.io.InputStream;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import net.smallangles.cansas1d.SASdataType;
import net.smallangles.cansas1d.SASentryType;
import net.smallangles.cansas1d.SASrootType;
import net.smallangles.cansas1d.SASentryType.Run;


/**
 * <p>
 * This class demonstrates one possible use of the 
 * JAXB 2.1 
 *  (<a href="https://jaxb.dev.java.net/">https://jaxb.dev.java.net/</a>)
 * binding for canSAS 1D XML files.
 * It is not needed for the interface.
 * BUT, it could be used as a basic reader, providing full access
 * to the contents of a small-angle scattering data file 
 * using just two lines:
 * <pre>
Reader rdr = new net.smallangles.cansas1d.demo.Reader();
SASrootType srt = rdr.loadXML(xmlFile);
</pre>
 * </p>
 * 
 * <p>
 * 	Built using JAXB 2.1 interface for eclipse:
 * <ul>
 *   <li>
 *   You need this ZIP file:
 * 	<pre>org.jvnet.jaxbw.zip</pre>
 *   </li>
 *   <li>
 *   from: 
 * 	<pre>https://jaxb-workshop.dev.java.net/plugins/eclipse/xjc-plugin.html</pre>
 *   </li>
 *   <li>
 *   or:
 * 	<pre>https://jaxb-workshop.dev.java.net/servlets/ProjectDocumentList?folderID=4962&expandFolder=4962&folderID=0</pre>
 *   </li>
 *   <li>
 *   canSAS: 
 * 	<pre>http://www.smallangles.net/wgwiki/index.php/1D_Data_Formats_Working_Group</pre>
 *   </li>
 * </ul>
 * If you use the JAXB 2.0 interface, the exception messages
 * will not be helpful to clarify that JAXB 2.1 should be used.
 * </p>
 * 
 * @version $Id$
 */
public class Reader {

	private static final String RES_DIR = "/resources/cansas1d/";
	private static final String JAXB_CONTEXT = "net.smallangles.cansas1d";
	public static final String SVN_ID = "$Id$";

	private JAXBContext jc;
	private JAXBElement<SASrootType> xmlJavaData;
	
	/**
	 * Open a cansas1d/1.0 file
	 * @param xmlFile
	 * @return SasRootType object (saves a second method call)
	 * @throws JAXBException 
	 */
	@SuppressWarnings( "unchecked" )
	public SASrootType loadXML(String xmlFile) throws JAXBException {
		// use the cansas1d/1.0 schema that is bound to a Java structure
		jc = JAXBContext.newInstance(JAXB_CONTEXT);
		Unmarshaller unmarshaller = jc.createUnmarshaller();

		// find the XML file as a resource in the JAR
		InputStream in = getClass().getResourceAsStream(xmlFile);
		if (in == null) {
			throw new IllegalArgumentException("InputStream cannot be null");
		}

		// load the XML file into a Java data structure
		xmlJavaData = (JAXBElement<SASrootType>) unmarshaller.unmarshal(in);
		return getSasRootType();
	}

	/**
	 * Describe the XML data in more detail than toString() method
	 * and print to stdout.
	 */
	public void full_report() {
		SASrootType srt = getSasRootType();

		for ( SASentryType entry : srt.getSASentry() ) {
			System.out.println("SASentry");
			System.out.printf("Title:\t%s\n", entry.getTitle());
			List<SASentryType.Run> runs = entry.getRun();
			System.out.printf("#Runs:\t%d\n", runs.size());
			for ( Run run : runs ) {
				System.out.printf("Run@name:\t%s\n", run.getName());
				System.out.printf("Run:\t%s\n", run.getValue());
			}
			List<SASdataType> datasets = entry.getSASdata();
			System.out.printf("#SASdata:\t%d\n", entry.getSASdata().size());
			for ( SASdataType sdt : datasets ) {
				System.out.printf("SASdata@name:\t%s\n", sdt.getName());
				System.out.printf("#points:\t%d\n", sdt.getIdata().size());
			}
			System.out.println();
		}
	}

	/**
	 * Subversion Id string
	 * @return Subversion Id string
	 */
	public String getSvnId() {
		return SVN_ID;
	}

	/**
	 * Data object at the root of the XML file
	 * @return SASroot object
	 */
	public SASrootType getSasRootType() {
		return xmlJavaData.getValue();
	}

	/**
	 * simple representation of data in memory
	 */
	public String toString() {
		SASrootType sasRootType = getSasRootType();
		return "SASentry elements: " + sasRootType.getSASentry().size();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("class: " + Reader.class.getCanonicalName());
		System.out.println("SVN ID: " + Reader.SVN_ID);

		String[] fileList = {
				RES_DIR + "1998spheres.xml",
				RES_DIR + "cs_collagen.xml"
		};
		for (String xmlFile : fileList) {
			System.out.println("\n\nFile: " + xmlFile);
			try {
				Reader rdr = new Reader();
				// load canSAS XML file into memory
				rdr.loadXML(xmlFile);

				System.out.println(rdr.toString());
				rdr.full_report();

				System.out.println("the end.");

			} catch (JAXBException e) {
				e.printStackTrace();
				String fmt = "Could not open (unmarshall) XML file: %s\n";
				System.out.printf(fmt, xmlFile);
			}
		}
	}

}
