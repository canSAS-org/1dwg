//
// Copyright (c) 2013, UChicago Argonne, LLC
// This file is distributed subject to a Software License Agreement found
// in the file LICENSE that is included with this distribution. 

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
 * <p>Java class for TdataType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="TdataType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="Lambda " type="{urn:cansas1d:1.1}floatUnitType"/>
 *         &lt;element name="T" type="{urn:cansas1d:1.1}floatUnitType"/>
 *         &lt;element name="Tdev" type="{urn:cansas1d:1.1}floatUnitType" minOccurs="0"/>
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
@XmlType(name = "TdataType", propOrder = {
    "lambda0020",
    "t",
    "tdev",
    "any"
})
public class TdataType {

    @XmlElement(name = "Lambda ", required = true)
    protected FloatUnitType lambda0020;
    @XmlElement(name = "T", required = true)
    protected FloatUnitType t;
    @XmlElement(name = "Tdev", defaultValue = "0")
    protected FloatUnitType tdev;
    @XmlAnyElement
    protected List<Element> any;

    /**
     * Gets the value of the lambda0020 property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getLambda_0020() {
        return lambda0020;
    }

    /**
     * Sets the value of the lambda0020 property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setLambda_0020(FloatUnitType value) {
        this.lambda0020 = value;
    }

    /**
     * Gets the value of the t property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getT() {
        return t;
    }

    /**
     * Sets the value of the t property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setT(FloatUnitType value) {
        this.t = value;
    }

    /**
     * Gets the value of the tdev property.
     * 
     * @return
     *     possible object is
     *     {@link FloatUnitType }
     *     
     */
    public FloatUnitType getTdev() {
        return tdev;
    }

    /**
     * Sets the value of the tdev property.
     * 
     * @param value
     *     allowed object is
     *     {@link FloatUnitType }
     *     
     */
    public void setTdev(FloatUnitType value) {
        this.tdev = value;
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
