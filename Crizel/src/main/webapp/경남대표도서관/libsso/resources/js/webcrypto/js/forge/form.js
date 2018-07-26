/**
 * Functions for manipulating web forms.
 *
 * @author David I. Lehn <dlehn@digitalbazaar.com>
 * @author Dave Longley
 * @author Mike Johnson
 *
 * Copyright (c) 2011-2014 Digital Bazaar, Inc. All rights reserved.
 */
!function(e){var n={},t=/(.*?)\[(.*?)\]/g,i=function(e){for(var n,i=[];n=t.exec(e);)n[1].length>0&&i.push(n[1]),n.length>=2&&i.push(n[2]);return 0===i.length&&i.push(e),i},r=function(n,t,r,h){for(var f=[],l=0;l<t.length;++l){var a=t[l];if(-1!==a.indexOf("[")&&-1===a.indexOf("]")&&l<t.length-1)do a+="."+t[++l];while(l<t.length-1&&-1===t[l].indexOf("]"));f.push(a)}t=f;var f=[];e.each(t,function(e,n){f=f.concat(i(n))}),t=f,e.each(t,function(i,f){if(h&&0!==f.length&&f in h&&(f=h[f]),0===f.length&&(f=n.length),n[f])i==t.length-1?(e.isArray(n[f])||(n[f]=[n[f]]),n[f].push(r)):n=n[f];else if(i==t.length-1)n[f]=r;else{var l=t[i+1];if(0===l.length)n[f]=[];else{var a=l-0==l&&l.length>0;n[f]=a?[]:{}}n=n[f]}})};n.serialize=function(n,t,i){var h={};return t=t||".",e.each(n.serializeArray(),function(){r(h,this.name.split(t),this.value||"",i)}),h},"undefined"==typeof forge&&(forge={}),forge.form=n}(jQuery);