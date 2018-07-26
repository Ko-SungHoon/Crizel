/**
 * Node.js module for Forge message digests.
 *
 * @author Dave Longley
 *
 * Copyright 2011-2014 Digital Bazaar, Inc.
 */
!function(){function e(e){e.md=e.md||{},e.md.algorithms={md5:e.md5,sha1:e.sha1,sha256:e.sha256},e.md.md5=e.md5,e.md.sha1=e.sha1,e.md.sha256=e.sha256}var n="md";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var r=!0;define=function(e,n){n(require,module)}}var d,t=function(r,t){t.exports=function(t){var i=d.map(function(e){return r(e)}).concat(e);if(t=t||{},t.defined=t.defined||{},t.defined[n])return t[n];t.defined[n]=!0;for(var f=0;f<i.length;++f)i[f](t);return t[n]}},i=define;define=function(e,n){return d="string"==typeof e?n.slice(2):e.slice(2),r?(delete define,i.apply(null,Array.prototype.slice.call(arguments,0))):(define=i,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./md5","./sha1","./sha256","./sha512"],function(){t.apply(null,Array.prototype.slice.call(arguments,0))})}();