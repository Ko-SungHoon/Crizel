/**
 * Javascript implementation of mask generation function MGF1.
 *
 * @author Stefan Siegl
 * @author Dave Longley
 *
 * Copyright (c) 2012 Stefan Siegl <stesie@brokenpipe.de>
 * Copyright (c) 2014 Digital Bazaar, Inc.
 */
!function(){function e(e){e.mgf=e.mgf||{};var t=e.mgf.mgf1=e.mgf1=e.mgf1||{};t.create=function(t){var n={generate:function(n,r){for(var f=new e.util.ByteBuffer,i=Math.ceil(r/t.digestLength),u=0;i>u;u++){var o=new e.util.ByteBuffer;o.putInt32(u),t.start(),t.update(n+o.getBytes()),f.putBuffer(t.digest())}return f.truncate(f.length()-r),f.getBytes()}};return n}}var t="mgf1";if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={}),e(forge);var n=!0;define=function(e,t){t(require,module)}}var r,f=function(n,f){f.exports=function(f){var i=r.map(function(e){return n(e)}).concat(e);if(f=f||{},f.defined=f.defined||{},f.defined[t])return f[t];f.defined[t]=!0;for(var u=0;u<i.length;++u)i[u](f);return f[t]}},i=define;define=function(e,t){return r="string"==typeof e?t.slice(2):e.slice(2),n?(delete define,i.apply(null,Array.prototype.slice.call(arguments,0))):(define=i,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./util"],function(){f.apply(null,Array.prototype.slice.call(arguments,0))})}();