//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.1-b02-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2008.05.01 at 02:06:16 PM CDT 
//


package net.smallangles.cansas1d;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAnyElement;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import org.w3c.dom.Element;


/**
 * <p>Java class for SASprocessType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="SASprocessType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="date" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="description" type="{http://www.w3.org/2001/XMLSchema}anyType" minOccurs="0"/>
 *         &lt;element name="term" type="{cansas1d/1.0}termType" maxOccurs="unbounded" minOccurs="0"/>
 *         &lt;element name="SASprocessnote" type="{http://www.w3.org/2001/XMLSchema}anyType" maxOccurs="unbounded"/>
 *         &lt;any/>
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
@XmlType(name = "SASprocessType", propOrder = {
    "saSprocessName",
    "date",
    "description",
    "term",
    "saSprocessnote",
    "any"
})
public class SASprocessType {

    @XmlElement(name = "name", defaultValue = "")
    protected String saSprocessName;
    protected String date;
    protected Object description;
    protected List<TermType> term;
    @XmlElement(name = "SASprocessnote", required = true)
    protected List<Object> saSprocessnote;
    @XmlAnyElement
    protected List<Element> any;
    @XmlAttribute(name = "name")
    protected String saSprocessNameAttr;

    /**
     * Gets the value of the saSprocessName property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSASprocessName() {
        return saSprocessName;
    }

    /**
     * Sets the value of the saSprocessName property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSASprocessName(String value) {
        this.saSprocessName = value;
    }

    /**
     * Gets the value of the date property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDate() {
        return date;
    }

    /**
     * Sets the value of the date property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDate(String value) {
        this.date = value;
    }

    /**
     * Gets the value of the description property.
     * 
     * @return
     *     possible object is
     *     {@link Object }
     *     
     */
    public Object getDescription() {
        return description;
    }

    /**
     * Sets the value of the description property.
     * 
     * @param value
     *     allowed object is
     *     {@link Object }
     *     
     */
    public void setDescription(Object value) {
        this.description = value;
    }

    /**
     * Gets the value of the term property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the term property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getTerm().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link TermType }
     * 
     * 
     */
    public List<TermType> getTerm() {
        if (term == null) {
            term = new ArrayList<TermType>();
        }
        return this.term;
    }

    /**
     * Gets the value of the saSprocessnote property.
     * 
     * <p>
     * This accessor method returns a reference to the live list,
     * not a snapshot. Therefore any modification you make to the
     * returned list will be present inside the JAXB object.
     * This is why there is not a <CODE>set</CODE> method for the saSprocessnote property.
     * 
     * <p>
     * For example, to add a new item, do as follows:
     * <pre>
     *    getSASprocessnote().add(newItem);
     * </pre>
     * 
     * 
     * <p>
     * Objects of the following type(s) are allowed in the list
     * {@link Object }
     * 
     * 
     */
    public List<Object> getSASprocessnote() {
        if (saSprocessnote == null) {
            saSprocessnote = new ArrayList<Object>();
        }
        return this.saSprocessnote;
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

    /**
     * Gets the value of the saSprocessNameAttr property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSASprocessNameAttr() {
        if (saSprocessNameAttr == null) {
            return "";
        } else {
            return saSprocessNameAttr;
        }
    }

    /**
     * Sets the value of the saSprocessNameAttr property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSASprocessNameAttr(String value) {
        this.saSprocessNameAttr = value;
    }

}
