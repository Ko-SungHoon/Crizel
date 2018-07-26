/**
 * Node.js module for Forge.
 *
 * @author Dave Longley
 *
 * Copyright 2011-2014 Digital Bazaar, Inc.
 */
!function(){var e="forge",r="1.1.0.1",n=function(){return r};if("function"!=typeof define){if("object"!=typeof module||!module.exports)return"undefined"==typeof forge&&(forge={disableNativeCode:!1}),void(forge.getVersion||(forge.getVersion=n));var i=!0;define=function(e,r){r(require,module)}}var t,o=function(r,i){i.exports=function(i){var o=t.map(function(e){return r(e)});if(i=i||{},i.defined=i.defined||{},i.getVersion||(i.getVersion=n),i.defined[e])return i[e];i.defined[e]=!0;for(var f=0;f<o.length;++f)o[f](i);return i},i.exports.disableNativeCode=!1,i.exports(i.exports)},f=define;define=function(e,r){return t="string"==typeof e?r.slice(2):e.slice(2),i?(delete define,f.apply(null,Array.prototype.slice.call(arguments,0))):(define=f,define.apply(null,Array.prototype.slice.call(arguments,0)))},define(["require","module","./aes","./aesCipherSuites","./asn1","./cipher","./cipherModes","./debug","./des","./hmac","./kem","./log","./md","./mgf1","./pbkdf2","./pem","./pkcs7","./pkcs1","./pkcs12","./pki","./prime","./prng","./pss","./random","./rc2","./seed","./ssh","./task","./tls","./util"],function(){o.apply(null,Array.prototype.slice.call(arguments,0))})}();