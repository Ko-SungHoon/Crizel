/**
 * Debugging support for web applications.
 *
 * @author David I. Lehn <dlehn@digitalbazaar.com>
 *
 * Copyright 2008-2013 Digital Bazaar, Inc.
 */
!function(){function e(e){e.debug=e.debug||{},e.debug.storage={},e.debug.get=function(n,t){var r;return"undefined"==typeof n?r=e.debug.storage:n in e.debug.storage&&(r="undefined"==typeof t?e.debug.storage[n]:e.debug.storage[n][t]),r},e.debug.set=function(n,t,r){n in e.debug.storage||(e.debug.storage[n]={}),e.debug.storage[n][t]=r},e.debug.clear=function(n,t){"undefined"==typeof n?e.debug.storage={}:n in e.debug.storage&&("undefined"==typeof t?delete e.debug.storage[n]:delete e.debug.storage[n][t])}}var n="debug";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var t=!0;define=function(e,n){n(require,module)}}var r,u=function(t,u){u.exports=function(u){var d=r.map(function(e){return t(e)}).concat(e);if(u=u||{},u.defined=u.defined||{},u.defined[n])return u[n];u.defined[n]=!0;for(var o=0;o<d.length;++o)d[o](u);return u[n]}},d=define;define=function(e,n){return r="string"==typeof e?n.slice(2):e.slice(2),t?(delete define,d.apply(null,Array.prototype.slice.call(arguments,0))):(define=d,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module"],function(){u.apply(null,Array.prototype.slice.call(arguments,0))})}();