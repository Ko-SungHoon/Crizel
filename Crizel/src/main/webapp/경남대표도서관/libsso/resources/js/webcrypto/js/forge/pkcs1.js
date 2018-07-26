/**
 * Partial implementation of PKCS#1 v2.2: RSA-OEAP
 *
 * Modified but based on the following MIT and BSD licensed code:
 *
 * https://github.com/kjur/jsjws/blob/master/rsa.js:
 *
 * The 'jsjws'(JSON Web Signature JavaScript Library) License
 *
 * Copyright (c) 2012 Kenji Urushima
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://webrsa.cvs.sourceforge.net/viewvc/webrsa/Client/RSAES-OAEP.js?content-type=text%2Fplain:
 *
 * RSAES-OAEP.js
 * $Id: RSAES-OAEP.js,v 1.1.1.1 2003/03/19 15:37:20 ellispritchard Exp $
 * JavaScript Implementation of PKCS #1 v2.1 RSA CRYPTOGRAPHY STANDARD (RSA Laboratories, June 14, 2002)
 * Copyright (C) Ellis Pritchard, Guardian Unlimited 2003.
 * Contact: ellis@nukinetics.com
 * Distributed under the BSD License.
 *
 * Official documentation: http://www.rsa.com/rsalabs/node.asp?id=2125
 *
 * @author Evan Jones (http://evanjones.ca/)
 * @author Dave Longley
 *
 * Copyright (c) 2013-2014 Digital Bazaar, Inc.
 */
!function(){function e(e){function t(t,n,r){r||(r=e.md.sha1.create());for(var g="",i=Math.ceil(n/r.digestLength),d=0;i>d;++d){var s=String.fromCharCode(d>>24&255,d>>16&255,d>>8&255,255&d);r.start(),r.update(t+s),g+=r.digest().getBytes()}return g.substring(0,n)}function n(t,n,r){r||(r=e.md.sha1.create());for(var g="",i=Math.ceil(n/r.digestLength)-1,d=0;i>d;++d){var s=String.fromCharCode(d>>24&255,d>>16&255,d>>8&255,255&d);r.start(),r.update(t+s),g+=r.digest().getBytes()}for(var a=n-g.length,d=0;a>d;d++)g+="\x00";return g.substring(0,n)}var r=e.pkcs1=e.pkcs1||{};r.encode_rsa_oaep=function(n,r,g){var i,d,s,a;"string"==typeof g?(i=g,d=arguments[3]||void 0,s=arguments[4]||void 0):g&&(i=g.label||void 0,d=g.seed||void 0,s=g.md||void 0,g.mgf1&&g.mgf1.md&&(a=g.mgf1.md)),s?s.start():s=e.md.sha1.create(),a||(a=s);var o=Math.ceil(n.n.bitLength()/8),h=o-2*s.digestLength-2;if(r.length>h){var l=new Error("RSAES-OAEP input message length is too long.");throw l.length=r.length,l.maxLength=h,l}i||(i=""),s.update(i,"raw");for(var f=s.digest(),u="",c=h-r.length,m=0;c>m;m++)u+="\x00";var v=f.getBytes()+u+""+r;if(d){if(d.length!==s.digestLength){var l=new Error("Invalid RSAES-OAEP seed. The seed length must match the digest length.");throw l.seedLength=d.length,l.digestLength=s.digestLength,l}}else d=e.random.getBytes(s.digestLength);var p=t(d,o-s.digestLength-1,a),L=e.util.xorBytes(v,p,v.length),y=t(L,s.digestLength,a),A=e.util.xorBytes(d,y,d.length);return"\x00"+A+L},r.encode_rsa_oaep_old=function(t,r,g){var i,d,s,a;"string"==typeof g?(i=g,d=arguments[3]||void 0,s=arguments[4]||void 0):g&&(i=g.label||void 0,d=g.seed||void 0,s=g.md||void 0,g.mgf1&&g.mgf1.md&&(a=g.mgf1.md)),s?s.start():s=e.md.sha1.create(),a||(a=s);var o=Math.ceil(t.n.bitLength()/8)-1,h=o-2*s.digestLength-1;if(r.length>h){var l=new Error("RSAES-OAEP input message length is too long.");throw l.length=r.length,l.maxLength=h,l}i||(i=""),s.update(i,"raw");for(var f=s.digest(),u="",c=h-r.length,m=0;c>m;m++)u+="\x00";var v=f.getBytes()+u+""+r;if(d){if(d.length!==s.digestLength){var l=new Error("Invalid RSAES-OAEP seed. The seed length must match the digest length.");throw l.seedLength=d.length,l.digestLength=s.digestLength,l}}else d=e.random.getBytes(s.digestLength);var p=n(d,o-s.digestLength,a),L=e.util.xorBytes(v,p,o-s.digestLength),y=n(L,s.digestLength,a),A=e.util.xorBytes(d,y,d.length);return A+L},r.decode_rsa_oaep=function(n,r,g){var i,d,s;"string"==typeof g?(i=g,d=arguments[3]||void 0):g&&(i=g.label||void 0,d=g.md||void 0,g.mgf1&&g.mgf1.md&&(s=g.mgf1.md));var a=Math.ceil(n.n.bitLength()/8);if(r.length!==a){var o=new Error("RSAES-OAEP encoded message length is invalid.");throw o.length=r.length,o.expectedLength=a,o}if(void 0===d?d=e.md.sha1.create():d.start(),s||(s=d),a<2*d.digestLength+2)throw new Error("RSAES-OAEP key is too short for the hash function.");i||(i=""),d.update(i,"raw");for(var h=d.digest().getBytes(),l=r.charAt(0),f=r.substring(1,d.digestLength+1),u=r.substring(1+d.digestLength),c=t(u,d.digestLength,s),m=e.util.xorBytes(f,c,f.length),v=t(m,a-d.digestLength-1,s),p=e.util.xorBytes(u,v,u.length),L=p.substring(0,d.digestLength),o="\x00"!==l,y=0;y<d.digestLength;++y)o|=h.charAt(y)!==L.charAt(y);for(var A=1,E=d.digestLength,w=d.digestLength;w<p.length;w++){var x=p.charCodeAt(w),S=1&x^1,b=A?65534:0;o|=x&b,A&=S,E+=A}if(o||1!==p.charCodeAt(E))throw new Error("Invalid RSAES-OAEP padding.");return p.substring(E+1)}}var t="pkcs1";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var n=!0;define=function(e,t){t(require,module)}}var r,g=function(n,g){g.exports=function(g){var i=r.map(function(e){return n(e)}).concat(e);if(g=g||{},g.defined=g.defined||{},g.defined[t])return g[t];g.defined[t]=!0;for(var d=0;d<i.length;++d)i[d](g);return g[t]}},i=define;define=function(e,t){return r="string"==typeof e?t.slice(2):e.slice(2),n?(delete define,i.apply(null,Array.prototype.slice.call(arguments,0))):(define=i,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./util","./random","./sha1"],function(){g.apply(null,Array.prototype.slice.call(arguments,0))})}();