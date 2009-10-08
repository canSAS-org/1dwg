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
import cansas1d.SASdetectorType;
import cansas1d.SASentryType;
import cansas1d.SASinstrumentType;
import cansas1d.SASrootType;
import cansas1d.SASentryType.Run;


/**
 * @author Pete Jemian
 * 
 */
public class GetSASdata {


	private static SASrootType sasRoot;		// SAS data (from cansas1d/1.0 XML file)
	private static double[] Qsas;			// input Q
	private static double[] Isas;			// input I (slit-smeared)
	private static double[] Idev;			// input Idev (slit-smeared)
	private static double[] Ismr;			// calculated I slit-smeared
	private static double[] Idsm;			// calculated I desmeared
	private static double[] IdsmDev;		// calculated Idev desmeared
	private static double   slit_length;


	/**
	 * @param xmlPropertyFile
	 */
	public GetSASdata(String xmlDataFile)
	{
		// load SAS data into memory
		try {
			sasRoot = (SASrootType) loadXML("cansas1d", xmlDataFile);
		} catch (JAXBException e) {
			e.printStackTrace();
			System.out.println("ERROR: Cannot find or interpret SAS XML data file:\t" + xmlDataFile);
			return;
		}

		// SAS data are loaded
		// grab the SAS data to be desmeared
		int entryIndex = 0;	// /SASentry[1] : unit base in XML, 0 base in Java
		int dataIndex = 0;	// SASdata[1]
		int detectorIndex = 0;	// SASdetector[1]
		SASentryType entry = (SASentryType) sasRoot.getSASentry().get(entryIndex);
		SASdataType sdt = (SASdataType) entry.getSASdata().get(dataIndex);
		if (sdt.getName().trim().compareTo("slit-smeared") != 0) {
			System.out.println("selected SASdata element must start: &lt;SASdata name=\"slit-smeared\">");
			// throw something (an exception) here?
			return;
		}
		int numPoints = sdt.getIdata().size();
		Qsas = new double[numPoints];	// input Q
		Isas = new double[numPoints];	// input I (slit-smeared)
		Idev = new double[numPoints];	// input Idev (slit-smeared)
		for (int i = 0; i &lt; numPoints; i++) {
			Qsas[i] = sdt.getIdata().get(i).getQ().getValue();
			Isas[i] = sdt.getIdata().get(i).getI().getValue();
			Idev[i] = sdt.getIdata().get(i).getIdev().getValue();
		}
		Ismr = new double[numPoints];		// calculated I slit-smeared
		Idsm = new double[numPoints];		// calculated I desmeared
		IdsmDev = new double[numPoints];	// calculated Idev desmeared
		SASinstrumentType instrument = (SASinstrumentType) entry.getSASinstrument();
		SASdetectorType detector = (SASdetectorType) instrument.getSASdetector().get(detectorIndex);
		slit_length = detector.getSlitLength().getValue();
	}


	/**
	 * @param (String) pkg Java package containing XML Schema bound to Java data structures
	 * @param (String) xmlFile XML file to be opened
	 * @return (Object) root object of Java data structure from XML file 
	 * @throws JAXBException 
	 */
	@SuppressWarnings("unchecked")
	private static Object loadXML(String pkg, String xmlFile) throws JAXBException {
		// use the $(pkg) schema that is bound to a Java structure
		JAXBContext jc = JAXBContext.newInstance(pkg);
		Unmarshaller unmarshaller = jc.createUnmarshaller();
		// open the XML file into a Java data structure
		Object obj = (Object) ((JAXBElement&lt;Object>) unmarshaller
				.unmarshal(new File(xmlFile))).getValue();
		return obj;
	}


