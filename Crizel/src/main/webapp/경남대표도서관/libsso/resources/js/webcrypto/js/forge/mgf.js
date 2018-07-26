/**
 * Node.js module for Forge mask generation functions.
 *
 * @author Stefan Siegl
 *
 * Copyright 2012 Stefan Siegl <stesie@brokenpipe.de>
 */
!function(){function e(e){e.mgf=e.mgf||{},e.mgf.mgf1=e.mgf1}var n="mgf";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var f=!0;define=function(e,n){n(require,module)}}var r,t=function(f,t){t.exports=function(t){var i=r.map(function(e){return f(e)}).concat(e);if(t=t||{},t.defined=t.defined||{},t.defined[n])return t[n];t.defined[n]=!0;for(var o=0;o<i.length;++o)i[o](t);return t[n]}},i=define;define=function(e,n){return r="string"==typeof e?n.slice(2):e.slice(2),f?(delete define,i.apply(null,Array.prototype.slice.call(arguments,0))):(define=i,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./mgf1"],function(){t.apply(null,Array.prototype.slice.call(arguments,0))})}();