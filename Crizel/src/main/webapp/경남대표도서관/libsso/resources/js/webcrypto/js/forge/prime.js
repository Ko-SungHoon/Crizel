/**
 * Prime number generation API.
 *
 * @author Dave Longley
 *
 * Copyright (c) 2014 Digital Bazaar, Inc.
 */
!function(){function e(e){function n(e,n,i,o){return"workers"in i?t(e,n,i,o):r(e,n,i,o)}function r(n,t,f,a){var l=i(n,t),d=0,s=o(l.bitLength());"millerRabinTests"in f&&(s=f.millerRabinTests);var c=10;"maxBlockTime"in f&&(c=f.maxBlockTime);var m=+new Date;do{if(l.bitLength()>n&&(l=i(n,t)),l.isProbablePrime(s))return a(null,l);l.dAddOffset(u[d++%8],0)}while(0>c||+new Date-m<c);e.util.setImmediate(function(){r(n,t,f,a)})}function t(n,t,o,f){function u(){function e(e){if(!p){--u;var o=e.data;if(o.found){for(var d=0;d<r.length;++d)r[d].terminate();return p=!0,f(null,new a(o.prime,16))}l.bitLength()>n&&(l=i(n,t));var m=l.toString(16);e.target.postMessage({hex:m,workLoad:s}),l.dAddOffset(c,0)}}d=Math.max(1,d);for(var r=[],o=0;d>o;++o)r[o]=new Worker(m);for(var u=d,o=0;d>o;++o)r[o].addEventListener("message",e);var p=!1}if("undefined"==typeof Worker)return r(n,t,o,f);var l=i(n,t),d=o.workers,s=o.workLoad||100,c=30*s/8,m=o.workerScript||"forge/prime.worker.js";return-1===d?e.util.estimateCores(function(e,n){e&&(n=2),d=n-1,u()}):void u()}function i(e,n){var r=new a(e,n),t=e-1;return r.testBit(t)||r.bitwiseTo(a.ONE.shiftLeft(t),d,r),r.dAddOffset(31-r.mod(l).byteValue(),0),r}function o(e){return 100>=e?27:150>=e?18:200>=e?15:250>=e?12:300>=e?9:350>=e?8:400>=e?7:500>=e?6:600>=e?5:800>=e?4:1250>=e?3:2}if(!e.prime){var f=e.prime=e.prime||{},a=e.jsbn.BigInteger,u=[6,4,2,4,2,4,6,2],l=new a(null);l.fromInt(30);var d=function(e,n){return e|n};f.generateProbablePrime=function(r,t,i){"function"==typeof t&&(i=t,t={}),t=t||{};var o=t.algorithm||"PRIMEINC";"string"==typeof o&&(o={name:o}),o.options=o.options||{};var f=t.prng||e.random,a={nextBytes:function(e){for(var n=f.getBytesSync(e.length),r=0;r<e.length;++r)e[r]=n.charCodeAt(r)}};if("PRIMEINC"===o.name)return n(r,a,o.options,i);throw new Error("Invalid prime generation algorithm: "+o.name)}}}var n="prime";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var r=!0;define=function(e,n){n(require,module)}}var t,i=function(r,i){i.exports=function(i){var o=t.map(function(e){return r(e)}).concat(e);if(i=i||{},i.defined=i.defined||{},i.defined[n])return i[n];i.defined[n]=!0;for(var f=0;f<o.length;++f)o[f](i);return i[n]}},o=define;define=function(e,n){return t="string"==typeof e?n.slice(2):e.slice(2),r?(delete define,o.apply(null,Array.prototype.slice.call(arguments,0))):(define=o,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./util","./jsbn","./random"],function(){i.apply(null,Array.prototype.slice.call(arguments,0))})}();