/**
 * Javascript implementation of Abstract Syntax Notation Number One.
 *
 * @author Dave Longley
 *
 * Copyright (c) 2010-2015 Digital Bazaar, Inc.
 *
 * An API for storing data using the Abstract Syntax Notation Number One
 * format using DER (Distinguished Encoding Rules) encoding. This encoding is
 * commonly used to store data for PKI, i.e. X.509 Certificates, and this
 * implementation exists for that purpose.
 *
 * Abstract Syntax Notation Number One (ASN.1) is used to define the abstract
 * syntax of information without restricting the way the information is encoded
 * for transmission. It provides a standard that allows for open systems
 * communication. ASN.1 defines the syntax of information data and a number of
 * simple data types as well as a notation for describing them and specifying
 * values for them.
 *
 * The RSA algorithm creates public and private keys that are often stored in
 * X.509 or PKCS#X formats -- which use ASN.1 (encoded in DER format). This
 * class provides the most basic functionality required to store and load DSA
 * keys that are encoded according to ASN.1.
 *
 * The most common binary encodings for ASN.1 are BER (Basic Encoding Rules)
 * and DER (Distinguished Encoding Rules). DER is just a subset of BER that
 * has stricter requirements for how data must be encoded.
 *
 * Each ASN.1 structure has a tag (a byte identifying the ASN.1 structure type)
 * and a byte array for the value of this ASN1 structure which may be data or a
 * list of ASN.1 structures.
 *
 * Each ASN.1 structure using BER is (Tag-Length-Value):
 *
 * | byte 0 | bytes X | bytes Y |
 * |--------|---------|----------
 * |  tag   | length  |  value  |
 *
 * ASN.1 allows for tags to be of "High-tag-number form" which allows a tag to
 * be two or more octets, but that is not supported by this class. A tag is
 * only 1 byte. Bits 1-5 give the tag number (ie the data type within a
 * particular 'class'), 6 indicates whether or not the ASN.1 value is
 * constructed from other ASN.1 values, and bits 7 and 8 give the 'class'. If
 * bits 7 and 8 are both zero, the class is UNIVERSAL. If only bit 7 is set,
 * then the class is APPLICATION. If only bit 8 is set, then the class is
 * CONTEXT_SPECIFIC. If both bits 7 and 8 are set, then the class is PRIVATE.
 * The tag numbers for the data types for the class UNIVERSAL are listed below:
 *
 * UNIVERSAL 0 Reserved for use by the encoding rules
 * UNIVERSAL 1 Boolean type
 * UNIVERSAL 2 Integer type
 * UNIVERSAL 3 Bitstring type
 * UNIVERSAL 4 Octetstring type
 * UNIVERSAL 5 Null type
 * UNIVERSAL 6 Object identifier type
 * UNIVERSAL 7 Object descriptor type
 * UNIVERSAL 8 External type and Instance-of type
 * UNIVERSAL 9 Real type
 * UNIVERSAL 10 Enumerated type
 * UNIVERSAL 11 Embedded-pdv type
 * UNIVERSAL 12 UTF8String type
 * UNIVERSAL 13 Relative object identifier type
 * UNIVERSAL 14-15 Reserved for future editions
 * UNIVERSAL 16 Sequence and Sequence-of types
 * UNIVERSAL 17 Set and Set-of types
 * UNIVERSAL 18-22, 25-30 Character string types
 * UNIVERSAL 23-24 Time types
 *
 * The length of an ASN.1 structure is specified after the tag identifier.
 * There is a definite form and an indefinite form. The indefinite form may
 * be used if the encoding is constructed and not all immediately available.
 * The indefinite form is encoded using a length byte with only the 8th bit
 * set. The end of the constructed object is marked using end-of-contents
 * octets (two zero bytes).
 *
 * The definite form looks like this:
 *
 * The length may take up 1 or more bytes, it depends on the length of the
 * value of the ASN.1 structure. DER encoding requires that if the ASN.1
 * structure has a value that has a length greater than 127, more than 1 byte
 * will be used to store its length, otherwise just one byte will be used.
 * This is strict.
 *
 * In the case that the length of the ASN.1 value is less than 127, 1 octet
 * (byte) is used to store the "short form" length. The 8th bit has a value of
 * 0 indicating the length is "short form" and not "long form" and bits 7-1
 * give the length of the data. (The 8th bit is the left-most, most significant
 * bit: also known as big endian or network format).
 *
 * In the case that the length of the ASN.1 value is greater than 127, 2 to
 * 127 octets (bytes) are used to store the "long form" length. The first
 * byte's 8th bit is set to 1 to indicate the length is "long form." Bits 7-1
 * give the number of additional octets. All following octets are in base 256
 * with the most significant digit first (typical big-endian binary unsigned
 * integer storage). So, for instance, if the length of a value was 257, the
 * first byte would be set to:
 *
 * 10000010 = 130 = 0x82.
 *
 * This indicates there are 2 octets (base 256) for the length. The second and
 * third bytes (the octets just mentioned) would store the length in base 256:
 *
 * octet 2: 00000001 = 1 * 256^1 = 256
 * octet 3: 00000001 = 1 * 256^0 = 1
 * total = 257
 *
 * The algorithm for converting a js integer value of 257 to base-256 is:
 *
 * var value = 257;
 * var bytes = [];
 * bytes[0] = (value >>> 8) & 0xFF; // most significant byte first
 * bytes[1] = value & 0xFF;        // least significant byte last
 *
 * On the ASN.1 UNIVERSAL Object Identifier (OID) type:
 *
 * An OID can be written like: "value1.value2.value3...valueN"
 *
 * The DER encoding rules:
 *
 * The first byte has the value 40 * value1 + value2.
 * The following bytes, if any, encode the remaining values. Each value is
 * encoded in base 128, most significant digit first (big endian), with as
 * few digits as possible, and the most significant bit of each byte set
 * to 1 except the last in each value's encoding. For example: Given the
 * OID "1.2.840.113549", its DER encoding is (remember each byte except the
 * last one in each encoding is OR'd with 0x80):
 *
 * byte 1: 40 * 1 + 2 = 42 = 0x2A.
 * bytes 2-3: 128 * 6 + 72 = 840 = 6 72 = 6 72 = 0x0648 = 0x8648
 * bytes 4-6: 16384 * 6 + 128 * 119 + 13 = 6 119 13 = 0x06770D = 0x86F70D
 *
 * The final value is: 0x2A864886F70D.
 * The full OID (including ASN.1 tag and length of 6 bytes) is:
 * 0x06062A864886F70D
 */
