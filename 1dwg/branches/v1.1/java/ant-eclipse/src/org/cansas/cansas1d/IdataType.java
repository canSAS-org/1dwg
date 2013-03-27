//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2013.03.27 at 06:30:11 PM CDT 
//


package org.cansas.cansas1d;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import org.w3c.dom.Element;


/**
 * <p>Java class for IdataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="IdataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Q" type="{urn:cansas1d:1.1}floatUnitType"/>
 *         &lt;element name="I" type="{urn:cansas1d:1.1}floatUnitType"/>
 *         &lt;element name="Idev" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *         &lt;choice>
 *           &lt;element name="Qdev" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *           &lt;sequence>
 *             &lt;element name="dQw" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *             &lt;element name="dQl" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *           &lt;/sequence>
 *         &lt;/choice>
 *         &lt;element name="Qmean" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
 *         &lt;element name="Shadowfactor" type="{http://www.w3.org/2001/XMLSchema}float" minOccurs="0"/>
 *         &lt;any processContents='skip' namespace='##other' maxOccurs="unbounded" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "IdataType", propOrder = {
    "q",
    "i",
    "idev",
    "qdev",
    "dQw",
    "dQl",
    "qmean",
    "shadowfactor",
    "any"
})
public class IdataType {

    @XmlElement(name = "Q", required = true)
    protected FloatUnitType q;
    @XmlElement(name = "I", required = true)
    protected FloatUnitType i;
    @XmlElement(name = "Idev", defaultValue = "0")
    protected FloatUnitType idev;
    @XmlElement(name = "Qdev", defaultValue = "0")
    protected FloatUnitType qdev;
    @XmlElement(defaultValue = "0")
    protected FloatUnitType dQw;
    @XmlElement(defaultValue = "0")
    protected FloatUnitType dQl;
    @XmlElement(name = "Qmean", defaultValue = "0")
    protected FloatUnitType qmean;
    @XmlElement(name = "Shadowfactor", defaultValue = "1.0")
    protected Float shadowfactor;
    @XmlAnyElement
    protected List<Element> any;

    /**
     * Gets the value of the q property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getQ() {
        return q;
    }

    /**
     * Sets the value of the q property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setQ(FloatUnitType value) {
        this.q = value;
    }

    /**
     * Gets the value of the i property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getI() {
        return i;
    }

    /**
     * Sets the value of the i property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setI(FloatUnitType value) {
        this.i = value;
    }

    /**
     * Gets the value of the idev property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getIdev() {
        return idev;
    }

    /**
     * Sets the value of the idev property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setIdev(FloatUnitType value) {
        this.idev = value;
    }

    /**
     * Gets the value of the qdev property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getQdev() {
        return qdev;
    }

    /**
     * Sets the value of the qdev property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setQdev(FloatUnitType value) {
        this.qdev = value;
    }

    /**
     * Gets the value of the dQw property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getDQw() {
        return dQw;
    }

    /**
     * Sets the value of the dQw property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setDQw(FloatUnitType value) {
        this.dQw = value;
    }

    /**
     * Gets the value of the dQl property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getDQl() {
        return dQl;
    }

    /**
     * Sets the value of the dQl property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setDQl(FloatUnitType value) {
        this.dQl = value;
    }

    /**
     * Gets the value of the qmean property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getQmean() {
        return qmean;
    }

    /**
     * Sets the value of the qmean property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setQmean(FloatUnitType value) {
        this.qmean = value;
    }

    /**
     * Gets the value of the shadowfactor property.
     * 
     * @return
     *     possible object is
     *     {@link Float }
     *     
     */
    public Float getShadowfactor() {
        return shadowfactor;
    }

    /**
     * Sets the value of the shadowfactor property.
     * 
     * @param value
     *     allowed object is
     *     {@link Float }
     *     
     */
    public void setShadowfactor(Float value) {
        this.shadowfactor = value;
    }

    /**
     * Gets the value of the any property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the any property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getAny().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Element }
     * 
     * 
     */
    public List<Element> getAny() {
        if (any == null) {
            any = new ArrayList<Element>();
        }
        return this.any;
    }

}
