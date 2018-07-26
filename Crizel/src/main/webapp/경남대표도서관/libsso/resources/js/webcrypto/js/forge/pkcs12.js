/**
 * Javascript implementation of PKCS#12.
 *
 * @author Dave Longley
 * @author Stefan Siegl <stesie@brokenpipe.de>
 *
 * Copyright (c) 2010-2014 Digital Bazaar, Inc.
 * Copyright (c) 2012 Stefan Siegl <stesie@brokenpipe.de>
 *
 * The ASN.1 representation of PKCS#12 is as follows
 * (see ftp://ftp.rsasecurity.com/pub/pkcs/pkcs-12/pkcs-12-tc1.pdf for details)
 *
 * PFX ::= SEQUENCE {
 *   version  INTEGER {v3(3)}(v3,...),
 *   authSafe ContentInfo,
 *   macData  MacData OPTIONAL
 * }
 *
 * MacData ::= SEQUENCE {
 *   mac DigestInfo,
 *   macSalt OCTET STRING,
 *   iterations INTEGER DEFAULT 1
 * }
 * Note: The iterations default is for historical reasons and its use is
 * deprecated. A higher value, like 1024, is recommended.
 *
 * DigestInfo is defined in PKCS#7 as follows:
 *
 * DigestInfo ::= SEQUENCE {
 *   digestAlgorithm DigestAlgorithmIdentifier,
 *   digest Digest
 * }
 *
 * DigestAlgorithmIdentifier ::= AlgorithmIdentifier
 *
 * The AlgorithmIdentifier contains an Object Identifier (OID) and parameters
 * for the algorithm, if any. In the case of SHA1 there is none.
 *
 * AlgorithmIdentifer ::= SEQUENCE {
 *    algorithm OBJECT IDENTIFIER,
 *    parameters ANY DEFINED BY algorithm OPTIONAL
 * }
 *
 * Digest ::= OCTET STRING
 *
 *
 * ContentInfo ::= SEQUENCE {
 *   contentType ContentType,
 *   content     [0] EXPLICIT ANY DEFINED BY contentType OPTIONAL
 * }
 *
 * ContentType ::= OBJECT IDENTIFIER
 *
 * AuthenticatedSafe ::= SEQUENCE OF ContentInfo
 * -- Data if unencrypted
 * -- EncryptedData if password-encrypted
 * -- EnvelopedData if public key-encrypted
 *
 *
 * SafeContents ::= SEQUENCE OF SafeBag
 *
 * SafeBag ::= SEQUENCE {
 *   bagId     BAG-TYPE.&id ({PKCS12BagSet})
 *   bagValue  [0] EXPLICIT BAG-TYPE.&Type({PKCS12BagSet}{@bagId}),
 *   bagAttributes SET OF PKCS12Attribute OPTIONAL
 * }
 *
 * PKCS12Attribute ::= SEQUENCE {
 *   attrId ATTRIBUTE.&id ({PKCS12AttrSet}),
 *   attrValues SET OF ATTRIBUTE.&Type ({PKCS12AttrSet}{@attrId})
 * } -- This type is compatible with the X.500 type ’Attribute’
 *
 * PKCS12AttrSet ATTRIBUTE ::= {
 *   friendlyName | -- from PKCS #9
 *   localKeyId, -- from PKCS #9
 *   ... -- Other attributes are allowed
 * }
 *
 * CertBag ::= SEQUENCE {
 *   certId    BAG-TYPE.&id   ({CertTypes}),
 *   certValue [0] EXPLICIT BAG-TYPE.&Type ({CertTypes}{@certId})
 * }
 *
 * x509Certificate BAG-TYPE ::= {OCTET STRING IDENTIFIED BY {certTypes 1}}
 *   -- DER-encoded X.509 certificate stored in OCTET STRING
 *
 * sdsiCertificate BAG-TYPE ::= {IA5String IDENTIFIED BY {certTypes 2}}
 * -- Base64-encoded SDSI certificate stored in IA5String
 *
 * CertTypes BAG-TYPE ::= {
 *   x509Certificate |
 *   sdsiCertificate,
 *   ... -- For future extensions
 * }
 */