!function(){function e(e){var t=e.asn1=e.asn1||{};t.Class={UNIVERSAL:0,APPLICATION:64,CONTEXT_SPECIFIC:128,PRIVATE:192},t.Type={NONE:0,BOOLEAN:1,INTEGER:2,BITSTRING:3,OCTETSTRING:4,NULL:5,OID:6,ODESC:7,EXTERNAL:8,REAL:9,ENUMERATED:10,EMBEDDED:11,UTF8:12,ROID:13,SEQUENCE:16,SET:17,PRINTABLESTRING:19,IA5STRING:22,UTCTIME:23,GENERALIZEDTIME:24,BMPSTRING:30},t.create=function(t,r,a,n){if(e.util.isArray(n)){for(var s=[],u=0;u<n.length;++u)void 0!==n[u]&&s.push(n[u]);n=s}return{tagClass:t,type:r,constructed:a,composed:a||e.util.isArray(n),value:n}};var r=t.getBerValueLength=function(e){var t=e.getByte();if(128===t)return void 0;var r,a=128&t;return r=a?e.getInt((127&t)<<3):t};t.fromDer=function(a,n){if(void 0===n&&(n=!0),"string"==typeof a&&(a=e.util.createBuffer(a)),a.length()<2){var s=new Error("Too few bytes to parse DER.");throw s.bytes=a.length(),s}var u=a.getByte(),i=192&u,l=31&u,o=r(a);if(a.length()<o){if(n){var s=new Error("Too few bytes to read ASN.1 value.");throw s.detail=a.length()+" < "+o,s}o=a.length()}var p,f=32===(32&u),c=f;if(!c&&i===t.Class.UNIVERSAL&&l===t.Type.BITSTRING&&o>1){var T=a.read,g=a.getByte();if(0===g){u=a.getByte();var y=192&u;if(y===t.Class.UNIVERSAL||y===t.Class.CONTEXT_SPECIFIC)try{var d=r(a);c=d===o-(a.read-T),c&&(++T,--o)}catch(v){}}a.read=T}if(c)if(p=[],void 0===o)for(;;){if(a.bytes(2)===String.fromCharCode(0,0)){a.getBytes(2);break}p.push(t.fromDer(a,n))}else for(var I=a.length();o>0;)p.push(t.fromDer(a,n)),o-=I-a.length(),I=a.length();else{if(void 0===o){if(n)throw new Error("Non-constructed ASN.1 object of indefinite length.");o=a.length()}if(l===t.Type.BMPSTRING){p="";for(var h=0;o>h;h+=2)p+=String.fromCharCode(a.getInt16())}else p=a.getBytes(o)}return t.create(i,l,f,p)},t.toDer=function(r){var a=e.util.createBuffer(),n=r.tagClass|r.type,s=e.util.createBuffer();if(r.composed){r.constructed?n|=32:s.putByte(0);for(var u=0;u<r.value.length;++u)void 0!==r.value[u]&&s.putBuffer(t.toDer(r.value[u]))}else if(r.type===t.Type.BMPSTRING)for(var u=0;u<r.value.length;++u)s.putInt16(r.value.charCodeAt(u));else s.putBytes(r.value);if(a.putByte(n),s.length()<=127)a.putByte(127&s.length());else{var i=s.length(),l="";do l+=String.fromCharCode(255&i),i>>>=8;while(i>0);a.putByte(128|l.length);for(var u=l.length-1;u>=0;--u)a.putByte(l.charCodeAt(u))}return a.putBuffer(s),a},t.oidToDer=function(t){var r=t.split("."),a=e.util.createBuffer();a.putByte(40*parseInt(r[0],10)+parseInt(r[1],10));for(var n,s,u,i,l=2;l<r.length;++l){n=!0,s=[],u=parseInt(r[l],10);do i=127&u,u>>>=7,n||(i|=128),s.push(i),n=!1;while(u>0);for(var o=s.length-1;o>=0;--o)a.putByte(s[o])}return a},t.derToOid=function(t){var r;"string"==typeof t&&(t=e.util.createBuffer(t));var a=t.getByte();r=Math.floor(a/40)+"."+a%40;for(var n=0;t.length()>0;)a=t.getByte(),n<<=7,128&a?n+=127&a:(r+="."+(n+a),n=0);return r},t.utcTimeToDate=function(e){var t=new Date,r=parseInt(e.substr(0,2),10);r=r>=50?1900+r:2e3+r;var a=parseInt(e.substr(2,2),10)-1,n=parseInt(e.substr(4,2),10),s=parseInt(e.substr(6,2),10),u=parseInt(e.substr(8,2),10),i=0;if(e.length>11){var l=e.charAt(10),o=10;"+"!==l&&"-"!==l&&(i=parseInt(e.substr(10,2),10),o+=2)}if(t.setUTCFullYear(r,a,n),t.setUTCHours(s,u,i,0),o&&(l=e.charAt(o),"+"===l||"-"===l)){var p=parseInt(e.substr(o+1,2),10),f=parseInt(e.substr(o+4,2),10),c=60*p+f;c*=6e4,t.setTime("+"===l?+t-c:+t+c)}return t},t.generalizedTimeToDate=function(e){var t=new Date,r=parseInt(e.substr(0,4),10),a=parseInt(e.substr(4,2),10)-1,n=parseInt(e.substr(6,2),10),s=parseInt(e.substr(8,2),10),u=parseInt(e.substr(10,2),10),i=parseInt(e.substr(12,2),10),l=0,o=0,p=!1;"Z"===e.charAt(e.length-1)&&(p=!0);var f=e.length-5,c=e.charAt(f);if("+"===c||"-"===c){var T=parseInt(e.substr(f+1,2),10),g=parseInt(e.substr(f+4,2),10);o=60*T+g,o*=6e4,"+"===c&&(o*=-1),p=!0}return"."===e.charAt(14)&&(l=1e3*parseFloat(e.substr(14),10)),p?(t.setUTCFullYear(r,a,n),t.setUTCHours(s,u,i,l),t.setTime(+t+o)):(t.setFullYear(r,a,n),t.setHours(s,u,i,l)),t},t.dateToUtcTime=function(e){if("string"==typeof e)return e;var t="",r=[];r.push((""+e.getUTCFullYear()).substr(2)),r.push(""+(e.getUTCMonth()+1)),r.push(""+e.getUTCDate()),r.push(""+e.getUTCHours()),r.push(""+e.getUTCMinutes()),r.push(""+e.getUTCSeconds());for(var a=0;a<r.length;++a)r[a].length<2&&(t+="0"),t+=r[a];return t+="Z"},t.dateToGeneralizedTime=function(e){if("string"==typeof e)return e;var t="",r=[];r.push(""+e.getUTCFullYear()),r.push(""+(e.getUTCMonth()+1)),r.push(""+e.getUTCDate()),r.push(""+e.getUTCHours()),r.push(""+e.getUTCMinutes()),r.push(""+e.getUTCSeconds());for(var a=0;a<r.length;++a)r[a].length<2&&(t+="0"),t+=r[a];return t+="Z"},t.integerToDer=function(t){var r=e.util.createBuffer();if(t>=-128&&128>t)return r.putSignedInt(t,8);if(t>=-32768&&32768>t)return r.putSignedInt(t,16);if(t>=-8388608&&8388608>t)return r.putSignedInt(t,24);if(t>=-2147483648&&2147483648>t)return r.putSignedInt(t,32);var a=new Error("Integer too large; max is 32-bits.");throw a.integer=t,a},t.derToInteger=function(t){"string"==typeof t&&(t=e.util.createBuffer(t));var r=8*t.length();if(r>32)throw new Error("Integer too large; max is 32-bits.");return t.getSignedInt(r)},t.validate=function(r,a,n,s){var u=!1;if(r.tagClass!==a.tagClass&&"undefined"!=typeof a.tagClass||r.type!==a.type&&"undefined"!=typeof a.type)s&&(r.tagClass!==a.tagClass&&s.push("["+a.name+'] Expected tag class "'+a.tagClass+'", got "'+r.tagClass+'"'),r.type!==a.type&&s.push("["+a.name+'] Expected type "'+a.type+'", got "'+r.type+'"'));else if(r.constructed===a.constructed||"undefined"==typeof a.constructed){if(u=!0,a.value&&e.util.isArray(a.value))for(var i=0,l=0;u&&l<a.value.length;++l)u=a.value[l].optional||!1,r.value[i]&&(u=t.validate(r.value[i],a.value[l],n,s),u?++i:a.value[l].optional&&(u=!0)),!u&&s&&s.push("["+a.name+'] Tag class "'+a.tagClass+'", type "'+a.type+'" expected value length "'+a.value.length+'", got "'+r.value.length+'"');u&&n&&(a.capture&&(n[a.capture]=r.value),a.captureAsn1&&(n[a.captureAsn1]=r))}else s&&s.push("["+a.name+'] Expected constructed "'+a.constructed+'", got "'+r.constructed+'"');return u};var a=/[^\\u0000-\\u00ff]/;t.prettyPrint=function(r,n,s){var u="";n=n||0,s=s||2,n>0&&(u+="\n");for(var i="",l=0;n*s>l;++l)i+=" ";switch(u+=i+"Tag: ",r.tagClass){case t.Class.UNIVERSAL:u+="Universal:";break;case t.Class.APPLICATION:u+="Application:";break;case t.Class.CONTEXT_SPECIFIC:u+="Context-Specific:";break;case t.Class.PRIVATE:u+="Private:"}if(r.tagClass===t.Class.UNIVERSAL)switch(u+=r.type,r.type){case t.Type.NONE:u+=" (None)";break;case t.Type.BOOLEAN:u+=" (Boolean)";break;case t.Type.BITSTRING:u+=" (Bit string)";break;case t.Type.INTEGER:u+=" (Integer)";break;case t.Type.OCTETSTRING:u+=" (Octet string)";break;case t.Type.NULL:u+=" (Null)";break;case t.Type.OID:u+=" (Object Identifier)";break;case t.Type.ODESC:u+=" (Object Descriptor)";break;case t.Type.EXTERNAL:u+=" (External or Instance of)";break;case t.Type.REAL:u+=" (Real)";break;case t.Type.ENUMERATED:u+=" (Enumerated)";break;case t.Type.EMBEDDED:u+=" (Embedded PDV)";break;case t.Type.UTF8:u+=" (UTF8)";break;case t.Type.ROID:u+=" (Relative Object Identifier)";break;case t.Type.SEQUENCE:u+=" (Sequence)";break;case t.Type.SET:u+=" (Set)";break;case t.Type.PRINTABLESTRING:u+=" (Printable String)";break;case t.Type.IA5String:u+=" (IA5String (ASCII))";break;case t.Type.UTCTIME:u+=" (UTC time)";break;case t.Type.GENERALIZEDTIME:u+=" (Generalized time)";break;case t.Type.BMPSTRING:u+=" (BMP String)"}else u+=r.type;if(u+="\n",u+=i+"Constructed: "+r.constructed+"\n",r.composed){for(var o=0,p="",l=0;l<r.value.length;++l)void 0!==r.value[l]&&(o+=1,p+=t.prettyPrint(r.value[l],n+1,s),l+1<r.value.length&&(p+=","));u+=i+"Sub values: "+o+p}else{if(u+=i+"Value: ",r.type===t.Type.OID){var f=t.derToOid(r.value);u+=f,e.pki&&e.pki.oids&&f in e.pki.oids&&(u+=" ("+e.pki.oids[f]+") ")}if(r.type===t.Type.INTEGER)try{u+=t.derToInteger(r.value)}catch(c){u+="0x"+e.util.bytesToHex(r.value)}else r.type===t.Type.OCTETSTRING?(a.test(r.value)||(u+="("+r.value+") "),u+="0x"+e.util.bytesToHex(r.value)):u+=r.type===t.Type.UTF8?e.util.decodeUtf8(r.value):r.type===t.Type.PRINTABLESTRING||r.type===t.Type.IA5String?r.value:a.test(r.value)?"0x"+e.util.bytesToHex(r.value):0===r.value.length?"[null]":r.value}return u}}var t="asn1";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var r=!0;define=function(e,t){t(require,module)}}var a,n=function(r,n){n.exports=function(n){var s=a.map(function(e){return r(e)}).concat(e);if(n=n||{},n.defined=n.defined||{},n.defined[t])return n[t];n.defined[t]=!0;for(var u=0;u<s.length;++u)s[u](n);return n[t]}},s=define;define=function(e,t){return a="string"==typeof e?t.slice(2):e.slice(2),r?(delete define,s.apply(null,Array.prototype.slice.call(arguments,0))):(define=s,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./util","./oids"],function(){n.apply(null,Array.prototype.slice.call(arguments,0))})}();