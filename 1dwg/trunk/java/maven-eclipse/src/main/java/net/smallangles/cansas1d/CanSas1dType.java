package net.smallangles.cansas1d;

//########### SVN repository information ###################
//# $Date$
//# $Author$
//# $Revision$
//# $URL$
//# $Id$
//########### SVN repository information ###################

import java.io.File;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

/**
 * <p>This is the main class to manage canSAS standard data structures in memory.</p>
 *
 * <p>Use create() if you want to create a new content structure in memory.</p>
 *
 * <p>Use open() if you want to load content from an XML file into memory.</p>
 *
 */
public class CanSas1dType {

	private JAXBContext jaxbContext;
	private JAXBElement<SASrootType> xmlJavaData;
	private SASrootType sasRoot;
	private String xmlFile;
	private String context;

	public CanSas1dType() {
		this.xmlJavaData = null;
		this.sasRoot = null;
		this.context = "net.smallangles.cansas1d";
		this.xmlFile = "";
	}

	/**
	 * Create a new JAXB context
	 * @return new JAXB context object
	 * @throws JAXBException
	 */
	public JAXBContext create() throws JAXBException {
		// use the context that is bound to a Java structure
		this.jaxbContext = JAXBContext.newInstance(this.context);
		return this.jaxbContext;
	}

	/**
	 * Open an existing canSAS XML data file and load it into memory
	 * @param xmlFile
	 * @return SASroot object with content from XML file
	 * @throws JAXBException
	 */
	@SuppressWarnings("unchecked")
	public SASrootType open(String xmlFile) throws JAXBException {
		// use the context that is bound to a Java structure
		JAXBContext jaxbc = this.create();
		Unmarshaller unmarshaller = jaxbc.createUnmarshaller();

		// open the XML into a Java data structure
		Object object = unmarshaller.unmarshal(new File(xmlFile));
		this.xmlJavaData = (JAXBElement<SASrootType>) object;

		// canSAS XML file is now loaded in memory
		this.sasRoot = this.xmlJavaData.getValue();
		this.xmlFile = xmlFile;

		return this.sasRoot;
	}

	public JAXBContext getJaxbContext() {
		return jaxbContext;
	}

	public JAXBElement<SASrootType> getXmlJavaData() {
		return xmlJavaData;
	}

	public SASrootType getSasRoot() {
		return sasRoot;
	}

	public String getXmlFile() {
		return xmlFile;
	}

	public String getContext() {
		return context;
	}

}
