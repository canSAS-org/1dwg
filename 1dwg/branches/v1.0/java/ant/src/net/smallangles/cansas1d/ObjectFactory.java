//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.1-b02-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.01.24 at 10:58:06 AM CST 
//


package net.smallangles.cansas1d;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the net.smallangles.cansas1d package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _SASroot_QNAME = new QName("cansas1d/1.0", "SASroot");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: net.smallangles.cansas1d
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link TermType }
     * 
     */
    public TermType createTermType() {
        return new TermType();
    }

    /**
     * Create an instance of {@link SASentryType.Run }
     * 
     */
    public SASentryType.Run createSASentryTypeRun() {
        return new SASentryType.Run();
    }

    /**
     * Create an instance of {@link SASinstrumentType }
     * 
     */
    public SASinstrumentType createSASinstrumentType() {
        return new SASinstrumentType();
    }

    /**
     * Create an instance of {@link SASsampleType }
     * 
     */
    public SASsampleType createSASsampleType() {
        return new SASsampleType();
    }

    /**
     * Create an instance of {@link OrientationType }
     * 
     */
    public OrientationType createOrientationType() {
        return new OrientationType();
    }

    /**
     * Create an instance of {@link FloatUnitType }
     * 
     */
    public FloatUnitType createFloatUnitType() {
        return new FloatUnitType();
    }

    /**
     * Create an instance of {@link SASsourceType }
     * 
     */
    public SASsourceType createSASsourceType() {
        return new SASsourceType();
    }

    /**
     * Create an instance of {@link SASprocessType }
     * 
     */
    public SASprocessType createSASprocessType() {
        return new SASprocessType();
    }

    /**
     * Create an instance of {@link SASdetectorType }
     * 
     */
    public SASdetectorType createSASdetectorType() {
        return new SASdetectorType();
    }

    /**
     * Create an instance of {@link SAScollimationType }
     * 
     */
    public SAScollimationType createSAScollimationType() {
        return new SAScollimationType();
    }

    /**
     * Create an instance of {@link IdataType }
     * 
     */
    public IdataType createIdataType() {
        return new IdataType();
    }

    /**
     * Create an instance of {@link SAScollimationType.Aperture }
     * 
     */
    public SAScollimationType.Aperture createSAScollimationTypeAperture() {
        return new SAScollimationType.Aperture();
    }

    /**
     * Create an instance of {@link SASentryType }
     * 
     */
    public SASentryType createSASentryType() {
        return new SASentryType();
    }

    /**
     * Create an instance of {@link SASrootType }
     * 
     */
    public SASrootType createSASrootType() {
        return new SASrootType();
    }

    /**
     * Create an instance of {@link SASdataType }
     * 
     */
    public SASdataType createSASdataType() {
        return new SASdataType();
    }

    /**
     * Create an instance of {@link PositionType }
     * 
     */
    public PositionType createPositionType() {
        return new PositionType();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link SASrootType }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "cansas1d/1.0", name = "SASroot")
    public JAXBElement<SASrootType> createSASroot(SASrootType value) {
        return new JAXBElement<SASrootType>(_SASroot_QNAME, SASrootType.class, null, value);
    }

}