!function(){function e(e){function t(e,t,a,r){for(var s=[],n=0;n<e.length;n++)for(var o=0;o<e[n].safeBags.length;o++){var c=e[n].safeBags[o];(void 0===r||c.type===r)&&(null!==t?void 0!==c.attributes[t]&&c.attributes[t].indexOf(a)>=0&&s.push(c):s.push(c))}return s}function a(t){if(t.composed||t.constructed){for(var a=e.util.createBuffer(),r=0;r<t.value.length;++r)a.putBytes(t.value[r].value);t.composed=t.constructed=!1,t.value=a.getBytes()}return t}function r(e,t,r,o){if(t=c.fromDer(t,r),t.tagClass!==c.Class.UNIVERSAL||t.type!==c.Type.SEQUENCE||t.constructed!==!0)throw new Error("PKCS#12 AuthenticatedSafe expected to be a SEQUENCE OF ContentInfo");for(var i=0;i<t.value.length;i++){var C=t.value[i],E={},y=[];if(!c.validate(C,d,E,y)){var p=new Error("Cannot read ContentInfo.");throw p.errors=y,p}var u={encrypted:!1},T=null,S=E.content.value[0];switch(c.derToOid(E.contentType)){case l.oids.data:if(S.tagClass!==c.Class.UNIVERSAL||S.type!==c.Type.OCTETSTRING)throw new Error("PKCS#12 SafeContents Data is not an OCTET STRING.");T=a(S).value;break;case l.oids.encryptedData:T=s(S,o),u.encrypted=!0;break;default:var p=new Error("Unsupported PKCS#12 contentType.");throw p.contentType=c.derToOid(E.contentType),p}u.safeBags=n(T,r,o),e.safeContents.push(u)}}function s(t,r){var s={},n=[];if(!c.validate(t,e.pkcs7.asn1.encryptedDataValidator,s,n)){var o=new Error("Cannot read EncryptedContentInfo.");throw o.errors=n,o}var i=c.derToOid(s.contentType);if(i!==l.oids.data){var o=new Error("PKCS#12 EncryptedContentInfo ContentType is not Data.");throw o.oid=i,o}i=c.derToOid(s.encAlgorithm);var d=l.pbe.getCipher(i,s.encParameter,r),C=a(s.encryptedContentAsn1),E=e.util.createBuffer(C.value);if(d.update(E),!d.finish())throw new Error("Failed to decrypt PKCS#12 SafeContents.");return d.output.getBytes()}function n(e,t,a){if(!t&&0===e.length)return[];if(e=c.fromDer(e,t),e.tagClass!==c.Class.UNIVERSAL||e.type!==c.Type.SEQUENCE||e.constructed!==!0)throw new Error("PKCS#12 SafeContents expected to be a SEQUENCE OF SafeBag.");for(var r=[],s=0;s<e.value.length;s++){var n=e.value[s],i={},d=[];if(!c.validate(n,E,i,d)){var C=new Error("Cannot read SafeBag.");throw C.errors=d,C}var y={type:c.derToOid(i.bagId),attributes:o(i.bagAttributes)};r.push(y);var u,T,S=i.bagValue.value[0];switch(y.type){case l.oids.pkcs8ShroudedKeyBag:if(S=l.decryptPrivateKeyInfo(S,a),null===S)throw new Error("Unable to decrypt PKCS#8 ShroudedKeyBag, wrong password?");case l.oids.keyBag:try{y.key=l.privateKeyFromAsn1(S)}catch(I){y.key=null,y.asn1=S}continue;case l.oids.certBag:u=p,T=function(){if(c.derToOid(i.certId)!==l.oids.x509Certificate){var e=new Error("Unsupported certificate type, only X.509 supported.");throw e.oid=c.derToOid(i.certId),e}var a=c.fromDer(i.cert,t);try{y.cert=l.certificateFromAsn1(a,!0)}catch(r){y.cert=null,y.asn1=a}};break;default:var C=new Error("Unsupported PKCS#12 SafeBag type.");throw C.oid=y.type,C}if(void 0!==u&&!c.validate(S,u,i,d)){var C=new Error("Cannot read PKCS#12 "+u.name);throw C.errors=d,C}T()}return r}function o(e){var t={};if(void 0!==e)for(var a=0;a<e.length;++a){var r={},s=[];if(!c.validate(e[a],y,r,s)){var n=new Error("Cannot read PKCS#12 BagAttribute.");throw n.errors=s,n}var o=c.derToOid(r.oid);if(void 0!==l.oids[o]){t[l.oids[o]]=[];for(var i=0;i<r.values.length;++i)t[l.oids[o]].push(r.values[i].value)}}return t}var c=e.asn1,l=e.pki,i=e.pkcs12=e.pkcs12||{},d={name:"ContentInfo",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"ContentInfo.contentType",tagClass:c.Class.UNIVERSAL,type:c.Type.OID,constructed:!1,capture:"contentType"},{name:"ContentInfo.content",tagClass:c.Class.CONTEXT_SPECIFIC,constructed:!0,captureAsn1:"content"}]},C={name:"PFX",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"PFX.version",tagClass:c.Class.UNIVERSAL,type:c.Type.INTEGER,constructed:!1,capture:"version"},d,{name:"PFX.macData",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,optional:!0,captureAsn1:"mac",value:[{name:"PFX.macData.mac",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"PFX.macData.mac.digestAlgorithm",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"PFX.macData.mac.digestAlgorithm.algorithm",tagClass:c.Class.UNIVERSAL,type:c.Type.OID,constructed:!1,capture:"macAlgorithm"},{name:"PFX.macData.mac.digestAlgorithm.parameters",tagClass:c.Class.UNIVERSAL,captureAsn1:"macAlgorithmParameters"}]},{name:"PFX.macData.mac.digest",tagClass:c.Class.UNIVERSAL,type:c.Type.OCTETSTRING,constructed:!1,capture:"macDigest"}]},{name:"PFX.macData.macSalt",tagClass:c.Class.UNIVERSAL,type:c.Type.OCTETSTRING,constructed:!1,capture:"macSalt"},{name:"PFX.macData.iterations",tagClass:c.Class.UNIVERSAL,type:c.Type.INTEGER,constructed:!1,optional:!0,capture:"macIterations"}]}]},E={name:"SafeBag",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"SafeBag.bagId",tagClass:c.Class.UNIVERSAL,type:c.Type.OID,constructed:!1,capture:"bagId"},{name:"SafeBag.bagValue",tagClass:c.Class.CONTEXT_SPECIFIC,constructed:!0,captureAsn1:"bagValue"},{name:"SafeBag.bagAttributes",tagClass:c.Class.UNIVERSAL,type:c.Type.SET,constructed:!0,optional:!0,capture:"bagAttributes"}]},y={name:"Attribute",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"Attribute.attrId",tagClass:c.Class.UNIVERSAL,type:c.Type.OID,constructed:!1,capture:"oid"},{name:"Attribute.attrValues",tagClass:c.Class.UNIVERSAL,type:c.Type.SET,constructed:!0,capture:"values"}]},p={name:"CertBag",tagClass:c.Class.UNIVERSAL,type:c.Type.SEQUENCE,constructed:!0,value:[{name:"CertBag.certId",tagClass:c.Class.UNIVERSAL,type:c.Type.OID,constructed:!1,capture:"certId"},{name:"CertBag.certValue",tagClass:c.Class.CONTEXT_SPECIFIC,constructed:!0,value:[{name:"CertBag.certValue[0]",tagClass:c.Class.UNIVERSAL,type:c.Class.OCTETSTRING,constructed:!1,capture:"cert"}]}]};i.pkcs12FromAsn1=function(s,n,o){"string"==typeof n?(o=n,n=!0):void 0===n&&(n=!0);var d={},E=[];if(!c.validate(s,C,d,E)){var y=new Error("Cannot read PKCS#12 PFX. ASN.1 object is not an PKCS#12 PFX.");throw y.errors=y,y}var p={version:d.version.charCodeAt(0),safeContents:[],getBags:function(a){var r,s={};return"localKeyId"in a?r=a.localKeyId:"localKeyIdHex"in a&&(r=e.util.hexToBytes(a.localKeyIdHex)),void 0===r&&!("friendlyName"in a)&&"bagType"in a&&(s[a.bagType]=t(p.safeContents,null,null,a.bagType)),void 0!==r&&(s.localKeyId=t(p.safeContents,"localKeyId",r,a.bagType)),"friendlyName"in a&&(s.friendlyName=t(p.safeContents,"friendlyName",a.friendlyName,a.bagType)),s},getBagsByFriendlyName:function(e,a){return t(p.safeContents,"friendlyName",e,a)},getBagsByLocalKeyId:function(e,a){return t(p.safeContents,"localKeyId",e,a)}};if(3!==d.version.charCodeAt(0)){var y=new Error("PKCS#12 PFX of version other than 3 not supported.");throw y.version=d.version.charCodeAt(0),y}if(c.derToOid(d.contentType)!==l.oids.data){var y=new Error("Only PKCS#12 PFX in password integrity mode supported.");throw y.oid=c.derToOid(d.contentType),y}var u=d.content.value[0];if(u.tagClass!==c.Class.UNIVERSAL||u.type!==c.Type.OCTETSTRING)throw new Error("PKCS#12 authSafe content data is not an OCTET STRING.");if(u=a(u),d.mac){var T=null,S=0,I=c.derToOid(d.macAlgorithm);switch(I){case l.oids.sha1:T=e.md.sha1.create(),S=20;break;case l.oids.sha256:T=e.md.sha256.create(),S=32;break;case l.oids.sha384:T=e.md.sha384.create(),S=48;break;case l.oids.sha512:T=e.md.sha512.create(),S=64;break;case l.oids.md5:T=e.md.md5.create(),S=16}if(null===T)throw new Error("PKCS#12 uses unsupported MAC algorithm: "+I);var g=new e.util.ByteBuffer(d.macSalt),f="macIterations"in d?parseInt(e.util.bytesToHex(d.macIterations),16):1,N=i.generateKey(o,g,3,f,S,T),v=e.hmac.create();v.start(T,N),v.update(u.value);var m=v.getMac();if(m.getBytes()!==d.macDigest)throw new Error("PKCS#12 MAC could not be verified. Invalid password?")}return r(p,u.value,n,o),p},i.toPkcs12Asn1=function(t,a,r,s){s=s||{},s.saltSize=s.saltSize||8,s.count=s.count||2048,s.algorithm=s.algorithm||s.encAlgorithm||"aes128","useMac"in s||(s.useMac=!0),"localKeyId"in s||(s.localKeyId=null),"generateLocalKeyId"in s||(s.generateLocalKeyId=!0);var n,o=s.localKeyId;if(null!==o)o=e.util.hexToBytes(o);else if(s.generateLocalKeyId)if(a){var d=e.util.isArray(a)?a[0]:a;"string"==typeof d&&(d=l.certificateFromPem(d));var C=e.md.sha1.create();C.update(c.toDer(l.certificateToAsn1(d)).getBytes()),o=C.digest().getBytes()}else o=e.random.getBytes(20);var E=[];null!==o&&E.push(c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.localKeyId).getBytes()),c.create(c.Class.UNIVERSAL,c.Type.SET,!0,[c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,o)])])),"friendlyName"in s&&E.push(c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.friendlyName).getBytes()),c.create(c.Class.UNIVERSAL,c.Type.SET,!0,[c.create(c.Class.UNIVERSAL,c.Type.BMPSTRING,!1,s.friendlyName)])])),E.length>0&&(n=c.create(c.Class.UNIVERSAL,c.Type.SET,!0,E));var y=[],p=[];null!==a&&(p=e.util.isArray(a)?a:[a]);for(var u=[],T=0;T<p.length;++T){a=p[T],"string"==typeof a&&(a=l.certificateFromPem(a));var S=0===T?n:void 0,I=l.certificateToAsn1(a),g=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.certBag).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.x509Certificate).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,c.toDer(I).getBytes())])])]),S]);u.push(g)}if(u.length>0){var f=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,u),N=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.data).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,c.toDer(f).getBytes())])]);y.push(N)}var v=null;if(null!==t){var m=l.wrapRsaPrivateKey(l.privateKeyToAsn1(t));v=null===r?c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.keyBag).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[m]),n]):c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.pkcs8ShroudedKeyBag).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[l.encryptPrivateKeyInfo(m,r,s)]),n]);var A=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[v]),U=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.data).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,c.toDer(A).getBytes())])]);y.push(U)}var h,R=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,y);if(s.useMac){var C=e.md.sha1.create(),V=new e.util.ByteBuffer(e.random.getBytes(s.saltSize)),L=s.count,t=i.generateKey(r,V,3,L,20),B=e.hmac.create();B.start(C,t),B.update(c.toDer(R).getBytes());var O=B.getMac();h=c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.sha1).getBytes()),c.create(c.Class.UNIVERSAL,c.Type.NULL,!1,"")]),c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,O.getBytes())]),c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,V.getBytes()),c.create(c.Class.UNIVERSAL,c.Type.INTEGER,!1,c.integerToDer(L).getBytes())])}return c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.INTEGER,!1,c.integerToDer(3).getBytes()),c.create(c.Class.UNIVERSAL,c.Type.SEQUENCE,!0,[c.create(c.Class.UNIVERSAL,c.Type.OID,!1,c.oidToDer(l.oids.data).getBytes()),c.create(c.Class.CONTEXT_SPECIFIC,0,!0,[c.create(c.Class.UNIVERSAL,c.Type.OCTETSTRING,!1,c.toDer(R).getBytes())])]),h])},i.generateKey=e.pbe.generatePkcs12Key}var t="pkcs12";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var a=!0;define=function(e,t){t(require,module)}}var r,s=function(a,s){s.exports=function(s){var n=r.map(function(e){return a(e)}).concat(e);if(s=s||{},s.defined=s.defined||{},s.defined[t])return s[t];s.defined[t]=!0;for(var o=0;o<n.length;++o)n[o](s);return s[t]}},n=define;define=function(e,t){return r="string"==typeof e?t.slice(2):e.slice(2),a?(delete define,n.apply(null,Array.prototype.slice.call(arguments,0))):(define=n,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./asn1","./hmac","./oids","./pkcs7asn1","./pbe","./random","./rsa","./sha1","./util","./x509"],function(){s.apply(null,Array.prototype.slice.call(arguments,0))})}();