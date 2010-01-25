//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.1-b02-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.01.24 at 10:58:06 AM CST 
//


package net.smallangles.cansas1d;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for SASsourceType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="SASsourceType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="radiation" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *         &lt;element name="beam_size" type="{cansas1d/1.0}positionType" minOccurs="0"/>
 *         &lt;element name="beam_shape" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="wavelength" type="{cansas1d/1.0}floatUnitType" minOccurs="0"/>
 *         &lt;element name="wavelength_min" type="{cansas1d/1.0}floatUnitType" minOccurs="0"/>
 *         &lt;element name="wavelength_max" type="{cansas1d/1.0}floatUnitType" minOccurs="0"/>
 *         &lt;element name="wavelength_spread" type="{cansas1d/1.0}floatUnitType" minOccurs="0"/>
 *       &lt;/sequence>
 *       &lt;attribute name="name" type="{http://www.w3.org/2001/XMLSchema}string" default="" />
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SASsourceType", propOrder = {
    "radiation",
    "beamSize",
    "beamShape",
    "wavelength",
    "wavelengthMin",
    "wavelengthMax",
    "wavelengthSpread"
})
public class SASsourceType {

    @XmlElement(required = true)
    protected String radiation;
    @XmlElement(name = "beam_size")
    protected PositionType beamSize;
    @XmlElement(name = "beam_shape")
    protected String beamShape;
    protected FloatUnitType wavelength;
    @XmlElement(name = "wavelength_min")
    protected FloatUnitType wavelengthMin;
    @XmlElement(name = "wavelength_max")
    protected FloatUnitType wavelengthMax;
    @XmlElement(name = "wavelength_spread")
    protected FloatUnitType wavelengthSpread;
    @XmlAttribute
    protected String name;

    /**
     * Gets the value of the radiation property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getRadiation() {
        return radiation;
    }

    /**
     * Sets the value of the radiation property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setRadiation(String value) {
        this.radiation = value;
    }

    /**
     * Gets the value of the beamSize property.
     * 
     * @return
     *     possible object is
     *     {@link PositionType }
     *     
     */
    public PositionType getBeamSize() {
        return beamSize;
    }

    /**
     * Sets the value of the beamSize property.
     * 
     * @param value
     *     allowed object is
     *     {@link PositionType }
     *     
     */
    public void setBeamSize(PositionType value) {
        this.beamSize = value;
    }

    /**
     * Gets the value of the beamShape property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getBeamShape() {
        return beamShape;
    }

    /**
     * Sets the value of the beamShape property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setBeamShape(String value) {
        this.beamShape = value;
    }

    /**
     * Gets the value of the wavelength property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getWavelength() {
        return wavelength;
    }

    /**
     * Sets the value of the wavelength property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setWavelength(FloatUnitType value) {
        this.wavelength = value;
    }

    /**
     * Gets the value of the wavelengthMin property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getWavelengthMin() {
        return wavelengthMin;
    }

    /**
     * Sets the value of the wavelengthMin property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setWavelengthMin(FloatUnitType value) {
        this.wavelengthMin = value;
    }

    /**
     * Gets the value of the wavelengthMax property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getWavelengthMax() {
        return wavelengthMax;
    }

    /**
     * Sets the value of the wavelengthMax property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setWavelengthMax(FloatUnitType value) {
        this.wavelengthMax = value;
    }

    /**
     * Gets the value of the wavelengthSpread property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getWavelengthSpread() {
        return wavelengthSpread;
    }

    /**
     * Sets the value of the wavelengthSpread property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setWavelengthSpread(FloatUnitType value) {
        this.wavelengthSpread = value;
    }

    /**
     * Gets the value of the name property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getName() {
        if (name == null) {
            return "";
        } else {
            return name;
        }
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

}