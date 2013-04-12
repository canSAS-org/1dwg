//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.04.12 at 11:37:45 AM CDT 
//


package org.cansas.cansas1d;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for SASdetectorType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="SASdetectorType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="SDD" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *         &lt;element name="offset" type="{urn:cansas1d:1.1}positionType" minOccurs="0"/>
 *         &lt;element name="orientation" type="{urn:cansas1d:1.1}orientationType" minOccurs="0"/>
 *         &lt;element name="beam_center" type="{urn:cansas1d:1.1}positionType" minOccurs="0"/>
 *         &lt;element name="pixel_size" type="{urn:cansas1d:1.1}positionType" minOccurs="0"/>
 *         &lt;element name="slit_length" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SASdetectorType", propOrder = {
    "name",
    "sdd",
    "offset",
    "orientation",
    "beamCenter",
    "pixelSize",
    "slitLength"
})
public class SASdetectorType {

    @XmlElement(required = true, defaultValue = "")
    protected String name;
    @XmlElement(name = "SDD")
    protected FloatUnitType sdd;
    protected PositionType offset;
    protected OrientationType orientation;
    @XmlElement(name = "beam_center")
    protected PositionType beamCenter;
    @XmlElement(name = "pixel_size")
    protected PositionType pixelSize;
    @XmlElement(name = "slit_length")
    protected FloatUnitType slitLength;

    /**
     * Gets the value of the name property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the value of the name property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setName(String value) {
        this.name = value;
    }

    /**
     * Gets the value of the sdd property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getSDD() {
        return sdd;
    }

    /**
     * Sets the value of the sdd property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setSDD(FloatUnitType value) {
        this.sdd = value;
    }

    /**
     * Gets the value of the offset property.
     * 
     * @return
     *     possible object is
     *     {@link PositionType }
     *     
     */
    public PositionType getOffset() {
        return offset;
    }

    /**
     * Sets the value of the offset property.
     * 
     * @param value
     *     allowed object is
     *     {@link PositionType }
     *     
     */
    public void setOffset(PositionType value) {
        this.offset = value;
    }

    /**
     * Gets the value of the orientation property.
     * 
     * @return
     *     possible object is
     *     {@link OrientationType }
     *     
     */
    public OrientationType getOrientation() {
        return orientation;
    }

    /**
     * Sets the value of the orientation property.
     * 
     * @param value
     *     allowed object is
     *     {@link OrientationType }
     *     
     */
    public void setOrientation(OrientationType value) {
        this.orientation = value;
    }

    /**
     * Gets the value of the beamCenter property.
     * 
     * @return
     *     possible object is
     *     {@link PositionType }
     *     
     */
    public PositionType getBeamCenter() {
        return beamCenter;
    }

    /**
     * Sets the value of the beamCenter property.
     * 
     * @param value
     *     allowed object is
     *     {@link PositionType }
     *     
     */
    public void setBeamCenter(PositionType value) {
        this.beamCenter = value;
    }

    /**
     * Gets the value of the pixelSize property.
     * 
     * @return
     *     possible object is
     *     {@link PositionType }
     *     
     */
    public PositionType getPixelSize() {
        return pixelSize;
    }

    /**
     * Sets the value of the pixelSize property.
     * 
     * @param value
     *     allowed object is
     *     {@link PositionType }
     *     
     */
    public void setPixelSize(PositionType value) {
        this.pixelSize = value;
    }

    /**
     * Gets the value of the slitLength property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getSlitLength() {
        return slitLength;
    }

    /**
     * Sets the value of the slitLength property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setSlitLength(FloatUnitType value) {
        this.slitLength = value;
    }

}
