/**
 * Javascript implementation of basic PEM (Privacy Enhanced Mail) algorithms.
 *
 * See: RFC 1421.
 *
 * @author Dave Longley
 *
 * Copyright (c) 2013-2014 Digital Bazaar, Inc.
 *
 * A Forge PEM object has the following fields:
 *
 * type: identifies the type of message (eg: "RSA PRIVATE KEY").
 *
 * procType: identifies the type of processing performed on the message,
 *   it has two subfields: version and type, eg: 4,ENCRYPTED.
 *
 * contentDomain: identifies the type of content in the message, typically
 *   only uses the value: "RFC822".
 *
 * dekInfo: identifies the message encryption algorithm and mode and includes
 *   any parameters for the algorithm, it has two subfields: algorithm and
 *   parameters, eg: DES-CBC,F8143EDE5960C597.
 *
 * headers: contains all other PEM encapsulated headers -- where order is
 *   significant (for pairing data like recipient ID + key info).
 *
 * body: the binary-encoded body.
 */
!function(){function e(e){function r(e){for(var r=e.name+": ",n=[],t=function(e,r){return" "+r},o=0;o<e.values.length;++o)n.push(e.values[o].replace(/^(\S+\r\n)/,t));r+=n.join(",")+"\r\n";for(var a=0,i=-1,o=0;o<r.length;++o,++a)if(a>65&&-1!==i){var s=r[i];","===s?(++i,r=r.substr(0,i)+"\r\n "+r.substr(i)):r=r.substr(0,i)+"\r\n"+s+r.substr(i+1),a=o-i-1,i=-1,++o}else(" "===r[o]||"	"===r[o]||","===r[o])&&(i=o);return r}function n(e){return e.replace(/^\s+/,"")}var t=e.pem=e.pem||{};t.encode=function(n,t){t=t||{};var o,a="-----BEGIN "+n.type+"-----\r\n";if(n.procType&&(o={name:"Proc-Type",values:[String(n.procType.version),n.procType.type]},a+=r(o)),n.contentDomain&&(o={name:"Content-Domain",values:[n.contentDomain]},a+=r(o)),n.dekInfo&&(o={name:"DEK-Info",values:[n.dekInfo.algorithm]},n.dekInfo.parameters&&o.values.push(n.dekInfo.parameters),a+=r(o)),n.headers)for(var i=0;i<n.headers.length;++i)a+=r(n.headers[i]);return n.procType&&(a+="\r\n"),a+=e.util.encode64(n.body,t.maxline||64)+"\r\n",a+="-----END "+n.type+"-----\r\n"},t.decode=function(r){for(var t,o=[],a=/\s*-----BEGIN ([A-Z0-9- ]+)-----\r?\n?([\x21-\x7e\s]+?(?:\r?\n\r?\n))?([:A-Za-z0-9+\/=\s]+?)-----END \1-----/g,i=/([\x21-\x7e]+):\s*([\x21-\x7e\s^:]+)/,s=/\r?\n/;;){if(t=a.exec(r),!t)break;var f={type:t[1],procType:null,contentDomain:null,dekInfo:null,headers:[],body:e.util.decode64(t[3])};if(o.push(f),t[2]){for(var l=t[2].split(s),u=0;t&&u<l.length;){for(var p=l[u].replace(/\s+$/,""),d=u+1;d<l.length;++d){var c=l[d];if(!/\s/.test(c[0]))break;p+=c,u=d}if(t=p.match(i)){for(var m={name:t[1],values:[]},h=t[2].split(","),v=0;v<h.length;++v)m.values.push(n(h[v]));if(f.procType)if(f.contentDomain||"Content-Domain"!==m.name)if(f.dekInfo||"DEK-Info"!==m.name)f.headers.push(m);else{if(0===m.values.length)throw new Error('Invalid PEM formatted message. The "DEK-Info" header must have at least one subfield.');f.dekInfo={algorithm:h[0],parameters:h[1]||null}}else f.contentDomain=h[0]||"";else{if("Proc-Type"!==m.name)throw new Error('Invalid PEM formatted message. The first encapsulated header must be "Proc-Type".');if(2!==m.values.length)throw new Error('Invalid PEM formatted message. The "Proc-Type" header must have two subfields.');f.procType={version:h[0],type:h[1]}}}++u}if("ENCRYPTED"===f.procType&&!f.dekInfo)throw new Error('Invalid PEM formatted message. The "DEK-Info" header must be present if "Proc-Type" is "ENCRYPTED".')}}if(0===o.length)throw new Error("Invalid PEM formatted message.");return o}}var r="pem";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var n=!0;define=function(e,r){r(require,module)}}var t,o=function(n,o){o.exports=function(o){var a=t.map(function(e){return n(e)}).concat(e);if(o=o||{},o.defined=o.defined||{},o.defined[r])return o[r];o.defined[r]=!0;for(var i=0;i<a.length;++i)a[i](o);return o[r]}},a=define;define=function(e,r){return t="string"==typeof e?r.slice(2):e.slice(2),n?(delete define,a.apply(null,Array.prototype.slice.call(arguments,0))):(define=a,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./util"],function(){o.apply(null,Array.prototype.slice.call(arguments,0))})}();