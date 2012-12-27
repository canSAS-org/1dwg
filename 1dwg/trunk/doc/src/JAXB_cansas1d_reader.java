/**
 *   ########### SVN repository information ###################
 *   # $Date$
 *   # $Author$
 *   # $Revision$
 *   # $HeadURL$
 *   # $Id$
 *   ########### SVN repository information ###################
 */
package jlake;

import java.io.File;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import cansas1d.SASdataType;
import cansas1d.SASentryType;
import cansas1d.SASrootType;
import cansas1d.SASentryType.Run;

/**
 * @author Pete Jemian
 * 
 */
public class JAXB_cansas1d_reader {

	/**
	 * @param args
	 */
	@SuppressWarnings("unchecked")
	public static void main(String[] args) {
		JAXBContext jc;
		String xmlFile;
//		xmlFile = "cs_af1410.xml";
		xmlFile = "1998spheres.xml";
		try {
			// use the cansas1d/1.0 schema that is bound to a Java structure
			jc = JAXBContext.newInstance("cansas1d");
			Unmarshaller unmarshaller = jc.createUnmarshaller();
			// open the XML into a Java data structure
			JAXBElement&lt;SASrootType> xmlJavaData = (JAXBElement&lt;SASrootType>) unmarshaller
					.unmarshal(new File(xmlFile));
			// canSAS XML file is now loaded in memory
			SASrootType sasRootType = xmlJavaData.getValue();
			int numEntries = sasRootType.getSASentry().size();
			System.out.println("SASentry elements: " + numEntries);
			for( int i = 0; i &lt; numEntries; i++ ) {
				System.out.println("SASentry");
				SASentryType entry = sasRootType.getSASentry().get(i);
				System.out.printf("Title:\t%s\n", entry.getTitle());
				List&lt;SASentryType.Run> runs = entry.getRun();
				System.out.printf("#Runs:\t%d\n", runs.size());
				for( int j = 0; j &lt; runs.size(); j++ ) {
					Run run = (Run) runs.get(j);
					System.out.printf("Run@name:\t%s\n", run.getName());
					System.out.printf("Run:\t%s\n", run.getValue());
				}
				List&lt;SASdataType> datasets = entry.getSASdata();
				System.out.printf("#SASdata:\t%d\n", entry.getSASdata().size());
				for( int j = 0; j &lt; runs.size(); j++ ) {
					SASdataType sdt = (SASdataType) datasets.get(j);
					System.out.printf("SASdata@name:\t%s\n", sdt.getName());
					System.out.printf("#points:\t%d\n", sdt.getIdata().size());
				}
				System.out.println();
			}

			System.out.println("the end.");

		} catch (JAXBException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.printf("Could not open (unmarshall) XML file: %s\n", xmlFile);
		}
	}

}
