
//########### SVN repository information ###################
//# $Date$
//# $Author$
//# $Revision$
//# $URL$
//# $Id$
//########### SVN repository information ###################

package org.cansas.cansas1d.demo;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.cansas.cansas1d.SASdataType;
import org.cansas.cansas1d.SASentryType;
import org.cansas.cansas1d.SASentryType.Run;
import org.cansas.cansas1d.SASrootType;


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
Reader rdr = new org.cansas.cansas1d.demo.Reader();
SASrootType srt = rdr.loadXML(xmlFile);
 * 
 * @version $Id$
 */
public class Reader {

	private static final String RES_DIR = "./resources/cansas1d/";
	private static final String JAXB_CONTEXT = "org.cansas.cansas1d";
	public static final String SVN_ID = "$Id$";

	private JAXBContext jc;
	private JAXBElement<SASrootType> xmlJavaData;
	
	/**
	 * Open a cansas1d 1D file
	 *
	 * @param xmlFile
	 * @return SasRootType object (saves a second method call)
	 * @throws JAXBException 
	 * @throws FileNotFoundException 
	 */
	@SuppressWarnings( "unchecked" )
	public SASrootType loadXML(String xmlFile) throws JAXBException, FileNotFoundException {

		// use the cansas1d XML Schema that is bound to a Java structure
		jc = JAXBContext.newInstance(JAXB_CONTEXT);      // reference the namespace: 
		Unmarshaller unmarshaller = jc.createUnmarshaller();

		// find the XML file as a resource in the JAR
		InputStream in = new FileInputStream(new File(xmlFile));

		// load the XML file into a Java data structure
		xmlJavaData = (JAXBElement<SASrootType>) unmarshaller.unmarshal(in);
		
		return xmlJavaData.getValue();
	}

	/**
	 * Describe the XML data in more detail than toString() method
	 * and print to stdout.
	 */
	public void full_report(SASrootType srt) {
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
	 * simple representation of data in memory
	 */
	public String toString(SASrootType sasRoot) {
		return "SASentry elements: " + sasRoot.getSASentry().size();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("class: " + Reader.class.getCanonicalName());
		System.out.println("SVN ID: " + Reader.SVN_ID);

		String[] fileList = {
			RES_DIR + "cs_collagen.xml",
			RES_DIR + "1998spheres.xml",
			"cannot_find_this.xml"
		};
		for (String xmlFile : fileList) {
			System.out.println("\n\nFile: " + xmlFile);
			try {
				Reader rdr = new Reader();
				// load canSAS XML file into memory
				SASrootType srt = rdr.loadXML(xmlFile);

				System.out.println(rdr.toString(srt));
				rdr.full_report(srt);

				System.out.println("the end.");

			} catch (FileNotFoundException e) {
				// e.printStackTrace();
				String fmt = "File not found: %s\n";
				System.out.printf(fmt, xmlFile);
			} catch (JAXBException e) {
				// e.printStackTrace();
				String fmt = "Could not open (unmarshall) XML file: %s\n";
				System.out.printf(fmt, xmlFile);
			}
		}
	}

}
