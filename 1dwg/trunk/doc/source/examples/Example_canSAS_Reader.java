package org.scatteringsw.reader;

//########### SVN repository information ###################
//# $Date$
//# $Author$
//# $Revision$
//# $URL$
//# $Id$
//########### SVN repository information ###################

import java.util.List;

import javax.xml.bind.JAXBException;

TODO: this needs to be reworked!
For starters, there is no such net.smallangles.cansas1d.CanSas1dType.java
http://www.cansas.org/trac/ticket/32

import net.smallangles.cansas1d.CanSas1dType;
import net.smallangles.cansas1d.SASdataType;
import net.smallangles.cansas1d.SASentryType;
import net.smallangles.cansas1d.SASrootType;
import net.smallangles.cansas1d.SASentryType.Run;

/**
 * Demonstrate how to use the Java binding for the 
 * cansas1d/1.0 standard XML format for reduced 
 * small-angle scattering data.
 * 
 */
public class Example_canSAS_Reader {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CanSas1dType reader = new CanSas1dType();

		try {
			// open the XML file and load contents into a Java data structure
			SASrootType sasRoot = reader.open("java-test.xml");

			// canSAS XML file is now loaded in memory
			int numEntries = sasRoot.getSASentry().size();
			System.out.println("SASentry elements: " + numEntries);

			for (int i = 0; i < numEntries; i++ ) {
				System.out.println("SASentry");

				SASentryType sasEntry = sasRoot.getSASentry().get(i);
				System.out.printf("Title:\t%s\n", sasEntry.getTitle());

				List<SASentryType.Run> runs = sasEntry.getRun();
				System.out.printf("#Runs:\t%d\n", runs.size());

				for( int j = 0; j < runs.size(); j++ ) {
					Run run = (Run) runs.get(j);
					System.out.printf("Run@name:\t%s\n", run.getName());
					System.out.printf("Run:\t%s\n", run.getValue());
				}

				List<SASdataType> datasets = sasEntry.getSASdata();
				System.out.printf("#SASdata:\t%d\n", sasEntry.getSASdata().size());

				for( int j = 0; j < runs.size(); j++ ) {
					SASdataType sasData = (SASdataType) datasets.get(j);
					System.out.printf("SASdata@name:\t%s\n", sasData.getName());
					System.out.printf("#points:\t%d\n", sasData.getIdata().size());
				}
				System.out.println();
			}

			System.out.println("the end.");

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			String fmt = "File not found: %s\n";
			System.out.printf(fmt, xmlFile);
		} catch (JAXBException e) {
			e.printStackTrace();
			String fmt = "Could not open (unmarshall) XML file: %s\n";
			System.out.printf(fmt, xmlFile);
		}
	}

}
