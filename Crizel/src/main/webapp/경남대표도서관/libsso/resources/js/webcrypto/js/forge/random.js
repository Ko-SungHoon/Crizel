/**
 * An API for getting cryptographically-secure random bytes. The bytes are
 * generated using the Fortuna algorithm devised by Bruce Schneier and
 * Niels Ferguson.
 *
 * Getting strong random bytes is not yet easy to do in javascript. The only
 * truish random entropy that can be collected is from the mouse, keyboard, or
 * from timing with respect to page loads, etc. This generator makes a poor
 * attempt at providing random bytes when those sources haven't yet provided
 * enough entropy to initially seed or to reseed the PRNG.
 *
 * @author Dave Longley
 *
 * Copyright (c) 2009-2014 Digital Bazaar, Inc.
 */
!function(){function e(e){e.random&&e.random.getBytes||!function(n){function t(){var n=e.prng.create(r);return n.getBytes=function(e,t){return n.generate(e,t)},n.getBytesSync=function(e){return n.generate(e)},n}var r={},o=new Array(4),i=e.util.createBuffer();r.formatKey=function(n){var t=e.util.createBuffer(n);return n=new Array(4),n[0]=t.getInt32(),n[1]=t.getInt32(),n[2]=t.getInt32(),n[3]=t.getInt32(),e.aes._expandKey(n,!1)},r.formatSeed=function(n){var t=e.util.createBuffer(n);return n=new Array(4),n[0]=t.getInt32(),n[1]=t.getInt32(),n[2]=t.getInt32(),n[3]=t.getInt32(),n},r.cipher=function(n,t){return e.aes._updateBlock(n,t,o,!1),i.putInt32(o[0]),i.putInt32(o[1]),i.putInt32(o[2]),i.putInt32(o[3]),i.getBytes()},r.increment=function(e){return++e[3],e},r.md=e.md.sha256;var u=t(),a="undefined"!=typeof process&&process.versions&&process.versions.node,f=null;if("undefined"!=typeof window){var c=window.crypto||window.msCrypto;c&&c.getRandomValues&&(f=function(e){return c.getRandomValues(e)})}if(e.disableNativeCode||!a&&!f){if("undefined"==typeof window||void 0===window.document,u.collectInt(+new Date,32),"undefined"!=typeof navigator){var d="";for(var l in navigator)try{"string"==typeof navigator[l]&&(d+=navigator[l])}catch(p){}u.collect(d),d=null}n&&(n().mousemove(function(e){u.collectInt(e.clientX,16),u.collectInt(e.clientY,16)}),n().keypress(function(e){u.collectInt(e.charCode,8)}))}if(e.random)for(var l in u)e.random[l]=u[l];else e.random=u;e.random.createInstance=t}("undefined"!=typeof jQuery?jQuery:null)}var n="random";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var t=!0;define=function(e,n){n(require,module)}}var r,o=function(t,o){o.exports=function(o){var i=r.map(function(e){return t(e)}).concat(e);if(o=o||{},o.defined=o.defined||{},o.defined[n])return o[n];o.defined[n]=!0;for(var u=0;u<i.length;++u)i[u](o);return o[n]}},i=define;define=function(e,n){return r="string"==typeof e?n.slice(2):e.slice(2),t?(delete define,i.apply(null,Array.prototype.slice.call(arguments,0))):(define=i,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./aes","./md","./prng","./util"],function(){o.apply(null,Array.prototype.slice.call(arguments,0))})}();