	/**
	 * @param dt (DesmearingType) Desmearing properties
	 * @param sasRoot (SASrootType) SAS data from XML file
	 */
	public void inputReporter()
	{
		System.out.println("dataFile:\t" + dt.getDataFile().trim());
		System.out.printf("dataset selected:\t/SASroot/SASentry[%d]/SASdata[%d]\n", 
				dt.getEntryIndex(), dt.getDataIndex());
		System.out.printf("detector selected:\t/SASroot/SASentry[%d]/SASinstrument/SASdetector[%d]\n", 
				dt.getEntryIndex(), dt.getDataIndex(), dt.getDetectorIndex());
		System.out.println("extrapolation_form:\t" + dt.getExtrapolationForm().trim());
		System.out.println("x_start_extrapolation_evaluation:\t" + dt.getXStartExtrapolationEvaluation().getValue());
		System.out.println("x_start_extrapolation_evaluation unit:\t" + dt.getXStartExtrapolationEvaluation().getUnit());
		System.out.println("iterations:\t" + dt.getIterations());
		System.out.println("iterative_weight_method:\t" + dt.getIterativeWeightMethod().trim());

		System.out.println("#---------------------------------------");

		int numEntries = sasRoot.getSASentry().size();
		System.out.println("SASentry elements: " + numEntries);
		for( int i = 0; i &lt; numEntries; i++ ) {
			System.out.println("SASentry");
			SASentryType entry = sasRoot.getSASentry().get(i);
			System.out.printf("Title:\t%s\n", entry.getTitle());
			List&lt;SASentryType.Run> runs = entry.getRun();
			System.out.printf("#Runs:\t%d\n", runs.size());
			for( int j = 0; j &lt; runs.size(); j++ ) {
				Run run = (Run) runs.get(j);
				System.out.printf("Run@name:\t%s\n", run.getName());
				System.out.printf("Run:\t%s\n", run.getValue());
			}
			List&lt;SASdataType> datasets = entry.getSASdata();
			System.out.printf("#SASdata:\t%d\n", datasets.size());
			for( int j = 0; j &lt; datasets.size(); j++ ) {
				SASdataType sdt = (SASdataType) datasets.get(j);
				System.out.printf("SASdata@name:\t%s\n", sdt.getName());
				System.out.printf("#points:\t%d\n", sdt.getIdata().size());
			}
			List&lt;SASdetectorType> detectors = entry.getSASinstrument().getSASdetector();
			System.out.printf("#SASdetector:\t%d\n", detectors.size());
			for( int j = 0; j &lt; detectors.size(); j++ ) {
				SASdetectorType det = (SASdetectorType) detectors.get(j);
				System.out.printf("SASdata@name:\t%s\n", det.getName());
				try {
					System.out.printf("SDD:\t%g\t(%s)\n", det.getSDD()
							.getValue(), det.getSDD().getUnit());
				} catch (Exception e) {
					System.out.println("SDD:\tundefined");
				}
				try {
					System.out.printf("slit_length:\t%g\t(%s)\n", det
							.getSlitLength().getValue(), det.getSlitLength()
							.getUnit());
				} catch (Exception e) {
					System.out.println("slit_length:\tundefined");
				}
			}
			System.out.println();
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// load test desmearing properties and data into memory
		GetSASdata sas = new GetSASdata("test.xml");
		sas.inputReporter();
		System.out.println("the end.");
	}


	/**
	 * @return the sasRoot
	 */
	public SASrootType getSasRoot() {
		return sasRoot;
	}

	/**
	 * @param sasRoot the sasRoot to set
	 */
	public void setSasRoot(SASrootType sasRoot) {
		GetDesmearingInfo.sasRoot = sasRoot;
	}

	/**
	 * @return the qsas
	 */
	public double[] getQsas() {
		return Qsas;
	}

	/**
	 * @param qsas the qsas to set
	 */
	public void setQsas(double[] qsas) {
		Qsas = qsas;
	}

	/**
	 * @return the isas
	 */
	public double[] getIsas() {
		return Isas;
	}

	/**
	 * @param isas the isas to set
	 */
	public void setIsas(double[] isas) {
		Isas = isas;
	}

	/**
	 * @return the idev
	 */
	public double[] getIdev() {
		return Idev;
	}

	/**
	 * @param idev the idev to set
	 */
	public void setIdev(double[] idev) {
		Idev = idev;
	}

	/**
	 * @return the ismr
	 */
	public double[] getIsmr() {
		return Ismr;
	}

	/**
	 * @param ismr the ismr to set
	 */
	public void setIsmr(double[] ismr) {
		Ismr = ismr;
	}

	/**
	 * @return the idsm
	 */
	public double[] getIdsm() {
		return Idsm;
	}

	/**
	 * @param idsm the idsm to set
	 */
	public void setIdsm(double[] idsm) {
		Idsm = idsm;
	}

	/**
	 * @return the idsmDev
	 */
	public double[] getIdsmDev() {
		return IdsmDev;
	}

	/**
	 * @param idsmDev the idsmDev to set
	 */
	public void setIdsmDev(double[] idsmDev) {
		IdsmDev = idsmDev;
	}

	/**
	 * @return
	 */
	public double getSlitLength() {
		return slit_length;
	}

}
